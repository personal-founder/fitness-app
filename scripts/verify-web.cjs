// metadata_version: 1
// purpose: "Reuse an installed official Playwright module; no npm dependencies in Flutter."
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0034, ADR-0035, ADR-0044]

const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const playwright = require(process.env.MACRO_PLAYWRIGHT_MODULE || 'playwright');
async function main() {
  const out = path.resolve('output/playwright');
  fs.mkdirSync(out, { recursive: true });
  const browser = await playwright.chromium.launch({ headless: true,
    channel: process.env.MACRO_BROWSER_CHANNEL || undefined });
  try {
    for (const colorScheme of ['light', 'dark']) {
      const page = await browser.newPage({ viewport: { width: 390, height: 844 }, colorScheme });
      const errors = [];
      page.on('pageerror', e => errors.push(e.message));
      await page.goto(process.env.MACRO_WEB_URL || 'http://127.0.0.1:8080/');
      await page.getByRole('button', { name: 'Enable accessibility' }).evaluate(el => el.click());
      await page.getByRole('button', { name: 'Sign Up', exact: true }).waitFor();
      await page.screenshot({ path: path.join(out, `login-${colorScheme}.png`) });
      const email = page.getByRole('textbox', { name: 'Email', exact: true });
      await email.click();
      await email.pressSequentially('test@example.com');
      const password = page.getByRole('textbox', { name: 'Password', exact: true });
      await password.click();
      await password.pressSequentially('synthetic password');
      assert.equal(await email.inputValue(), 'test@example.com');
      await page.emulateMedia({ colorScheme: colorScheme === 'dark' ? 'light' : 'dark' });
      assert.equal(await email.inputValue(), 'test@example.com');
      await page.emulateMedia({ colorScheme });
      await page.getByRole('button', { name: 'Continue', exact: true }).click();
      await page.getByText('Connect Supabase to use accounts.').first().waitFor();
      assert.equal(await page.getByText('King James', { exact: true }).count(), 0);
      await page.getByRole('button', { name: 'Sign Up', exact: true }).click();
      await page.getByRole('textbox', { name: 'First name', exact: true }).waitFor();
      await page.screenshot({ path: path.join(out, `sign-up-${colorScheme}.png`), fullPage: true });
      await page.getByRole('button', { name: 'Back to Log In', exact: true }).click();
      await page.getByRole('button', { name: 'Open menu', exact: true }).click();
      await page.getByText('Settings', { exact: true }).waitFor();
      await page.getByRole('button', { name: 'Close menu', exact: true }).click();
      assert.deepEqual(errors, []);
      console.log(`${colorScheme}: login, theme preservation, signup/back, drawer; no page errors`);
      await page.close();
    }
    if (process.env.MACRO_PREVIEW_URL) {
      for (const colorScheme of ['light', 'dark']) {
        const page = await browser.newPage({ viewport: { width: 390, height: 844 }, colorScheme });
        await page.goto(process.env.MACRO_PREVIEW_URL);
        await page.getByRole('button', { name: 'Enable accessibility' }).evaluate(el => el.click());
        await page.getByRole('textbox', { name: 'Email', exact: true }).click();
        await page.getByRole('textbox', { name: 'Email', exact: true }).pressSequentially('demo@gmail.com');
        await page.getByRole('textbox', { name: 'Password', exact: true }).click();
        await page.getByRole('textbox', { name: 'Password', exact: true }).pressSequentially('demo123');
        await page.getByRole('button', { name: 'Continue', exact: true }).click();
        await page.getByText('King James', { exact: true }).waitFor();
        await page.screenshot({ path: path.join(out, `locked-${colorScheme}.png`) });
        assert.equal(await page.getByRole('textbox', { name: 'Email', exact: true }).count(), 0);
        await page.getByText('Enter Passcode', { exact: true }).waitFor();
        console.log(`${colorScheme}: King James demo lock; no email field`);
        await page.close();
      }
    }
  } finally { await browser.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });

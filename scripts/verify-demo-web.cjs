// metadata_version: 1
// purpose: Check the rendered demo, persistent appearance and independently decode QR pixels.
// owner: unassigned
// related_adrs: [ADR-0025, ADR-0035, ADR-0036, ADR-0044, ADR-0042, ADR-0045]
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const playwright = require(process.env.MACRO_PLAYWRIGHT_MODULE || 'playwright');
const { PNG } = require(process.env.MACRO_PNG_MODULE || 'pngjs');
const jsQR = require(process.env.MACRO_QR_MODULE || 'jsqr');
async function accessibility(page) {
  const enable = page.getByRole('button', { name: 'Enable accessibility' });
  await enable.evaluate(el => el.click());
}
async function settings(page) {
  await page.getByRole('button', { name: 'Open menu', exact: true }).click();
  await page.getByText('Settings', { exact: true }).click();
}
async function enterPin(pin, value) {
  await pin.click();
  await pin.press('ControlOrMeta+A');
  await pin.press('Backspace');
  await pin.pressSequentially(value);
}
async function login(page) {
  const email = page.getByRole('textbox', { name: 'Email', exact: true });
  await email.click();
  await email.pressSequentially('demo@gmail.com');
  const password = page.getByRole('textbox', { name: 'Password', exact: true });
  await password.click();
  await password.pressSequentially('demo123');
  await page.getByRole('button', { name: 'Continue', exact: true }).click();
  await page.getByText('Enter Passcode', { exact: true }).waitFor();
}
async function main() {
  const out = path.resolve('output/playwright');
  fs.mkdirSync(out, { recursive: true });
  const browser = await playwright.chromium.launch({ headless: true,
    channel: process.env.MACRO_BROWSER_CHANNEL || undefined });
  try {
    for (const width of [390, 1440]) {
      for (const colorScheme of ['light', 'dark']) {
        const page = await browser.newPage({ viewport: { width, height: 960 }, colorScheme });
        const errors = [];
        page.on('pageerror', e => errors.push(e.message));
        await page.goto(process.env.MACRO_PREVIEW_URL || 'http://127.0.0.1:8081/');
        await accessibility(page);
        await login(page);
        await page.getByText('Signed in as King James', { exact: true }).waitFor();
        await page.getByText('Enter Passcode', { exact: true }).waitFor();
        await page.screenshot({ path: path.join(out, `lock-${width}-${colorScheme}.png`) });
        await page.getByRole('button', { name: 'Forgot Passcode?', exact: true }).click();
        await page.getByRole('button', { name: 'Show profile QR code' }).click();
        await page.getByRole('button', { name: 'Close', exact: true }).waitFor();
        const pixels = PNG.sync.read(await page.screenshot({ path: path.join(out, `qr-${width}-${colorScheme}.png`) }));
        const code = jsQR(new Uint8ClampedArray(pixels.data), pixels.width, pixels.height);
        assert.ok(code, 'Rendered QR must decode');
        const uri = new URL(code.data);
        assert.equal(uri.protocol, 'macroapp:');
        assert.equal(uri.hostname, 'friend');
        assert.deepEqual([...uri.searchParams], [['v', '1'], ['tag', '#QF4821']]);
        await page.getByRole('button', { name: 'Close', exact: true }).click();
        const pin = page.getByRole('textbox', { name: 'Passcode', exact: true });
        await enterPin(pin, '4821');
        await page.getByRole('button', { name: 'Continue', exact: true }).click();
        await page.getByText('Not unlocked. Try again or sign out.', { exact: true }).last().waitFor();
        await enterPin(pin, '12');
        assert.equal(await pin.inputValue(), '12', 'PIN entry before theme change');
        await settings(page);
        await page.getByText('Demo account', { exact: true }).waitFor();
        await page.getByText('Theme: System', { exact: true }).waitFor();
        await page.getByRole('switch', { name: 'Dark theme' }).click();
        const manual = colorScheme === 'light' ? 'Dark' : 'Light';
        await page.getByText(`Theme: ${manual}`, { exact: true }).waitFor();
        await page.screenshot({ path: path.join(out, `settings-${width}-${colorScheme}.png`) });
        await page.getByRole('button', { name: 'Close menu', exact: true }).click();
        await pin.click();
        await pin.press('End');
        await pin.pressSequentially('34');
        // Completing the retained PIN must unlock, allowing Flutter's event frame to settle.
        await page.getByRole('button', { name: 'Continue', exact: true }).click();
        await page.waitForURL('**/#/dashboard');
        await page.reload();
        await accessibility(page);
        await settings(page);
        await page.getByText(`Theme: ${manual}`, { exact: true }).waitFor();
        await page.getByRole('button', { name: 'Reset to System Default', exact: true }).click();
        await page.getByText('Theme: System', { exact: true }).waitFor();
        await page.getByRole('button', { name: 'Close menu', exact: true }).click();
        await enterPin(pin, '1234');
        await page.getByRole('button', { name: 'Continue', exact: true }).click();
        await page.waitForURL('**/#/dashboard');
        await page.reload();
        await accessibility(page);
        await page.getByText('Enter Passcode', { exact: true }).waitFor();
        await page.getByRole('button', { name: 'Sign Out', exact: true }).click();
        await page.getByRole('textbox', { name: 'Email', exact: true }).waitFor();
        assert.equal(await page.getByText('Signed in as King James', { exact: true }).count(), 0);
        await page.reload();
        await accessibility(page);
        await page.getByRole('textbox', { name: 'Email', exact: true }).waitFor();
        await login(page);
        await page.getByRole('button', { name: 'Sign Out', exact: true }).click();
        assert.deepEqual(errors, []);
        console.log(`${width}/${colorScheme}: demo denial/unlock/relock/signout, theme persistence/reset, QR decoded; no page errors`);
        await page.close();
      }
    }
  } finally { await browser.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });

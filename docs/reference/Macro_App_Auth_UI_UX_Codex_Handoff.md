# Macro App — Finalized Welcome, Authentication, Profile and Appearance UI/UX Handoff

**Version:** 1.0  
**Design review date:** October 19, 2026  
**Intended audience:** Codex / mobile app developer / UI engineer  
**Reference images:** `Macro_App_Light_Approved.png` and `Macro_App_Dark_Approved.png` (included with this document).  
**Status:** The *visual direction* of the light and dark welcome screens is approved. Some downstream screens and settings options are explicitly reserved for later design; do not invent them as approved requirements.

> **Top-level Codex instruction:** Build one responsive, state-driven, accessible welcome/authentication screen with two carefully matched appearance variants. Re-create the composition of the supplied screenshots without baking screenshot text, phone hardware, status bar, or decorative graphics into a static bitmap. The white/blue reference is light mode; the charcoal/muted-red reference is dark mode. Preserve positions, geometry, typography hierarchy, rounded shapes, minimal iconography, generous lower whitespace, and subtle translucent depth. Follow the account-state rules below even where the concept renders show provisional content.

---

## 1. What Macro App is

Macro App is a fitness and personal-progress application. Its planned areas include:

1. Macro and food/nutrition tracking.
2. Body-composition tracking.
3. Fitness/workout calendar.
4. Bodyweight / weight-progress tracking.

The screens currently designed are the **entry/welcome/authentication/profile-gate screens**, not the detailed modules listed above. Do not infer or fabricate finished screens for nutrition tracking, body composition, exercise logging, the fitness calendar, or weight graphs from these welcome-screen references. Design those separately later; the entry screen should be a stable visual foundation for them.

The desired identity is **modern, polished, creative, technologically advanced but restrained, uncluttered, well organized, and recognizably premium**. Avoid generic busy health dashboards, brightly colored pictograms surrounding the profile, background photography, excessive neon, and garish effects.

## 2. Source of truth / confirmed cross-theme rules

These rules apply **equally** in light and dark mode.

- One shared screen hierarchy and underlying component layout. Theme changes colors, elevations, border emphasis, background curves, and glow—not content order or control placement.
- By default, theme follows the phone's **system light/dark appearance** and updates when that setting changes. A potential future appearance override or custom theme picker may be added in settings but is not required to be exposed now.
- The upper-left control is a rounded-square hamburger button containing **three horizontal lines**. It opens a settings/navigation sidebar from the left. The exact menu options have **not yet been decided**.
- The upper-right control is a minimal rounded pill/button. On the **logged-out Log In screen**, label it exactly `Sign Up` (capital S and U). For an **authenticated account/session**, label it exactly `Sign Out` (capital S and O). Never label this particular control `Log In` on the login page.
- The center heading is the user's **chosen display name**—either their first-and-last name or an optional nickname, depending on the account's display/privacy preference. For the demo account, render **`King James`**.
- Immediately below the display name is the same user's unique **account tag**. It has the pattern **`#LLNNNN`**: two random uppercase letters followed by four random numeric digits, for example `#QF4821`. Letter choices must be completely random, **not derived from the initials** of `King James`, the real name, email, or any other identifiable input. Preserve leading zeroes in the numeric portion. One tag belongs to one account and stays the same whether the screen displays the full name or nickname.
- The tag is **masked by default**, visually resembling `#••••••`. **Do not show an eye icon next to this tag.** Instead, the entire masked tag is a tappable control; tap to reveal the complete tag, tap again to hide it. A short re-hide interval and automatic re-hide when the screen backgrounds are recommended, but the exact timeout remains an implementation decision, not a user-approved value.
- Below the tag is a **short horizontal accent rule**, centered and rounded at its ends. Blue in light, subtle red in dark.
- Under that sits a **large centered circular profile photo**. When no photo exists, use a neutral gray human silhouette comprising head and shoulders. Add a white-to-neutral rim and a faint theme-colored halo around the circle, not a strobing or sci-fi glow.
- Below the avatar is **one large soft, rounded, translucent form card** containing the relevant authentication fields, followed by a **wide pill-shaped `Continue →` button**.
- The Continue control is **disabled and visually gray** until the required input for that particular state is present and locally valid. Enabled state uses the current theme's accent with accessible contrast. Submission, loading, error, and success must be reflected in the real interactive control.
- The screen occupies most of the useful vertical space but deliberately leaves an **unoccupied decorative zone at the bottom** of the screen. Do not cram everything against the home indicator.
- Background art is abstract and simple: **large layered curved/sweeping shapes** and soft gradients, not literal food, weights, calendars, or other icons. The light artwork should be *clearly visible*, not so pale that it disappears; the dark artwork should be subtle wine/burgundy, not neon or “Tron”-like.
- A **future settings feature** can let a signed-in user provide or select a **custom background picture**. Architecture should allow a background image layer behind all content without rearranging the foreground UI; custom-background editing is not required in this version.
- Other optional/future **custom themes** may be introduced later. Separate design tokens from component layout now.

### Important concept-image contradiction to resolve in code

Both approved images show `Sign Out` in the header **and** `Email` and `Password` in the form. This was an intermediate concept rendering, not the intended real account logic. The user's original behavior requirement takes priority:

| State | Upper-right label | What appears in the card | What Continue does |
| --- | --- | --- | --- |
| Signed out, on Log In screen | `Sign Up` | `Email`, `Password` | Authenticates account, then routes to the appropriate logged-in destination |
| Signed in with local app passcode enabled; currently locked | `Sign Out` | Passcode entry (not email/password) | Unlocks current saved session |
| Signed in with local app passcode disabled | `Sign Out` | No artificial email/password re-entry; proceed automatically or present a simple Continue entry as desired | Opens the app; do not pretend that a PIN exists |
| Signed in and already unlocked | `Sign Out` when header is visible | Usually main app content, not a second login form | Already inside app |
| Account registration page | Provide an obvious path back to `Log In` | Registration fields, defined below as proposed flow | Creates account and then verifies/authenticates it |

A `Sign Out` label implies there is a current authenticated session, even if its local UI is locked. **Do not put a signed-out email/password form under a signed-in session header in working software.**

## 3. Shared design system and layout specification

### 3.1 Mobile viewport and scale

- Portrait smartphone-first design. Start from a **390 × 844 pt** iPhone-like design canvas as a **layout reference**, then adapt to actual logical viewport sizes; this is not a single fixed-resolution requirement.
- The original reference PNGs are **941 × 1672 px**, including the **rendered phone hardware and mock status bar**. These pixels are not logical display points. Do not use them as a full-screen bitmap or mistake handset bezels for app UI.
- Let iOS or Android render its own operating-system status bar, Dynamic Island/camera cutout, home indicator, and safe-area insets. In a website, only simulate those elements in an **optional demo device shell**, never as ordinary app content.
- Foreground content must respect the top safe area and side margins. Background arcs may bleed to the screen edges, under system UI where platform-safe.
- Body column is full viewport width with approximately **16–20 pt** horizontal content gutters. Form card expands almost edge-to-edge to those gutters, with the avatar and name centered above it.
- On a reference 390 × 844 pt screen, use this as a **starting layout measurement** (fine-tune by comparing to PNGs):

| Element | Approximate geometry and placement |
| --- | --- |
| Top header controls | Below top safe-area inset; each about 48–52 pt tall; hamburger near 16–20 pt from left, right pill near 16–20 pt from right |
| Display name | Centered about 155–185 pt down the usable display; 26–30 pt semibold, with graceful wrapping/truncation for long names |
| Masked/revealed tag | Centered below name with 8–12 pt vertical gap; roughly 15–17 pt medium weight |
| Accent rule | Approximately 40–50 pt wide and 2–3 pt high, centered below tag |
| Circular avatar | Approximately 155–165 pt diameter, centered; top around 225–245 pt in the 844 pt reference |
| Main form card | Approximately 350–360 pt wide at 390 pt viewport; about 245–265 pt tall for email/password state; top around 410–430 pt |
| Card corner radius | Approximately 22–28 pt, continuous/smooth rounded corners where available |
| Card inner horizontal padding | Approximately 18–22 pt |
| Text field height | Approximately 56–60 pt, each with subtly outlined rounded rectangle |
| Vertical gap between fields | Approximately 12–16 pt |
| Continue button | About 52–58 pt high, almost full inner width, pill-shaped radius |
| Space below card | Deliberate remaining decorative space; approximately 130–175 pt in the reference, not a strict fixed height |

**The proportions and spatial hierarchy matter more than exact guessed point numbers.** The image model produced approximate visuals rather than a measurement-certified Figma file. Use relative constraints and visual regression snapshots at multiple screen sizes. Never use absolute coordinates that break on small phones, keyboard open, Display Zoom, or text enlargement.

### 3.2 Header

- Upper-left navigation control: floating frosted rounded square, three short horizontal strokes, centered. No `Settings` text next to it.
- Upper-right account action: approximately 92–106 pt wide and 46–50 pt high, horizontally aligned with the hamburger. Rounded capsule-like rectangle; **no profile icon** beside text. The text is the action (`Sign Up` or `Sign Out`), title-case as specified.
- Both buttons use subtle elevation and a mild pressed-state change; the right button is *blue-accented in light mode* and *neutral/silver in the final dark-mode design* (not an aggressively bright red control).
- There is no crowded toolbar title between them.

### 3.3 Display name and account tag

- Primary title is dark navy in light mode; soft white in dark mode.
- Demo text: **King James**. Treat as *data*, not hard-coded permanent interface chrome.
- Place the tag on its own line below the name with lower visual priority. Default view: **`#••••••`**. No eye icon, no separate edit icon, no visible button border.
- The tag line itself is an interactive button with an invisible 44 × 44 pt minimum iOS hit area (48 × 48 dp on Android) even though its rendered text is shorter; clearly label it for screen readers as `Account tag hidden, double tap to reveal` and then `Account tag <value>, double tap to hide`, avoiding speech of the actual value until revealed.
- Tap reveals the full assigned tag without changing font, line alignment, spacing, or surrounding layout. The short accent rule below does not move.
- Mask and revealed tag retain the same allotted width or are centered within a fixed-height row to avoid layout shift.

### 3.4 Avatar / profile image

- This is a **circular profile-photo container**, not a permanent cartoon or thematic illustration.
- No uploaded image: pale/mid-gray round head and shoulder silhouette on a gray circle, as shown in the screenshots. Uploaded photo: crop to center into the same circle and show a reliable fallback for a failed image.
- Thin, luminous border and restrained outward bloom. Keep avatar visually distinct from background and visibly above the form panel.
- Profile photo and display name belong to the saved account. Editing/uploading a photo happens from a separate authenticated profile/settings interface, not necessarily by making the welcome avatar editable.
- Support image picker, camera or file permission, cropping, file type and size checks, and removal/reset when the future edit flow is implemented. Preserve circular mask for all aspect ratios.

### 3.5 Authentication card

- One floating **soft glass / frosted / translucent card**, centered horizontally. It has a very lightly visible border and internal padding. Contrast remains sufficient for readable fields and controls.
- The card is not an opaque solid rectangle and not a heavy 3-D skeuomorphic slab.
- **Logged-out form:** first field `Email` with a minimal gray person/account symbol at its left. Use email keyboard, autofill, case-normalized email lookup (retain display value as needed), and appropriate autocomplete attributes. Second field `Password` with a minimal lock symbol at its left and secure masked entry.
- A password show/hide eye control appeared in earlier drafts but is absent from the final approved *separated* PNGs. **To match the approved visual exactly, omit the eye control from the idle screen**. Support a password-visibility affordance on focus or a subsequent design revision if desired; this is distinct from the account tag, which must never show an eye icon.
- **Signed-in/locked form:** replace the email/password inputs with an obvious local passcode input; retain same card language, vertical rhythm, and Continue button. Use numeric secure keyboard for numeric PIN; show a discreet contextual instruction such as `Enter Passcode`. Because the user has not specified a PIN length, make that configurable and do not assume four digits is final.
- Input control heights, outlines, icons, corner rounding, and focus treatment are consistent between themes; colors change according to theme.
- **Continue** has centrally aligned title and right-facing arrow with a modest gap. A custom arrow is fine, but never include an animated giant arrow or an extra floating button.
- Continue remains disabled until the required state-specific fields are populated and valid: email syntax/password nonempty for login (server determines actual authentication), correct configured number of passcode characters locally for PIN. Do not claim a user is signed in until the server has validated credentials or the session has been appropriately restored.
- On submit: prevent duplicate requests, display a compact spinner/progress indicator, handle invalid credentials with accessible error text, preserve entered email, do not disclose which account exists, allow standard autofill/password-manager behavior. On error, keep focus management predictable and allow retry.
- A disabled button uses **gray**, not accent red/blue; state is conveyed by contrast and affordance, not color alone.

### 3.6 Abstract background / foreground separation

- The light/dark base fills the entire app screen behind all elements.
- Draw the curves/organic flowing shapes with **SVG paths, native vector paths, CSS gradients, or layered vector views**. Do not use a screenshot as the background, because it also includes the avatar, fields, and phone bezel.
- Layered arcs appear: a wide curved shape entering from the right near upper-mid screen; another broad shape sweeping in from mid-left; and several overlapping broad swooshes rising diagonally at the bottom and from the bottom corners.
- The arcs must be visible yet remain secondary to the form. Avoid repeating icons or literal images of workouts, scales, plates, dumbbells, calendars, berries, smoothies, etc.
- All interactive surfaces sit **above** background, with stable contrast and padding regardless of accent variation.
- Preserve the bottom decorative space. Do not vertically center the entire screen like a generic login template or anchor the Continue button against the home indicator.

## 4. Light theme — complete visual description

**Approved reference:** `Macro_App_Light_Approved.png`. This is the original bright design with **more visible blue curved background shapes**. Do not replace it with the older barely visible background variation.

### 4.1 Overall atmosphere

A clean, open white-to-ice-blue screen with soft blue, cloudy gradient transitions. The image looks airy and friendly but professional, with soft sculpted cards and measured blue highlights. The background is not plain white: sizeable blue curving waves visibly wrap around the center/side and bottom of the canvas. Avoid strong outlines, saturated neon, flat bright blocks, or childish cartoon motifs.

### 4.2 Light palette (approximate development tokens)

These are *proposed starting color values inferred from the approved raster*, not extracted authoritative brand tokens. Refine in a side-by-side emulator review.

| Semantic token | Recommended starting color / treatment |
| --- | --- |
| `background` | `#F5F9FF`, gentle gradient to `#E7F1FF` |
| `backgroundWaveSoft` | `#DCEBFF` |
| `backgroundWaveMedium` | `#C6DDFF` |
| `backgroundWaveStrong` | `#9FC7FA` used sparingly in bottom arcs |
| `surfaceCard` | `rgba(255,255,255,0.82)` over gradient with light frosted blur |
| `surfaceInput` | `rgba(247,250,255,0.65)` |
| `borderSubtle` | `#D9E4F2` |
| `textPrimary` | `#071B42` deep navy |
| `textSecondary / tag default` | `#65758A` or darker when needed for readability |
| `accent` | `#2384EB` medium clear blue |
| `accentSoft` | `#A6CBFF` |
| `avatarBackground` | pale gray-blue gradient `#E8EEF7` to `#CAD5E5` |
| `avatarSilhouette` | cool gray `#98A7BF` |
| `disabledButton` | soft slate gray `#9AA6B9` with low visual emphasis |
| `enabledButton` | blue-toned accent-based fill, with sufficiently contrasting foreground |

### 4.3 Light controls and typography

- iOS-like status bar dark text/icons on pale screen (rendered by system in actual app).
- Hamburger: navy three lines inside a semi-translucent milky-white rounded square. Its outline is delicate; a tiny shadow differentiates it from background.
- Upper-right `Sign Out` in the approved signed-in demo: blue text in a pale-blue almost-glass capsule, with a slight blue shadow and thin illuminated rim. The same component reads `Sign Up` when signed out.
- `King James`: centrally placed, large 26–30 pt semibold deep-navy sans-serif; avoid gimmicky font styles. The exact letter shapes can be approximated with the native system font (SF Pro for iOS; Roboto or appropriate system UI font for Android) using consistent tracking.
- Masked tag beneath: medium gray `#••••••`, quieter than the title, directly tappable; no visible eye control.
- Narrow blue divider: bright enough to notice, rounded ends and subtle blue falloff.
- Profile image circle: cool neutral-gray interior, generic gray silhouette, crisp thin white inner ring, fine medium-blue outer edge, and soft halo, not harsh neon.
- Card: white translucent rounded rectangle with feathered shadow and thin cool gray outline; slight edge brightening to produce a premium 'glass' appearance.
- Inputs: white/off-white rounded boxes, gentle gray outlines, left-aligned gray person/lock symbols, gray-blue label text; focus ring switches to a tasteful blue. Empty inputs look intentionally blank, not decorated with extraneous helper text.
- Continue: a very wide, cool gray, rounded pill in its default disabled state, with white/light text and simple arrow. **When enabled**, switch to a clearly tappable blue surface and ensure label contrast remains accessible.
- Bottom: visible layered pale/medium blue sweeping curves. These occupy the otherwise open space rather than extra buttons or text.

### 4.4 Light-mode distinctive behavior

- Reveal hidden account tag: tag text changes to an actual randomly assigned ID but stays gray; it does not become a blue hyperlink permanently.
- Focused text field: fine blue outline or restrained blue shadow; keyboard follows platform light appearance.
- Pressed state: 1–2 pt visual depression/tint shift, gentle haptic feedback if platform appropriate.
- Sidebar and other future sheets: maintain white frosted glass treatment over a softly dimmed version of the same blue background.
- For a user-chosen custom background in the future, add a restrained light translucent scrim under interactive content when required for contrast.

## 5. Dark theme — complete visual description

**Approved reference:** `Macro_App_Dark_Approved.png`. It is the **second, revised dark design with charcoal and subdued red/burgundy**, *not* the earlier black-and-hot-red glowing “Tron” version.

### 5.1 Overall atmosphere

A low-glare, restrained, sophisticated charcoal/black screen with textured depth and **muted deep red/burgundy curved graphics**. Think high-end fitness software, not gaming neon. The main center screen remains dark neutral; crimson is a small, intentional brand accent, and large wave fills are burgundy tinted and semi-transparent. The architecture, content, and spacing remain the same as light mode.

### 5.2 Dark palette (approximate development tokens)

| Semantic token | Recommended starting color / treatment |
| --- | --- |
| `background` | `#1F2024`, shallow gradient towards `#282A2E` |
| `backgroundWaveSoft` | `#302329` (low-chroma plum-charcoal) |
| `backgroundWaveMedium` | `#45252D` (smoky burgundy) |
| `backgroundWaveStrong` | `#5A2B32` used only at selected bottom wave edges |
| `waveHairline` | a subdued, thin red `#8E3943` at low alpha; optional |
| `surfaceCard` | `rgba(43,45,49,0.88)` with modest blur/elevation |
| `surfaceInput` | `#292B2F` or alpha-matched neutral charcoal |
| `borderSubtle` | `#464A52` |
| `textPrimary` | `#F3F4F7` |
| `textSecondary` | `#B0B8C5` |
| `accent` | `#C84A5A` muted crimson for small accents; use `#D66B75` for small foreground accent text needing AA contrast |
| `avatarBackground` | warm/cool neutral gray `#A1A5AD` to `#777B83` |
| `avatarSilhouette` | neutral charcoal gray `#53565F` |
| `disabledButton` | `#41444C` |
| `enabledButton` | muted berry/red action surface with measured contrast, **not full neon red** |

### 5.3 Dark controls and typography

- System status text/icons become white/light; no hand-drawn status bar inside the real app.
- Hamburger: pale silver/white three-line symbol on a slightly elevated charcoal, semi-transparent rounded square with a quiet gray outline.
- Right header control **`Sign Out` remains neutral silver/gray and charcoal**, exactly like the last accepted dark PNG; it is **not** a glowing fire-engine red capsule. Its copy changes to `Sign Up` only in logged-out state.
- `King James`: large, white/off-white semibold sans-serif, identical size and center alignment to light mode.
- Hidden tag: soft light gray `#••••••`, a shade darker than the name. It is tappable without any visible eye icon.
- Short divider: a **small, restrained crimson horizontal stroke** below tag. It is the most obvious standalone red line in the upper half.
- Circular avatar: neutral gray interior and silhouette, thin pearl-white ring, *very small* muted red halo or near-edge illumination. The final accepted PNG has a mostly white circular rim with subtle red edge shading; don't rebuild it as a bright continuous neon-red outline.
- Background waves: deep maroon/mulberry arcs with softly graded opacity emerging from the screen edges, left midsection, top-right, and bottom. The curves are prominent enough to notice but stay dark and translucent.
- Form card: medium charcoal frosted panel with large smooth corner radius, thin gray outline, and faint upward highlight; darker than the light-mode card but slightly lighter than page background.
- Inputs: charcoal-filled with low-contrast neutral outlines and light silver person/lock symbols, muted gray placeholder labels. When focused, use a subtle red accent border that doesn't destroy readability.
- Continue: charcoal/gray disabled pill with light gray typography and arrow. Enabled uses sober muted red or its neutral complementary accent; never black text on an inaccessible red background.
- Bottom region: flowing dark red/burgundy curves and thin toned-down red lines. Preserve generous negative space.

### 5.4 Explicit dark-mode prohibitions

- No pure bright red (#FF0000) as a large surface.
- No harsh neon avatar ring; no large high-saturation glowing border.
- No glowing red border on every card, every field, and the header action.
- No futuristic HUD/grid, cyberpunk/glitch, Tron, fluorescent gradients, or game launcher aesthetics.
- No bright-blue foreground accent from the earlier dark-mode experiment (other than any tiny unavoidable **system-controlled hardware indicator** in the illustrative reference, which is not part of the app).
- Do not invert light-mode layers blindly; separately tuned dark-mode surfaces, text, and shadows preserve depth and legibility.

## 6. Account profile naming, privacy and ID generation

### 6.1 Names are data with two possible display modes

- Account holds **first name** and **last name**, rendered together as full name, e.g. `John Smith`.
- Account can have an **optional user-chosen nickname**, e.g. `King James`. Nicknames may be non-unique; a nickname is not the account primary key.
- User controls account display preference: `full_name` versus `nickname`. For privacy, **nickname display must not accidentally surface their real first/last name in the same public-facing UI**. If no nickname exists, default to full name for account creation flows; provide a privacy-conscious choice when the name may be shared publicly.
- In demo mode, nickname exists and display preference is nickname; heading reads `King James`.
- This display preference affects the welcome heading and future public profile/discovery labels where appropriate. It does **not** change credentials, database user ID or generated account tag.

### 6.2 Random account tag

- External human-readable tag format is exactly `#` + **two uppercase Latin letters** + **four digits**. Sample `#QF4821`, *illustration only*. Avoid `#KJ4821` as it falsely implies generation from `King James` initials.
- Use a **cryptographically secure** random generator on the server; select letters from `A–Z` and digits from `0–9`. Never hash or derive them from name, nickname, email or birthday.
- Generate during account creation. Insert with a **database unique constraint on the entire tag** (normalized uppercase). When a collision occurs, generate a new candidate and retry atomically. A client-side `check if available` operation is not sufficient by itself because of races.
- Persist assigned tag unchanged across changing name, nickname, photo, or display/privacy preference.
- Store an internal independent non-public account UUID/ID as the actual database primary key. The short public tag is only a **display/disambiguation handle**, not a secret, login factor, authorization check, or globally unlimited identifier namespace. The finite format will eventually need an extension strategy at large scale.
- Default hidden presentation on the welcome screen: `#••••••`. On user tap, present entire tag `#QF4821` as text. On next tap, hide it. Do **not** render a trailing eye icon. For privacy, re-mask when app goes to background, another person switches accounts, or user signs out.
- Because the tag is a disambiguator, its secrecy is **visual privacy**, not a security guarantee; never treat knowledge of the tag as proof of account ownership.

### 6.3 Recommended data shape

```ts
// Cross-platform conceptual data model; adapt to framework/database.
type DisplayNameMode = "full_name" | "nickname";
type AppearanceMode = "system" | "light" | "dark";

interface AccountProfile {
  id: string;                    // private UUID / stable primary key
  firstName: string;
  lastName: string;
  nickname: string | null;
  displayNameMode: DisplayNameMode;
  accountTag: string;            // example: "#QF4821"; unique at DB level
  email: string;                 // private; never use as public display title
  avatarUrl: string | null;
  localAppLockEnabled: boolean;
  appearancePreference: AppearanceMode; // default "system"
  backgroundAssetId: string | null;     // reserved for later customization
}

function getDisplayName(user: AccountProfile): string {
  const realName = `${user.firstName} ${user.lastName}`.trim();
  return user.displayNameMode === "nickname" && user.nickname?.trim()
    ? user.nickname.trim()
    : realName;
}

function getVisibleTag(tag: string, revealed: boolean): string {
  return revealed ? tag : "#••••••";
}
```

Note: Server-side IDs, access control, secure session handling, and role-specific privacy rules are deliberately not represented in this minimal UI data example; implement those independently.

## 7. Screen-by-screen UX and navigation flow

### 7.1 State A — cold start / no authenticated account

- Read OS appearance. If system is light, show white/gray/blue version; if dark, charcoal/gray/burgundy version.
- Show hamburger top left, **`Sign Up` top right**.
- When there is no remembered profile, use generic title and avatar rather than leaking another person's private nickname/email on a shared phone. A remembered-account profile may be shown only when allowed by user privacy and device/session preferences.
- Show **`Email`**, **`Password`**, disabled **`Continue →`**.
- As user enters a plausible email and nonempty password, Continue becomes enabled and gains theme-accent treatment.
- Tap Continue -> authenticate over secure connection -> route to app or prompt to set up optional local passcode if requested.
- Invalid credentials -> small accessible error message and retry state; never reveal whether an email exists. Provide a legitimate password recovery path on the full login implementation even if not depicted in the prototype.

### 7.2 State B — Sign Up / create account (new screen, not visually approved yet)

- Tap top-right `Sign Up` on the logged-out Log In page.
- Navigate to registration while keeping the same background art, rounded cards, type hierarchy, color tokens and safe-area principles.
- At minimum, account setup must support **first name, last name, email, password**, and **optional nickname**, because these data are needed by the agreed profile system. Add password confirmation, email verification, and terms/privacy notices as appropriate to product/legal design. Exact visual arrangement for this new screen is **not yet approved**; reuse components rather than creating random new visual language.
- Registration service generates a **unique random tag** with atomic collision enforcement. Never ask user to manually choose their six-character tag.
- Allow choosing name versus nickname as displayed identity when a nickname exists; recommend privacy-prominent default for publicly visible areas.
- After verified registration/authentication, optionally offer local app passcode setup (it is an *additional on-device unlock*, not a substitute for registration email/password).
- Provide an obvious `Back to Log In` path. The user only specified `Sign Up` for the login-screen corner control; don't assume the signup-screen top-right text has been finalized.

### 7.3 State C — existing authenticated session, local passcode enabled, app locked

- Render current saved account's chosen display name (demo **King James**) with masked tag `#••••••`, avatar, and abstract waves.
- The top-right button reads **`Sign Out`**.
- Form card contains **passcode input**, not `Email` and `Password`. Continue is initially gray/disabled until the configured passcode length/entry is complete.
- Correct passcode -> unlock the locally stored authenticated session and open the dashboard.
- Wrong passcode -> small inline error, no false success, backoff/rate limiting against repeated guessing.
- Allow recovery by returning to full account authentication where appropriate. Local app lock must never act as the only protection for sensitive account operations.
- On sign-out, invalidate server/session tokens appropriately, clear local unlock state, and return to signed-out Log In page (`Sign Up` in top right).

### 7.4 State D — existing authenticated session, local passcode disabled

- The local PIN is **optional additional security**, as originally requested.
- If no passcode was set, do not create a fake passcode challenge. Recommended flow: directly enter the app while authenticated, or show a brief branded welcome state with a ready-to-use Continue button if the product expressly uses a welcome gate on every launch. Exact optional transition preference is **not yet finalized**.
- Inside app, keep profile/settings and `Sign Out` available.

### 7.5 State E — signed in and unlocked / application home

- Successful authentication/unlock goes into Macro App's main application.
- Intended modules include macro tracking, body-composition tracking, fitness calendar and weight tracking.
- **No home/dashboard layout, module navigation order, macro charts, progress widgets, metrics, or calendar visuals are approved by this welcome-screen design cycle.** Create those in separate designs rather than inventing a dashboard and presenting it as a completed requirement.
- The visual theme selection and optional custom background architecture can persist into those future screens.

### 7.6 State F — Sign Out action

- Tap `Sign Out` on a current authenticated account. Provide a normal confirmation if warranted by product risk; avoid unnecessarily disruptive confirmation for routine logout unless specified later.
- End authenticated session, revoke/expire tokens as supported by backend, clear any sensitive temporary data and account-tag reveal state, stop passcode/unlock access, and navigate to logged-out Log In.
- Header changes **from `Sign Out` to `Sign Up`**; card changes **from passcode (if locked) to `Email` and `Password`**. Continue becomes disabled until a valid set of required inputs is entered.
- Never treat `Sign Out` as an alternate way to lock the screen while preserving full privileged access.

### 7.7 State G — background/foreground, user switching and offline state

- On returning from background, if a configured app-lock policy requires it, show the saved-account passcode gate with tag remasked. The timeout/policy are not specified yet.
- When switching accounts, don't leave the outgoing person's photo/nickname/tag exposed without explicit remembered-account consent.
- Never display a successful login/unlock unless backed by appropriate session or verified local cryptographic state.
- Handle keyboard up, network delay, server errors, offline launch, app resume, device rotation or narrow viewport without cropping fields or overlapping safe areas.

## 8. Sidebar / settings

### 8.1 Confirmed interaction

- Hamburger is at upper left, three horizontal lines, same in both appearances.
- Tap -> **left-edge slide-out sidebar** over a dimmed version of current screen. Suggested drawer width is approximately 78–85% of viewport, max 320 pt; these are **recommended implementation dimensions, not screenshot-specified measurements**.
- The sidebar contains an as-yet-**undecided collection of settings/navigation options**. Do not hard-code a made-up definitive menu as though approved.
- Close through back button/close affordance, swipe-to-dismiss when supported, tap outside, or platform back action. Manage focus, prevent hidden background controls from receiving touches, and announce drawer state to assistive technologies.
- Light sidebar: translucent white/off-white with blue focus/selection. Dark sidebar: dark elevated gray with restrained red focus/selection. Match card corner treatment and typography.

### 8.2 Capabilities whose settings interfaces will eventually be necessary

These are **functionally grounded by this conversation**, but exact labels, layout and ordering are **not finalized**:

| Capability | User intent | Implementation status |
| --- | --- | --- |
| Profile picture | Upload/change/remove avatar | Data and UI component should support it; edit screen later |
| Display identity | Choose First + Last Name vs Nickname for privacy | Functional requirement; controls can be built in account settings |
| Nickname | User-created, editable display nickname | Functional requirement |
| Tag visibility | Tap masked tag on profile; no visible eye icon | Confirmed interaction; optional setting for auto-hide duration not finalized |
| Local passcode | Enable, set, change or disable optional extra app security | Functional requirement; credential handling must be secure |
| Appearance | Follow system light/dark by default | Confirmed; optional explicit theme override is an extension |
| Custom background image | User can eventually choose their own page background | Future requirement; customization screens not designed |
| Additional themes | Add new visual styles beyond initial light and dark | Future idea only |

Do not claim that exact settings navigation items were finalized. As a developer scaffold, these could be grouped under **Account & Privacy**, **Security**, **Appearance**, and **Background**, but those group labels are **suggestions**, not approved interface text.

### 8.3 Custom background pipeline (future-ready)

- Layers from back to front: system/theme color -> abstract wave default art **or** user-image asset -> contrast/scrim gradient -> glass surfaces -> all text and controls.
- A background photo must be cropped safely (`cover` style), respond to resizing and theme changes, and never push content around.
- Future user settings could allow choosing/removing/cropping a photo, live preview and resetting to built-in art; none of these editor screens is approved yet.
- Apply blur/dimming scrims as needed to retain contrast in both appearances. A user's photo should not obscure display name, masked tag, or fields.

## 9. Industry-standard usability, ergonomics and accessibility requirements

These decisions implement the user's request for an ergonomically usable one-handed smartphone layout while **preserving** the approved visual arrangement.

- **Thumb reach:** Position frequently used fields and primary Continue action in the central-to-lower interactive region. Top corners contain occasional controls (menu, sign out/up), not repetitive form submissions. Make tapping the username tag easy even though its visual label is small. Apple notes controls are often easier to reach in the middle/bottom of iPhone displays: https://developer.apple.com/design/human-interface-guidelines/designing-for-ios/
- **Target sizes:** At least **44 × 44 pt** interactive hit regions on iOS; **48 × 48 dp** on Android. The visible tag can be visually small while having an expanded invisible touch region. References: https://developer.apple.com/design/human-interface-guidelines/buttons and https://developer.android.com/develop/ui/compose/accessibility/api-defaults
- **Safe areas:** Keep header below Dynamic Island/status bar; no controls hidden behind home indicator. The background art alone can go edge to edge. Reference: https://developer.apple.com/design/human-interface-guidelines/layout
- **Dynamic text:** Support Dynamic Type and large accessibility fonts without clipping nickname, tag, header actions, field labels or Continue. Allow vertical scroll when necessary; resize avatar/card logically. Reference: https://developer.apple.com/design/human-interface-guidelines/accessibility
- **Color contrast:** Normal text at least 4.5:1 and large text at least 3:1 whenever applicable to WCAG AA; border/focus/control contrast also needs independent checking. Since concept screenshots use soft gray labels, the implementation may need slightly darker light-mode placeholder text and brighter dark-mode placeholder text to make them accessible. Reference: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- **Reduced motion/transparency:** Respect platform accessibility preferences; render readable opaque fallbacks for frosted cards and remove optional blur/animations when Reduce Transparency/Reduce Motion is enabled.
- **Input semantics:** Email text field uses platform email/autofill semantics, password uses secure entry/autofill, local PIN uses appropriate keyboard. Preserve screen-reader labels, error announcement, contrast-aware focus ring, accessible button role and disabled state.
- **System appearance:** Listen for OS color-scheme changes in real time and switch token sets without remounting or losing entered form values. Reference: https://developer.apple.com/design/human-interface-guidelines/dark-mode
- **Smoothness:** Press states must exist and transitions should be brief and subtle. Avoid animation that impedes screen opening, copying or typing.
- **Secure app lock:** On iOS use appropriate Keychain / LocalAuthentication / hardware-supported protections and on Android use platform Keystore/biometric-aware facilities. A local passcode must gate protected material and be rate-limited, not just compare a hard-coded string in client UI. Authenticated sessions and sensitive operations require backend authorization. References: https://mas.owasp.org/MASVS/07-MASVS-AUTH/ and https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/
- **Privacy:** Treat real names, emails, profile images and tracking data as personal data, avoid accidental exposure in public search and notification surfaces, and do not rely on nickname use alone as complete anonymity.

## 10. Component architecture and state logic for Codex

Build the welcome page as reusable components with theme tokens and state-driven variations. Recommended conceptual tree:

```text
AppShell
  SystemAppearanceProvider
  AuthSessionProvider
  AccountProfileProvider
  BackgroundLayer
    DefaultWaveArtwork | CustomBackgroundImage (later)
    ReadabilityScrim
  SafeAreaPage
    TopActionRow
      SettingsDrawerTrigger (three lines)
      AuthActionButton ("Sign Up" | "Sign Out")
    AccountIdentity
      DisplayName ("King James" demo)
      MaskedAccountTag (tap itself to reveal, NO eye icon)
      AccentDivider
    ProfileAvatar
      UploadedPhoto | DefaultSilhouette
      ThemeSpecificRimAndGlow
    CredentialCard
      SignedOutForm(Email, Password)
        | SignedInPasscodeForm(Passcode)
        | OptionalNoLockContinueState
      PrimaryContinueButton
    BottomDecorativeSpace
  SettingsDrawer (options still undecided)
```

Recommended finite states:

```ts
type AuthUIState =
  | "signed_out_login"
  | "signed_out_register"
  | "signed_in_locked"
  | "signed_in_unlocked"
  | "auth_submitting"
  | "auth_error";

// Derive header text from authenticated SESSION, not from whether
// the currently shown form happens to contain email/password.
const topRightLabel = hasAuthenticatedSession ? "Sign Out" : "Sign Up";

// Derive input mode from actual state, not from the profile nickname.
const credentialMode = !hasAuthenticatedSession
  ? "email_password"
  : localAppLockEnabled && !locallyUnlocked
    ? "passcode"
    : "none";

const continueEnabled = credentialMode === "email_password"
  ? isPlausibleEmail(email) && password.length > 0 && !isSubmitting
  : credentialMode === "passcode"
    ? passcode.length === configuredPasscodeLength && !isSubmitting
    : !isSubmitting;

const displayedName = getDisplayName(currentProfile);
const displayedTag = tagRevealed ? currentProfile.accountTag : "#••••••";
```

**Important:** The above is illustrative state logic, **not a secure authentication implementation**. Passcode verification, session authorization, PIN length policy, hashed/secure secret storage and tag issuance belong in the appropriate protected services and backend.

### Design tokens suggested in code

```ts
export const appearance = {
  light: {
    background: "#F5F9FF",
    surface: "rgba(255,255,255,0.82)",
    inputSurface: "rgba(247,250,255,0.65)",
    textPrimary: "#071B42",
    textSecondary: "#60738E",
    border: "#D9E4F2",
    accent: "#2384EB",
    waveSoft: "#DCEBFF",
    waveMid: "#C6DDFF",
    waveStrong: "#9FC7FA",
    disabled: "#9AA6B9"
  },
  dark: {
    background: "#1F2024",
    surface: "rgba(43,45,49,0.88)",
    inputSurface: "#292B2F",
    textPrimary: "#F3F4F7",
    textSecondary: "#B0B8C5",
    border: "#464A52",
    accent: "#C84A5A",
    accentTextAA: "#D66B75",
    waveSoft: "#302329",
    waveMid: "#45252D",
    waveStrong: "#5A2B32",
    disabled: "#41444C"
  }
} as const;
```

Implement the background art as theme-parametric vectors **separate** from this token object. The same wave geometry should visually align across appearance changes. Example normalized-wave strategy: back layer enters from top-right after about 16% height and arcs through screen right, mid layer rises from left around 30–40% height, large bottom-left wave rises around 75–80%, an overlapping central wide low-frequency diagonal wave runs along the bottom, and a right-bottom cusp rises 77–85%. **These are approximate shape placements, not a traced SVG**. For 1:1 recreation, manually trace from the approved PNGs using an editable design/vector tool.

## 11. Acceptance criteria / quality checklist

A Codex implementation is ready for review when all the following are true:

1. On equal-size device captures, light/dark components appear at the same relative positions with matching typography, radius, avatar size, card dimensions and spacing.
2. Light mode matches the white/icy-blue screenshot, including **noticeable blue background curves** and blue highlights; dark matches charcoal and **subdued wine/burgundy artwork** with small red accents and **no harsh neon**.
3. System light/dark preference is followed by default; changes propagate live without replacing user's form values.
4. Upper-left hamburger displays three strokes and opens a working left drawer. Drawer contents are either explicitly approved later or clearly provisional.
5. Signed-out Log In upper-right says **Sign Up**, showing Email+Password fields.
6. Existing signed-in local-lock gate upper-right says **Sign Out**, showing **Passcode instead of Email+Password**.
7. The demo profile reads **King James**, where `King James` is a nickname selected for display, not necessarily the legal first/last name.
8. Tag pattern is **two independently random letters + four random digits** with `#` prefix, atomic unique constraint and retries. It is not derived from `King James` or initials.
9. Same tag persists when switching full-name/nickname visibility and changing the user's name.
10. Tag begins as `#••••••` and is revealed by **tapping the tag itself**. There is **no eye icon** next to it. Reveal/hide does not shift layout; tag re-masks on sensitive transitions.
11. Profile photo uses circular crop; no-photo fallback matches gray silhouette; white edge with restrained blue halo in light and white/neutral edge with subdued red halo in dark.
12. Continue starts disabled gray until relevant fields are complete. Enabled appearance, loading, success and errors are real, accessible states.
13. Sign Out clears/revokes the authenticated session and takes the user to real logged-out state; form/header switch together.
14. Screens work with keyboard open and at common small/wide phone sizes; safe areas and accessibility font increases do not cause overlap.
15. App screen contains **no rendered phone bezel, status icons, clock or Dynamic Island from the mockup PNG**: the platform owns those.
16. Future background-image customization can be inserted behind the existing screen without reworking component layout.
17. The main dashboard/fitness trackers are treated as unapproved subsequent designs; no fictional screen details are presented as finalized.

## 12. Decisions intentionally not yet finalized

The design conversation did **not** lock down these details. Ask for approval before treating any option as a final product decision:

- Name and exact list/order of sidebar settings items.
- Detailed Sign Up screen layout, onboarding questions, email-verification visuals.
- Passcode length, enable/setup screen, retry policy, when app relocks, biometrics as an optional alternative, and behavior for users without a passcode.
- Password visibility affordance in the **final** idle visual (older drafts had an eye icon; last separated references do not).
- How long the tag stays revealed after tap and whether a copy action is exposed.
- Whether manual Light/Dark override is exposed now or only future themes.
- Custom background image picker/editor layout, storage/sync scope and whether separate backgrounds per theme can be configured.
- Main navigation, home dashboard, macro tracking, body composition, fitness calendar and weight tracking screens; these are **product purposes**, not yet designed.
- Final shipping platform and framework (SwiftUI, React Native, Flutter, Kotlin Compose, web, etc.).

## 13. Implementation references and final design inputs

1. `Macro_App_Light_Approved.png` — **approved light visual**.
2. `Macro_App_Dark_Approved.png` — **approved dark visual**.
3. Apple: Designing for iOS, touch ergonomics: https://developer.apple.com/design/human-interface-guidelines/designing-for-ios/
4. Apple: Layout/safe areas: https://developer.apple.com/design/human-interface-guidelines/layout
5. Apple: Buttons/minimum touch target: https://developer.apple.com/design/human-interface-guidelines/buttons
6. Apple: Dark Mode and appearance switching: https://developer.apple.com/design/human-interface-guidelines/dark-mode
7. Apple: Accessibility/Dynamic Type: https://developer.apple.com/design/human-interface-guidelines/accessibility
8. Android: Accessible touch targets: https://developer.android.com/develop/ui/compose/accessibility/api-defaults
9. W3C: WCAG 2.2, text contrast: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
10. OWASP: Mobile Authentication and Authorization: https://mas.owasp.org/MASVS/07-MASVS-AUTH/
11. OWASP: iOS Local Authentication: https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/
12. Apple: Keychain services: https://developer.apple.com/documentation/security/keychain-services

**Developer success definition:** The user should immediately recognize the two screenshot designs as the very same page under two visual themes, be able to use every interactive element, and see state changes that honor the intended full-name/nickname privacy rules, random hidden tag, Sign Up/Sign Out state, optional passcode unlock, and system-theme preference.

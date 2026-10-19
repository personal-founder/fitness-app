---
metadata_version: 1
purpose: Separate intended Flutter targets from actual platform validation.
owner: unassigned
related_adrs: [ADR-0001]
---
# Platform support and verification

All six targets have Flutter-generated runners. No store/support-version promise is
established by generating them. Evidence is scoped to this Windows development host.

| Target | Intended behavior | Verification boundary |
| --- | --- | --- |
| Web | Entry views and Supabase, memory-only session; no app PIN | Release compilation and local Chromium checks |
| Windows | Protected session, app PIN, Windows Hello where available | Build attempted; device/Hello checks separate |
| Android | Protected session, app PIN and enrolled biometrics | Min SDK 24 configured; Android SDK unavailable here |
| iOS | Keychain, app PIN, Face ID/Touch ID | Xcode/macOS and physical device required; not built here |
| macOS | Keychain, app PIN, Touch ID where available | macOS/Xcode/provisioning required; not built here |
| Linux | Entry views and memory-only sessions | Linux toolchain/host required; native lock deferred |

Auth callbacks are configured for the provisional `macroapp://auth-callback` scheme.
Use verified app/universal links and owned app IDs before distribution; custom schemes
are susceptible to another installed application registering the same scheme. PKCE
reduces code interception risk but does not prove association with an owned domain.
No photo, camera, sensor or notification permissions are requested.
Windows callback scheme registration still needs the native installer/owner setup;
it has not been registered on this machine. Native callback behavior is untested.

Apple keychain groups are wired to Runner entitlements. Owner signing/provisioning
must be validated in Xcode. Android uses FragmentActivity, biometric permission,
AppCompat launch theme, Internet permission and disabled app backup.
Windows biometric selection is controlled by Windows Hello; plugin behavior needs
real hardware testing. Unsupported or denied biometric calls leave the app locked.

Viewport simulation covers small phones, landscape and wide desktop at enlarged text.
This is not physical-device, screen-reader or WCAG certification. Test keyboard,
VoiceOver/TalkBack/Narrator, reduced motion, actual safe areas, lifecycle snapshots,
installation/upgrade and offline account recovery before release.

// metadata_version: 1
// purpose: Distinguish missing native prerequisites from application compilation/test failures.
// owner: unassigned
// related_adrs: [ADR-0007]
bool nativeToolsMissing(String output) => [
  'Unable to find suitable Visual Studio toolchain',
  'Android SDK not found',
  'Unable to locate Android SDK',
  'CMake is required',
  'Xcode installation is incomplete',
  'No supported devices connected',
  'No supported devices found',
  "Cannot open include file: 'atlstr.h'",
].any(output.contains);

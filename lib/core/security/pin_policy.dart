// metadata_version: 1
// purpose: Define four-digit PIN syntax and the immutable account-tag exclusion.
// owner: unassigned
// related_adrs: [ADR-0032]
abstract final class PinPolicy {
  static const length = 4;
  static bool validSyntax(String pin) => RegExp(r'^[0-9]{4}$').hasMatch(pin);
  static String? enrollmentError(String pin, String? tag) {
    if (tag == null || !RegExp(r'^#[A-Z]{2}[0-9]{4}$').hasMatch(tag)) {
      return 'Load your account tag before setting a passcode.';
    }
    if (!validSyntax(pin)) return 'Use a four-digit passcode.';
    if (pin == tag.substring(3)) {
      return 'Your passcode cannot match the four digits in your account tag.';
    }
    return null;
  }
}

// metadata_version: 1
// purpose: Persist only an explicitly synthetic demo-session flag, never real authentication.
// owner: unassigned
// related_adrs: [ADR-0042]
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class DemoSessionStore {
  Future<bool> readSignedIn();
  Future<void> writeSignedIn(bool value);
}

class PreferencesDemoSessionStore implements DemoSessionStore {
  static const key = 'demo.king_james.signed_in.v1';
  final _preferences = SharedPreferencesAsync();
  @override
  Future<bool> readSignedIn() async => await _preferences.getBool(key) ?? false;
  @override
  Future<void> writeSignedIn(bool value) => _preferences.setBool(key, value);
}

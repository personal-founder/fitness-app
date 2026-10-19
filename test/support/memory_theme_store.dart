// metadata_version: 1
// purpose: Controlled non-sensitive appearance persistence for UI/controller tests.
// owner: unassigned
// related_adrs: [ADR-0035, ADR-0025]
import 'package:macro_app/app/theme/theme_store.dart';

class MemoryThemeStore implements ThemeStore {
  String? value;
  bool broken = false;
  @override
  Future<String?> read() async {
    if (broken) throw StateError('storage unavailable');
    return value;
  }

  @override
  Future<void> write(String mode) async {
    if (broken) throw StateError('storage unavailable');
    value = mode;
  }
}

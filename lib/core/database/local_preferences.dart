// metadata_version: 1
// purpose: "Native persistent adapter; Web cache is explicitly unavailable pending WASM setup."
// owner: unassigned
// related_adrs: [ADR-0022]
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'preferences_database.dart';

PreferencesDatabase? openLocalPreferences() => kIsWeb
    ? null
    : PreferencesDatabase(driftDatabase(name: 'macro_ui_preferences'));

// metadata_version: 1
// purpose: "Boots real services only when configured; preview never contacts the backend."
// owner: unassigned
// related_adrs: [ADR-0028, ADR-0034, ADR-0035, ADR-0044, ADR-0042]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/config.dart';
import 'app/startup_error.dart';
import 'core/auth/auth_gateway.dart';
import 'core/auth/supabase_gateway.dart';
import 'core/security/session_storage.dart';
import 'core/security/pkce_storage.dart';
import 'core/security/vault.dart';
import 'core/security/app_lock.dart';
import 'features/auth/design_preview.dart';
import 'features/auth/demo_lock.dart';
import 'features/auth/demo_session_store.dart';
import 'app/theme/theme_store.dart';
import 'app/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStore = openThemeStore();
  final initialTheme = await loadTheme(themeStore);
  AuthGateway gateway = UnconfiguredAuth();
  String? initialAuthNotice;
  if (AppConfig.preview) {
    final demo = DemoAuth(PreferencesDemoSessionStore());
    initialAuthNotice = await demo.restore();
    gateway = demo;
  }
  if (AppConfig.configured && !AppConfig.preview) {
    try {
      await Supabase.initialize(
        url: AppConfig.url,
        publishableKey: AppConfig.key,
        authOptions: FlutterAuthClientOptions(
          localStorage: ProtectedSessionStorage(),
          pkceAsyncStorage: supportsLocalLock ? ProtectedPkceStorage() : null,
        ),
      );
      gateway = SupabaseGateway(Supabase.instance.client);
    } catch (_) {
      runApp(const StartupError());
      return;
    }
  }
  runApp(
    ProviderScope(
      overrides: [
        authGatewayProvider.overrideWithValue(gateway),
        initialAuthNoticeProvider.overrideWithValue(initialAuthNotice),
        if (AppConfig.preview) appLockProvider.overrideWithValue(DemoLock()),
        themeStoreProvider.overrideWithValue(themeStore),
        initialThemeProvider.overrideWithValue(initialTheme),
      ],
      child: const MacroApp(),
    ),
  );
}

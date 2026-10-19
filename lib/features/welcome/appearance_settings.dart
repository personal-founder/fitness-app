// metadata_version: 1
// purpose: Accessible device appearance toggle and explicit reset to System.
// owner: unassigned
// related_adrs: [ADR-0035]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config.dart';
import '../../app/theme/theme_controller.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(themeProvider);
    final action = ref.read(themeProvider.notifier);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ExpansionTile(
      title: const Text('Settings'),
      leading: const Icon(Icons.settings_outlined),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        Text(
          'Theme: ${preference.mode == ThemeMode.system
              ? 'System'
              : preference.mode == ThemeMode.dark
              ? 'Dark'
              : 'Light'}',
        ),
        Row(
          children: [
            const Expanded(child: Text('Light')),
            Semantics(
              label: 'Dark theme',
              child: Switch(
                value: dark,
                onChanged: preference.saving
                    ? null
                    : (value) => action.choose(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
              ),
            ),
            const Expanded(child: Text('Dark', textAlign: TextAlign.end)),
          ],
        ),
        TextButton(
          onPressed: preference.saving
              ? null
              : () => action.choose(ThemeMode.system),
          child: const Text('Reset to System Default'),
        ),
        if (preference.error != null)
          Semantics(liveRegion: true, child: Text(preference.error!)),
        if (AppConfig.preview) const Text('Demo account'),
        const SizedBox(height: 12),
      ],
    );
  }
}

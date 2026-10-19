// metadata_version: 1
// purpose: Keep entry navigation and device appearance controls in the existing drawer.
// owner: unassigned
// related_adrs: [ADR-0013, ADR-0035]
import 'package:flutter/material.dart';

import 'appearance_settings.dart';

class EntryDrawer extends StatelessWidget {
  const EntryDrawer({super.key});
  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Close menu',
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                'Macro App',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              const AppearanceSettings(),
            ],
          ),
        ),
      ),
    ),
  );
}

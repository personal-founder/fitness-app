// metadata_version: 1
// purpose: "Startup fails closed when protected storage or client configuration cannot load."
// owner: unassigned
// related_adrs: [ADR-0028]
import 'package:flutter/material.dart';

class StartupError extends StatelessWidget {
  const StartupError({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Macro App could not open protected account storage. '
              'Unlock your device and restart the app. No account was opened.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );
}

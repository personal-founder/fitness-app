// metadata_version: 1
// purpose: "Public client configuration only. Server/service-role keys never belong here."
// owner: unassigned
// related_adrs: [ADR-0028]
import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const redirect = String.fromEnvironment('AUTH_REDIRECT_URL');
  static const previewState = String.fromEnvironment('PREVIEW_STATE');
  static bool get preview => previewState.isNotEmpty;
  static bool get configured =>
      validBackendUrl(url, allowLoopback: kDebugMode) && key.isNotEmpty;
}

// Plain HTTP is permitted only for local debug Supabase, never a remote backend.
bool validBackendUrl(String value, {bool allowLoopback = false}) {
  final uri = Uri.tryParse(value);
  if (uri == null ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment) {
    return false;
  }
  return uri.scheme == 'https' ||
      (allowLoopback &&
          uri.scheme == 'http' &&
          {'localhost', '127.0.0.1', '::1'}.contains(uri.host));
}

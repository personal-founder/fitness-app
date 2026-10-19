// metadata_version: 1
// purpose: Keep remote auth on HTTPS while allowing an explicit local debug backend.
// owner: unassigned
// related_adrs: [ADR-0014, ADR-0025]
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/app/config.dart';

void main() {
  test('HTTPS backend without credentials/query is accepted', () {
    expect(validBackendUrl('https://example.supabase.co'), true);
    expect(validBackendUrl('https://user:password@example.com'), false);
    expect(validBackendUrl('https://example.com?token=test'), false);
    expect(validBackendUrl('https://'), false);
  });
  test('HTTP backend is confined to explicit loopback debug use', () {
    expect(validBackendUrl('http://127.0.0.1:54321'), false);
    expect(
      validBackendUrl('http://127.0.0.1:54321', allowLoopback: true),
      true,
    );
    expect(
      validBackendUrl('http://remote.example', allowLoopback: true),
      false,
    );
  });
}

// metadata_version: 1
// purpose: "Official SDK exercised over real loopback HTTP; this does not prove hosted RLS."
// owner: unassigned
// related_adrs: [ADR-0025]
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:macro_app/core/auth/supabase_gateway.dart';
import 'package:macro_app/core/security/pkce_storage.dart';
import 'package:macro_app/features/auth/registration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'support/fakes.dart';

void main() {
  test(
    'SDK sends account requests and parses owner profile responses',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final requests = <String>[];
      final user = {
        'id': '00000000-0000-0000-0000-000000000001',
        'aud': 'authenticated',
        'email': 'test@example.com',
        'created_at': '2026-10-19T00:00:00Z',
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
      };
      final listener = server.listen((request) async {
        requests.add(request.uri.path);
        final body = await utf8.decoder.bind(request).join();
        Object response = <String, dynamic>{};
        if (request.uri.path.endsWith('/token')) {
          final payload = jsonDecode(body) as Map<String, dynamic>;
          expect(payload['email'], 'test@example.com');
          expect(payload['password'], 'synthetic password');
          response = {
            'access_token': 'synthetic-token',
            'refresh_token': 'synthetic-refresh',
            'token_type': 'bearer',
            'expires_in': 3600,
            'user': user,
          };
        } else if (request.uri.path.endsWith('/profiles')) {
          expect(request.uri.queryParameters['id'], 'eq.${user['id']}');
          expect(
            request.headers.value('authorization'),
            'Bearer synthetic-token',
          );
          response = {
            'first_name': 'Test',
            'last_name': 'Person',
            'nickname': 'King James',
            'display_name_mode': 'nickname',
            'account_tag': '#QF0001',
          };
        } else if (request.uri.path.endsWith('/signup')) {
          final payload = jsonDecode(body) as Map<String, dynamic>;
          expect(payload['data']['first_name'], 'Test');
          expect(payload['data']['account_tag'], null);
          response = user;
        }
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(response));
        await request.response.close();
      });
      final client = SupabaseClient(
        'http://127.0.0.1:${server.port}',
        'synthetic-public-key',
        authOptions: AuthClientOptions(
          autoRefreshToken: false,
          pkceAsyncStorage: ProtectedPkceStorage(vault: MemoryVault()),
        ),
      );
      addTearDown(() async {
        await client.dispose();
        await listener.cancel();
        await server.close(force: true);
      });
      final gateway = SupabaseGateway(client);
      await gateway.signIn(' TEST@example.com ', 'synthetic password');
      expect(gateway.userId, user['id']);
      expect((await gateway.profile()).displayName, 'King James');
      await gateway.signOut();
      expect(gateway.userId, null);
      expect(
        await gateway.register(
          const Registration(
            'Test',
            'Person',
            'test@example.com',
            'synthetic password',
          ),
        ),
        false,
      );
      expect(
        requests,
        containsAll([
          '/auth/v1/token',
          '/rest/v1/profiles',
          '/auth/v1/logout',
          '/auth/v1/signup',
        ]),
      );
    },
  );
}

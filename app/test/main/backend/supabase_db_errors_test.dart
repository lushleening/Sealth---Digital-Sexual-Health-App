import 'dart:io';

import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_db_errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('handleSupaDBErrors', () {
    test('SocketException should be caught and not rethrown', () {
      expect(
        () => handleSupaDBErrors(SocketException('No Internet')),
        returnsNormally,
      );
    });

    test('PostgrestException should be wrapped and rethrown as Exception', () {
      expect(
        () => handleSupaDBErrors(
          PostgrestException(message: 'Permission denied', code: '403'),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to fetch profile due to remote database issues'),
          ),
        ),
      );
    });

    test('Generic Object/Error should be rethrown as-is', () {
      expect(
        () => handleSupaDBErrors(ArgumentError('Wrong argument')),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}

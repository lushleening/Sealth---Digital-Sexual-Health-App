import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/authentication/auth_form/auth_form.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helper/mock_objects.dart';

void main() {
  late ProviderContainer container;
  late SupabaseAuth mockAuth;

  setUp(() {
    mockAuth = MockSupabaseAuth();
    container = ProviderContainer.test(
      overrides: [supabaseAuthProvider.overrideWithValue(mockAuth)],
    );
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Return credentials error when credentials are empty', () async {
    final t = AuthFormType.login;
    final result = await container
        .read(authFormProvider(t).notifier)
        .submit(email: '');
    expect(result, false);

    expect(
      container.read(authFormProvider(t)).emailError,
      'Email is a required field.',
    );
    expect(
      container.read(authFormProvider(t)).passwordError,
      'Password is a required field.',
    );
    verifyNever(() => mockAuth.loginWithEmailPassword(any(), any()));
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group(
    'Calls respective functions based on AuthFormType when successfully passed validations',
    () {
      test("login", () async {
        when(
          () => mockAuth.loginWithEmailPassword(email, password),
        ).thenAnswer((_) async => AuthResponse());

        final t = AuthFormType.login;
        final p = authFormProvider(t);
        final notifier = container.read(p.notifier);
        final result = await notifier.submit(email: email, password: password);
        expect(result, true);
        verify(
          () => mockAuth.loginWithEmailPassword(email, password),
        ).called(1);
        expect(
          container.read(authFormProvider(AuthFormType.login)).submitting,
          false,
        );
      });

      test("register", () async {
        when(
          () => mockAuth.registerEmailPassword(email, password),
        ).thenAnswer((_) async => AuthResponse());
        final t = AuthFormType.register;
        final p = authFormProvider(t);
        final notifier = container.read(p.notifier);
        final result = await notifier.submit(email: email, password: password);
        expect(result, true);
        verify(() => mockAuth.registerEmailPassword(email, password)).called(1);
        expect(
          container.read(authFormProvider(AuthFormType.login)).submitting,
          false,
        );
      });

      test("forgotPassword", () async {
        when(() => mockAuth.sendResetEmail(email)).thenAnswer((_) async {});
        final t = AuthFormType.forgotPassword;
        final p = authFormProvider(t);
        final notifier = container.read(p.notifier);
        final result = await notifier.submit(email: email, password: password);
        expect(result, true);
        verify(() => mockAuth.sendResetEmail(email)).called(1);
        expect(
          container.read(authFormProvider(AuthFormType.login)).submitting,
          false,
        );
      });

      test("resetPassword", () async {
        when(
          () => mockAuth.resetPassword(email, password),
        ).thenAnswer((_) async {});
        final t = AuthFormType.resetPassword;
        final p = authFormProvider(t);
        final notifier = container.read(p.notifier);
        final result = await notifier.submit(email: email, password: password);
        expect(result, true);
        verify(() => mockAuth.resetPassword(email, password)).called(1);
        expect(
          container.read(authFormProvider(AuthFormType.login)).submitting,
          false,
        );
      });
    },
  );

  group("Validator functions works properly", () {
    final formType = AuthFormType.register;

    test("emailValidator", () {
      final notifier = container.read(authFormProvider(formType).notifier);
      expect(notifier.emailValidator(''), 'Email is a required field.');
      expect(notifier.emailValidator('testemail'), 'Invalid email format.');
      expect(notifier.emailValidator(email), isNull);
    });

    test("passwordValidator", () {
      final notifier = container.read(authFormProvider(formType).notifier);
      expect(notifier.passwordValidator(''), 'Password is a required field.');
      expect(
        notifier.passwordValidator('1'),
        'Password length should not be less than 6 characters',
      );
      expect(notifier.passwordValidator(password), recommendStrongPassword);
      expect(notifier.passwordValidator(strongPassword), isNull);
    });

    test("confirmPasswordValidator", () {
      final notifier = container.read(authFormProvider(formType).notifier);
      expect(
        notifier.confirmPasswordValidator('', ''),
        "Please confirm your password.",
      );
      expect(
        notifier.confirmPasswordValidator(password, '$password%4'),
        "Passwords should be the same.",
      );
      expect(notifier.confirmPasswordValidator(password, password), null);
    });
  });
}

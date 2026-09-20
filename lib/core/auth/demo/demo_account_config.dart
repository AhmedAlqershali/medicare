import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/account_role.dart';

class DemoAccountConfig {
  DemoAccountConfig._();

  static const patientEmail = 'abunael28@gmail.com';
  static const doctorEmail = 'thebest102022@gmail.com';
  static const organizationEmail = 'abunael29@gmail.com';

  static String get password => const String.fromEnvironment('DEMO_PASSWORD', defaultValue: '');

  static bool get isDebugOnly => kDebugMode;

  static bool get isConfigured => isDebugOnly && password.isNotEmpty;

  static String get setupHint => 'flutter run --dart-define=DEMO_PASSWORD=Demo@123456';

  static ({String email, String password}) accountForRole(AccountRole role) {
    switch (role) {
      case AccountRole.patient:
        return (email: patientEmail, password: password);
      case AccountRole.doctor:
        return (email: doctorEmail, password: password);
      case AccountRole.organization:
        return (email: organizationEmail, password: password);
    }
  }

  static Future<String> ensureDemoAccounts() async {
    if (!isDebugOnly) {
      return 'Demo account seeding is disabled outside Debug mode.';
    }

    if (password.isEmpty) {
      return 'Demo password is not configured. Use --dart-define=DEMO_PASSWORD=Demo@123456';
    }

    final auth = FirebaseAuth.instance;
    final roles = [AccountRole.patient, AccountRole.doctor, AccountRole.organization];

    for (final role in roles) {
      final account = accountForRole(role);
      try {
        await auth.createUserWithEmailAndPassword(email: account.email, password: account.password);
      } on FirebaseAuthException catch (exception) {
        if (exception.code != 'email-already-in-use') {
          return exception.message ?? 'Unable to create demo account for $role.';
        }
      }
    }

    return 'Demo accounts are ready for local debugging.';
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:medicare/core/auth/data/mock_medicare_store.dart';
import 'package:medicare/core/auth/models/account_role.dart';
import 'package:medicare/core/auth/services/mock_auth_repository.dart';
import 'package:medicare/features/auth/auth_screens.dart';
import 'package:medicare/main.dart';

void main() {
  testWidgets('starts with the Arabic Medicare onboarding flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MedicareApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('رعايتك الصحية تبدأ بسهولة'), findsOneWidget);
  });

  test('patient account activation uses the exact email and activates only the matching record', () async {
    final doctor = MockMedicareStore.instance.doctors.first;
    final patient = MockMedicareStore.instance.addPatient(doctorId: doctor.id, name: 'مريض تجريبي', email: 'patient.test@example.com');

    expect(patient.accountActivated, isFalse);

    final exactMatch = await MockAuthRepository.instance.activatePatientAccount(email: 'patient.test@example.com', password: 'newPass123');
    expect(exactMatch.success, isTrue);
    expect(MockMedicareStore.instance.patientByEmail('patient.test@example.com')?.accountActivated, isTrue);

    final wrongEmail = await MockAuthRepository.instance.activatePatientAccount(email: 'wrong@example.com', password: 'newPass123');
    expect(wrongEmail.success, isFalse);

    final alreadyActive = await MockAuthRepository.instance.activatePatientAccount(email: 'patient.test@example.com', password: 'newPass123');
    expect(alreadyActive.success, isFalse);
    expect(MockAuthRepository.instance.currentRole, AccountRole.patient);
  });
}
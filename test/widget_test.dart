import 'package:flutter_test/flutter_test.dart';

import 'package:medicare/main.dart';
import 'package:medicare/features/auth/auth_screens.dart';

void main() {
  testWidgets('starts with the Arabic Medicare onboarding flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MedicareApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('رعايتك الصحية تبدأ بسهولة'), findsOneWidget);
  });

  testWidgets('logs in after validation and opens account type selection', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pump();
    expect(find.text('أدخل رقم الجوال أو البريد الإلكتروني'), findsOneWidget);
    expect(find.text('أدخل كلمة المرور'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'user@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byType(UserTypeScreen), findsOneWidget);
  });
}
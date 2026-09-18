import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/auth_screens.dart';

void main() {
  runApp(const MedicareApp());
}

class MedicareApp extends StatelessWidget {
  const MedicareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Medicare',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        home: const Directionality(textDirection: TextDirection.rtl, child: SplashScreen()),
      );
}
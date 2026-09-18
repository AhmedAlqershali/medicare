import 'package:flutter/material.dart';

import 'auth_screens.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _openUserType();
  }

  void _openUserType() => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const UserTypeScreen()));

  void _showForgotPasswordMessage() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم توفير استعادة كلمة المرور قريباً')));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.yellow,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'NO TEXTFIELD TEST',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'إذا اختفى المستطيل، فالسبب في TextFormField أو InputDecoration.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('TEST BUTTON'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
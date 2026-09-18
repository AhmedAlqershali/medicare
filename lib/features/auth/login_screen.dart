import 'package:flutter/material.dart';

import 'auth_screens.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text('Medicare'),
                      const SizedBox(height: 16),
                      const Text('مرحبا محمود'),
                      const SizedBox(height: 8),
                      const Text('مرحباً بعودتك'),
                      const SizedBox(height: 8),
                      const Text('سجل الدخول لمتابعة رعايتك الصحية'),
                      const SizedBox(height: 24),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Test field',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: const InputDecoration(
                          hintText: 'Test field',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: _showForgotPasswordMessage,
                          child: const Text('نسيت كلمة المرور؟'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading ? const CircularProgressIndicator() : const Text('تسجيل الدخول'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('ليس لديك حساب؟'),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen())),
                            child: const Text('إنشاء حساب'),
                          ),
                        ],
                      ),
                    ],
                ),
              ),
            ),
          ),
        ),
      );
}
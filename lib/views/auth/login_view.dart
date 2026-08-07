import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/views/auth/register_view.dart';
import 'package:kosmo/views/dashboard/dashboard_view.dart';
import 'package:kosmo/views/auth/forgot_password_view.dart';
import 'package:kosmo/views/auth/verify_otp_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailController.text.trim(), _passwordController.text);
    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardView()));
    } else if (auth.error != null && mounted) {
      final err = auth.error!;
      if (err.contains('Email not confirmed') || err.contains('unconfirmed')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email belum diverifikasi. Silakan masukkan nomor verifikasi.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpView(email: _emailController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Kosmo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            KosmoTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            KosmoTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordView())),
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, auth, _) => auth.isLoading
                  ? const CircularProgressIndicator()
                  : KosmoButton(
                      label: 'Login',
                      onPressed: _login,
                    ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView())),
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

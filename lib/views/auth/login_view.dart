import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailController.text.trim(), _passwordController.text);
    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardView()));
    } else if (auth.error != null && mounted) {
      final err = auth.error!;
      if (err.contains('Email not confirmed') || err.contains('unconfirmed')) {
        KosmoDialog.showError(
          context: context,
          title: 'Email Belum Diverifikasi',
          message: 'Silakan masukkan kode verifikasi (OTP) yang telah dikirimkan ke email Anda.',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpView(email: _emailController.text.trim()),
          ),
        );
      } else {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal Login',
          message: 'Email atau password salah. Silakan periksa kembali data Anda.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: AppBar(title: const Text('Login Kosmo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.apartment_rounded, color: KosmoTheme.primary, size: 64),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang Kembali',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: KosmoTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Masuk ke akun owner kosmo Anda',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: KosmoTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              KosmoTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password tidak boleh kosong';
                  if (val.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordView())),
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => auth.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : KosmoButton(
                        label: 'Login',
                        onPressed: _login,
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun? ', style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView())),
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

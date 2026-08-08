import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';

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
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (auth.error != null && mounted) {
      final err = auth.error!;
      if (err.contains('Email not confirmed') || err.contains('unconfirmed')) {
        KosmoDialog.showError(
          context: context,
          title: 'Email Belum Diverifikasi',
          message: 'Silakan masukkan kode verifikasi (OTP) yang telah dikirimkan ke email Anda.',
        );
        Navigator.pushNamed(context, AppRoutes.verifyOtp, arguments: _emailController.text.trim());
      } else {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal Login',
          message: err.isNotEmpty ? err : 'Email atau password salah. Silakan periksa kembali data Anda.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KosmoTheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 72,
                          width: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.apartment_rounded,
                            color: primaryAccent,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selamat Datang Kembali',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masuk ke akun manajemen Kosmo Anda',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF333333) : const Color(0xFFE8ECE9),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: primaryAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => auth.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : KosmoButton(
                                  label: 'Login',
                                  onPressed: _login,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: primaryAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}

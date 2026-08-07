import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      KosmoDialog.showError(
        context: context,
        title: 'Password Tidak Cocok',
        message: 'Konfirmasi password harus sama dengan password yang Anda masukkan.',
      );
      return;
    }

    final email = _emailController.text.trim();
    final auth = context.read<AuthProvider>();
    final success = await auth.register(email, _passwordController.text, _nameController.text.trim());
    if (success && mounted) {
      Navigator.pushNamed(context, AppRoutes.verifyOtp, arguments: email);
    } else if (auth.error != null && mounted) {
      KosmoDialog.showError(
        context: context,
        title: 'Pendaftaran Gagal',
        message: auth.error!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Kosmo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Buat Akun Owner Baru',
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
                'Kelola kos-kosan Anda secara mudah & efisien',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: KosmoTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              KosmoTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama lengkap tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password',
                isPassword: true,
                prefixIcon: Icons.lock_clock_outlined,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                  if (val != _passwordController.text) return 'Password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              Consumer<AuthProvider>(
                builder: (context, auth, _) => auth.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : KosmoButton(
                        label: 'Daftar & Minta Kode Verifikasi',
                        onPressed: _register,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

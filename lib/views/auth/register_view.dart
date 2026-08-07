import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/views/auth/verify_otp_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password tidak cocok')));
      return;
    }
    final email = _emailController.text.trim();
    final auth = context.read<AuthProvider>();
    final success = await auth.register(email, _passwordController.text, _nameController.text);
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpView(email: email),
        ),
      );
    } else if (auth.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            KosmoTextField(controller: _nameController, label: 'Nama Lengkap'),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            KosmoTextField(
              controller: _confirmPasswordController,
              label: 'Konfirmasi Password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, auth, _) => auth.isLoading
                  ? const CircularProgressIndicator()
                  : KosmoButton(
                      label: 'Daftar & Minta Kode Verifikasi',
                      onPressed: _register,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

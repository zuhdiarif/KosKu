import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/providers/auth_provider.dart';

class VerifyOtpView extends StatefulWidget {
  final String email;

  const VerifyOtpView({super.key, required this.email});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final _otpController = TextEditingController();

  void _verify() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(widget.email, _otpController.text.trim());
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifikasi Berhasil! Silakan Login.')),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    } else if (auth.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KosmoAppBar(title: 'Verifikasi Email'),
      backgroundColor: KosmoTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.mark_email_read_rounded,
              size: 80,
              color: KosmoTheme.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Masukkan Nomor Verifikasi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: KosmoTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nomor verifikasi 6-digit telah dikirim ke:\n${widget.email}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: KosmoTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            KosmoTextField(
              controller: _otpController,
              label: 'Kode Verifikasi (OTP)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, auth, _) => auth.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : KosmoButton(
                      label: 'Verifikasi & Login',
                      onPressed: _verify,
                    ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Kembali ke Pendaftaran',
                style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

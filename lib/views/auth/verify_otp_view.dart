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
    final token = _otpController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP wajib diisi.')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(widget.email, token);
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

  void _resend() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.resendOtp(widget.email);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP baru telah dikirim ke email Anda.')),
      );
    } else if (auth.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Verifikasi Email'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 44,
                  color: primaryAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Masukkan Kode Verifikasi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nomor verifikasi 6-digit telah dikirim ke:\n${widget.email}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
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
                    controller: _otpController,
                    label: 'Kode Verifikasi (OTP)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => auth.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : KosmoButton(
                            label: 'Verifikasi & Login',
                            onPressed: _verify,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resend,
              child: Text(
                'Kirim Ulang Kode OTP',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: primaryAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Kembali ke Pendaftaran',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

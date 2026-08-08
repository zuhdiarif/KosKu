import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/providers/theme_provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/providers/payment_provider.dart';
import 'package:kosmo/services/report_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _onNavTap(int index) {
    if (index == 4) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.kosList);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.tenantList);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.paymentList);
        break;
    }
  }

  void _exportPdfReport() async {
    final kosList = context.read<KosProvider>().kosList;
    final paymentList = context.read<PaymentProvider>().paymentList;

    if (kosList.isEmpty) {
      KosmoDialog.showError(context: context, title: 'Kosong', message: 'Anda belum memiliki properti kos');
      return;
    }

    await ReportService.generatePaymentReportPdf(
      kos: kosList.first,
      payments: paymentList,
    );
  }

  void _handleLogout() async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Konfirmasi Keluar',
      message: 'Apakah Anda yakin ingin keluar dari akun Kosmo?',
      confirmLabel: 'Ya, Keluar',
      isDangerous: true,
    );

    if (confirm && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    final user = context.watch<AuthProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Profil Saya', showBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                child: Text(
                  user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'O',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: primaryAccent,
                    fontSize: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.fullName ?? 'Owner Kosmo',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'owner@kosmo.com',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                children: [
                  ListTile(
                    leading: Icon(Icons.picture_as_pdf_rounded, color: primaryAccent),
                    title: const Text('Export Laporan Keuangan (PDF)', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportPdfReport,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.message_rounded, color: primaryAccent),
                    title: const Text('Template Pesan WhatsApp', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.email_rounded, color: primaryAccent),
                    title: const Text('Template Pesan Email', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: Icon(Icons.dark_mode_rounded, color: primaryAccent),
                    title: const Text('Mode Gelap', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                    value: themeProvider.isDarkMode,
                    activeThumbColor: primaryAccent,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: KosmoButton(
                label: 'Keluar',
                variant: KosmoButtonVariant.outline,
                onPressed: _handleLogout,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: KosmoBottomNav(
        currentIndex: 4,
        onTap: _onNavTap,
      ),
    );
  }
}

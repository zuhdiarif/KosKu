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
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.kosList);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.paymentList);
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
      kos: kosList.first, // Usually export for first kos or add selector later
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
    final user = context.watch<AuthProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Profil Saya'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                child: Text(
                  user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'O',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: KosmoTheme.primary,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'Owner Kosmo',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'owner@kosmo.com',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: KosmoTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf_rounded, color: KosmoTheme.primary),
                    title: const Text('Export Laporan Keuangan (PDF)', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportPdfReport,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.message, color: KosmoTheme.primary),
                    title: const Text('Template Pesan WhatsApp', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: KosmoTheme.primary),
                    title: const Text('Template Pesan Email', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode, color: KosmoTheme.primary),
                    title: const Text('Mode Gelap', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    value: themeProvider.isDarkMode,
                    activeThumbColor: KosmoTheme.primary,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        currentIndex: 3,
        onTap: _onNavTap,
      ),
    );
  }
}

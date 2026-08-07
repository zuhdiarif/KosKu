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
import 'package:kosmo/services/report_service.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/models/payment_model.dart';

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
    final dummyKos = KosModel(
      id: '1',
      ownerId: '1',
      name: 'Kosmo Mawar Premium',
      address: 'Jl. Mawar No. 12, Jakarta',
      totalRooms: 20,
      createdAt: DateTime.now(),
    );

    final dummyPayments = [
      PaymentModel(
        id: 'pay-001',
        tenantId: 't-1',
        roomId: 'r-1',
        amount: 1500000,
        dueDate: DateTime.now(),
        status: 'paid',
        createdAt: DateTime.now(),
      ),
      PaymentModel(
        id: 'pay-002',
        tenantId: 't-2',
        roomId: 'r-2',
        amount: 1500000,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'pending',
        createdAt: DateTime.now(),
      ),
    ];

    await ReportService.generatePaymentReportPdf(
      kos: dummyKos,
      payments: dummyPayments,
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
            Text(
              user?.phone ?? '+62 812 3456 7890',
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

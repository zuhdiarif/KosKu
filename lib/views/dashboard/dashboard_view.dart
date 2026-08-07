import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/connectivity_banner.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.kosList);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.paymentList);
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                height: 36,
                width: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.apartment_rounded, color: KosmoTheme.primary, size: 32),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Pagi,',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: KosmoTheme.textSecondary,
                  ),
                ),
                Text(
                  user?.fullName ?? 'Owner Kosmo',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: KosmoTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
              child: Text(
                user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'O',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: KosmoTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004532), Color(0xFF065F46)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pendapatan Bulan Ini',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Rp 12.500.000',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '+15% dari bulan lalu',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tingkat Hunian',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: KosmoTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '18/20 Kamar Terisi',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: KosmoTheme.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: Stack(
                            fit: StackFit.expand,
                            children: const [
                              CircularProgressIndicator(
                                value: 18 / 20,
                                backgroundColor: Color(0xFFF3F4F6),
                                valueColor: AlwaysStoppedAnimation<Color>(KosmoTheme.primary),
                                strokeWidth: 8,
                              ),
                              Center(
                                child: Text(
                                  '90%',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: KosmoTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Belum Bayar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KosmoTheme.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.paymentList),
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: KosmoTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildOverdueCard('Andi Wijaya', 'Kamar A102', 3, '081234567891', 'andi@example.com'),
                  const SizedBox(height: 8),
                  _buildOverdueCard('Siti Aminah', 'Kamar B205', 1, '081234567892', 'siti@example.com'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: KosmoBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildOverdueCard(String name, String room, int days, String phone, String email) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: KosmoTheme.errorContainer,
            child: Text(
              name[0],
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: KosmoTheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: KosmoTheme.textPrimary,
                  ),
                ),
                Text(
                  '$room • Telat $days hari',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: KosmoTheme.error,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => WhatsappService.sendReminder(
                  phone: phone,
                  tenantName: name,
                  month: 'Agustus 2026',
                  amount: '1.500.000',
                ),
                icon: const Icon(Icons.message, color: KosmoTheme.success, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                onPressed: () => WhatsappService.sendEmail(
                  email: email,
                  tenantName: name,
                  month: 'Agustus 2026',
                  amount: '1.500.000',
                  ownerName: 'Owner',
                ),
                icon: const Icon(Icons.email, color: KosmoTheme.secondary, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

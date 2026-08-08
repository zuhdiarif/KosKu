import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/connectivity_banner.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/providers/payment_provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/providers/tenant_provider.dart';
import 'package:kosmo/services/whatsapp_service.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KosProvider>().loadAll();
      context.read<PaymentProvider>().loadAll();
      context.read<PaymentProvider>().loadOverdue();
    });
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.kosList);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.tenantList);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.paymentList);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final paymentProvider = context.watch<PaymentProvider>();
    final kosProvider = context.watch<KosProvider>();
    final tenantProvider = context.watch<TenantProvider>();

    double totalRevenue = paymentProvider.paymentList
        .where((e) => e.status == 'paid')
        .fold(0.0, (sum, e) => sum + e.amount);

    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    int totalProperties = kosProvider.kosList.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
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
                          'Pendapatan Lunas',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatCurrency.format(totalRevenue),
                          style: const TextStyle(
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
                            '+ Total Semua Kos',
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
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.kosList),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
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
                                CircleAvatar(
                                  backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                                  child: const Icon(Icons.home_work_rounded, color: KosmoTheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Kos',
                                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary, fontSize: 12),
                                    ),
                                    Text(
                                      '$totalProperties Unit',
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.tenantList),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
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
                                CircleAvatar(
                                  backgroundColor: KosmoTheme.secondary.withValues(alpha: 0.1),
                                  child: const Icon(Icons.people_rounded, color: KosmoTheme.secondary),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Penghuni',
                                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary, fontSize: 12),
                                    ),
                                    Text(
                                      '${tenantProvider.tenantList.length} Orang',
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  if (paymentProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (paymentProvider.overdueList.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Tidak ada tagihan tertunggak 🎉',
                          style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...paymentProvider.overdueList.map((payment) {
                      final days = DateTime.now().difference(payment.dueDate).inDays;
                      final tenantList = tenantProvider.tenantList.where((t) => t.id == payment.tenantId).toList();
                      final tenantName = tenantList.isNotEmpty ? tenantList.first.name : payment.tenantId;
                      final tenantPhone = tenantList.isNotEmpty ? tenantList.first.phone : '';
                      final tenantEmail = tenantList.isNotEmpty ? (tenantList.first.email ?? '') : '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildOverdueCard(
                          tenantName, 
                          'Kamar ${payment.roomId}', 
                          days > 0 ? days : 0, 
                          tenantPhone, 
                          tenantEmail,
                          formatCurrency.format(payment.amount),
                        ),
                      );
                    }),
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

  Widget _buildOverdueCard(String name, String room, int days, String phone, String email, String amountStr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: KosmoTheme.errorContainer,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                  month: DateFormat('MMMM yyyy').format(DateTime.now()),
                  amount: amountStr,
                ),
                icon: const Icon(Icons.message, color: KosmoTheme.success, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                onPressed: () => WhatsappService.sendEmail(
                  email: email,
                  tenantName: name,
                  month: DateFormat('MMMM yyyy').format(DateTime.now()),
                  amount: amountStr,
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

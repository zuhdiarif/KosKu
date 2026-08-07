import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class PaymentListView extends StatefulWidget {
  const PaymentListView({super.key});

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Lunas', 'Pending', 'Nunggak'];
  final _searchController = TextEditingController();

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.kosList);
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KosmoAppBar(title: 'Riwayat Pembayaran'),
      backgroundColor: KosmoTheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: KosmoTextField(
              controller: _searchController,
              label: 'Cari Riwayat Pembayaran...',
              prefixIcon: Icons.search_rounded,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: isSelected ? Colors.white : KosmoTheme.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Theme.of(context).cardColor,
                    selectedColor: KosmoTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? KosmoTheme.primary : Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: KosmoTheme.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildPaymentCard(index);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.paymentForm),
        backgroundColor: KosmoTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: KosmoBottomNav(
        currentIndex: 2,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildPaymentCard(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Penghuni ${index + 1} - Kamar ${101 + index}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? KosmoTheme.primary.withValues(alpha: 0.1) : KosmoTheme.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    index % 2 == 0 ? 'Lunas' : 'Pending',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: index % 2 == 0 ? KosmoTheme.primary : KosmoTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Rp 1.500.000',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: KosmoTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Jatuh Tempo: ${15 + index} Agustus 2026',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: KosmoTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => WhatsappService.sendEmail(
                    email: 'penghuni$index@example.com',
                    tenantName: 'Penghuni ${index + 1}',
                    month: 'Agustus 2026',
                    amount: '1.500.000',
                    ownerName: 'Owner Kosmo',
                  ),
                  icon: const Icon(Icons.email_outlined, size: 16),
                  label: const Text('Email'),
                  style: TextButton.styleFrom(
                    foregroundColor: KosmoTheme.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => WhatsappService.sendReminder(
                    phone: '08123456789$index',
                    tenantName: 'Penghuni ${index + 1}',
                    month: 'Agustus 2026',
                    amount: '1.500.000',
                  ),
                  icon: const Icon(Icons.message_outlined, size: 16),
                  label: const Text('WA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KosmoTheme.success,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

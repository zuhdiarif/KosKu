import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_empty_state.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/services/whatsapp_service.dart';
import 'package:kosmo/providers/payment_provider.dart';
import 'package:kosmo/providers/tenant_provider.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:intl/intl.dart';

class PaymentListView extends StatefulWidget {
  const PaymentListView({super.key});

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Lunas', 'Pending', 'Nunggak'];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().loadAll();
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    await context.read<PaymentProvider>().loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    List<PaymentModel> filtered = provider.paymentList;
    if (_selectedFilter == 'Lunas') {
      filtered = filtered.where((e) => e.status == 'paid').toList();
    } else if (_selectedFilter == 'Pending') {
      filtered = filtered.where((e) => e.status == 'pending').toList();
    } else if (_selectedFilter == 'Nunggak') {
      filtered = filtered.where((e) => e.status == 'overdue').toList();
    }

    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      filtered = filtered.where((e) => 
        (e.notes?.toLowerCase().contains(q) ?? false) || 
        (e.tenantId.toLowerCase().contains(q))
      ).toList();
    }

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Riwayat Pembayaran'),
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
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(provider.error!, style: const TextStyle(fontFamily: 'Poppins', color: KosmoTheme.error)),
                            const SizedBox(height: 16),
                            KosmoButton(label: 'Coba Lagi', onPressed: _refreshData, variant: KosmoButtonVariant.outline),
                          ],
                        ),
                      )
                    : filtered.isEmpty
                        ? const KosmoEmptyState(
                            icon: Icons.receipt_long_rounded,
                            title: 'Belum Ada Pembayaran',
                            subtitle: 'Daftar pembayaran akan muncul di sini',
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshData,
                            color: KosmoTheme.primary,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return _buildPaymentCard(filtered[index]);
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

  Widget _buildPaymentCard(PaymentModel payment) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isLunas = payment.status == 'paid';
    final isOverdue = payment.status == 'overdue';

    Color statusColor = isLunas ? KosmoTheme.primary : (isOverdue ? KosmoTheme.error : KosmoTheme.warning);
    String statusText = isLunas ? 'Lunas' : (isOverdue ? 'Nunggak' : 'Pending');

    final tenantList = context.read<TenantProvider>().tenantList.where((t) => t.id == payment.tenantId).toList();
    final tenantName = tenantList.isNotEmpty ? tenantList.first.name : payment.tenantId;
    final tenantPhone = tenantList.isNotEmpty ? tenantList.first.phone : '';
    final tenantEmail = tenantList.isNotEmpty ? (tenantList.first.email ?? '') : '';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.paymentDetail, arguments: payment),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    payment.notes?.isNotEmpty == true ? payment.notes! : 'Pembayaran $tenantName',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency.format(payment.amount),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: KosmoTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(payment.dueDate)}',
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
                IconButton(
                  onPressed: () {
                    context.read<PaymentProvider>().delete(payment.id);
                  },
                  icon: const Icon(Icons.delete_outline, size: 20, color: KosmoTheme.error),
                ),
                TextButton.icon(
                  onPressed: () => WhatsappService.sendEmail(
                    email: tenantEmail,
                    tenantName: tenantName,
                    month: DateFormat('MMMM yyyy').format(payment.dueDate),
                    amount: formatCurrency.format(payment.amount),
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
                    phone: tenantPhone,
                    tenantName: tenantName,
                    month: DateFormat('MMMM yyyy').format(payment.dueDate),
                    amount: formatCurrency.format(payment.amount),
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
    ),
  );
}
}

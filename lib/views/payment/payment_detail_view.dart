import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:kosmo/providers/payment_provider.dart';
import 'package:kosmo/providers/tenant_provider.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class PaymentDetailView extends StatelessWidget {
  final PaymentModel payment;

  const PaymentDetailView({super.key, required this.payment});

  void _markAsPaid(BuildContext context) async {
    final updated = payment.copyWith(
      status: 'paid',
      paymentDate: DateTime.now(),
    );

    final success = await context.read<PaymentProvider>().update(updated);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status pembayaran berhasil diubah ke Lunas.')),
      );
      Navigator.pop(context);
    } else if (context.mounted) {
      final error = context.read<PaymentProvider>().error ?? 'Gagal memperbarui status.';
      KosmoDialog.showError(context: context, title: 'Gagal', message: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isPaid = payment.status == 'paid';
    final isOverdue = payment.status == 'overdue';

    Color statusColor = isPaid ? KosmoTheme.primary : (isOverdue ? KosmoTheme.error : KosmoTheme.warning);
    String statusLabel = isPaid ? 'LUNAS' : (isOverdue ? 'NUNGGAK' : 'PENDING');

    final tenantList = context.watch<TenantProvider>().tenantList.where((t) => t.id == payment.tenantId).toList();
    final tenantName = tenantList.isNotEmpty ? tenantList.first.name : payment.tenantId;
    final tenantPhone = tenantList.isNotEmpty ? tenantList.first.phone : '';
    final tenantEmail = tenantList.isNotEmpty ? (tenantList.first.email ?? '') : '';

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Detail Pembayaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formatCurrency.format(payment.amount),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: KosmoTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Penghuni', tenantName),
                    const Divider(),
                    _buildInfoRow('Kamar', 'Kamar ${payment.roomId}'),
                    const Divider(),
                    _buildInfoRow('Jatuh Tempo', DateFormat('dd MMM yyyy').format(payment.dueDate)),
                    const Divider(),
                    _buildInfoRow(
                      'Tanggal Bayar',
                      payment.paymentDate != null ? DateFormat('dd MMM yyyy').format(payment.paymentDate!) : '-',
                    ),
                    const Divider(),
                    _buildInfoRow('Catatan', payment.notes?.isNotEmpty == true ? payment.notes! : '-'),
                  ],
                ),
              ),
            ),
            if (!isPaid) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _markAsPaid(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KosmoTheme.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tandai Lunas', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => WhatsappService.sendReminder(
                        phone: tenantPhone,
                        tenantName: tenantName,
                        month: DateFormat('MMMM yyyy').format(payment.dueDate),
                        amount: formatCurrency.format(payment.amount),
                      ),
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('Ingatkan WA', style: TextStyle(fontFamily: 'Poppins')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: KosmoTheme.success,
                        side: const BorderSide(color: KosmoTheme.success),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => WhatsappService.sendEmail(
                        email: tenantEmail,
                        tenantName: tenantName,
                        month: DateFormat('MMMM yyyy').format(payment.dueDate),
                        amount: formatCurrency.format(payment.amount),
                        ownerName: 'Owner Kosmo',
                      ),
                      icon: const Icon(Icons.email, size: 18),
                      label: const Text('Ingatkan Email', style: TextStyle(fontFamily: 'Poppins')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: KosmoTheme.secondary,
                        side: const BorderSide(color: KosmoTheme.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: KosmoTheme.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

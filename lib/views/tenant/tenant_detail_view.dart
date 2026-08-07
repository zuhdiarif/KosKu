import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/services/whatsapp_service.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/providers/tenant_provider.dart';

class TenantDetailView extends StatelessWidget {
  final TenantModel tenant;

  const TenantDetailView({super.key, required this.tenant});

  void _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Data Penghuni',
      message: 'Apakah Anda yakin ingin menghapus data penghuni ${tenant.name}?',
      confirmLabel: 'Ya, Hapus',
      isDangerous: true,
    );

    if (confirm && context.mounted) {
      final success = await context.read<TenantProvider>().delete(tenant.id, tenant.kosId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data penghuni berhasil dihapus.')),
        );
        Navigator.pop(context);
      } else if (context.mounted) {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal',
          message: context.read<TenantProvider>().error ?? 'Gagal menghapus penghuni',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArrears = tenant.status.toLowerCase() == 'overdue';
    final statusColor = isArrears ? KosmoTheme.error : (tenant.status.toLowerCase() == 'active' ? KosmoTheme.primary : KosmoTheme.textSecondary);
    final statusBgColor = isArrears ? KosmoTheme.error.withValues(alpha: 0.1) : (tenant.status.toLowerCase() == 'active' ? KosmoTheme.primary.withValues(alpha: 0.1) : KosmoTheme.textSecondary.withValues(alpha: 0.1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penghuni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tenantForm, arguments: {'kosId': tenant.kosId, 'tenant': tenant}),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: KosmoTheme.error),
            onPressed: () => _handleDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
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
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      tenant.name.isNotEmpty ? tenant.name[0].toUpperCase() : 'P',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: KosmoTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tenant.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kamar ${tenant.roomId}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: KosmoTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Status: ${tenant.status.toUpperCase()}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Informasi Pribadi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.badge_outlined, 'No. KTP', tenant.idCardNumber ?? '-'),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.phone_outlined, 'No. WhatsApp', tenant.phone),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.email_outlined, 'Email', tenant.email ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Informasi Kontrak',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today_outlined, 'Tanggal Masuk', DateFormat('d MMM yyyy').format(tenant.startDate)),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.event_available_outlined, 'Jatuh Tempo Berikutnya', tenant.endDate != null ? DateFormat('d MMM yyyy').format(tenant.endDate!) : '-'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => WhatsappService.sendReminder(
                      phone: tenant.phone,
                      tenantName: tenant.name,
                      month: '',
                      amount: '',
                    ),
                    icon: const Icon(Icons.message_rounded, color: KosmoTheme.success),
                    label: const Text(
                      'Ingatkan WA',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.success, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KosmoTheme.success),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => WhatsappService.sendEmail(
                      email: tenant.email ?? '',
                      tenantName: tenant.name,
                      month: '',
                      amount: '',
                      ownerName: '',
                    ),
                    icon: const Icon(Icons.email_rounded, color: KosmoTheme.secondary),
                    label: const Text(
                      'Ingatkan Email',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.secondary, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KosmoTheme.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: KosmoTheme.textSecondary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: KosmoTheme.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

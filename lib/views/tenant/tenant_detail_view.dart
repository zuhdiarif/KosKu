import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    final isArrears = tenant.status.toLowerCase() == 'overdue';
    final statusColor = isArrears ? KosmoTheme.error : (tenant.status.toLowerCase() == 'active' ? primaryAccent : (isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary));
    final statusBgColor = isArrears ? KosmoTheme.error.withValues(alpha: 0.1) : (tenant.status.toLowerCase() == 'active' ? KosmoTheme.primary.withValues(alpha: 0.1) : (isDark ? Colors.grey[800] : Colors.grey[200]));

    return Scaffold(
      appBar: KosmoAppBar(
        title: 'Detail Penghuni',
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: primaryAccent),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tenantForm, arguments: {'kosId': tenant.kosId, 'tenant': tenant}),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: KosmoTheme.error),
            onPressed: () => _handleDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
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
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      tenant.name.isNotEmpty ? tenant.name[0].toUpperCase() : 'P',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: primaryAccent),
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
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: primaryAccent,
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
                        fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE8ECE9),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.badge_outlined, 'No. KTP', tenant.idCardNumber ?? '-', context),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.phone_outlined, 'No. WhatsApp', tenant.phone, context),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.email_outlined, 'Email', tenant.email ?? '-', context),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE8ECE9),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today_outlined, 'Tanggal Masuk', DateFormat('d MMM yyyy').format(tenant.startDate), context),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.event_available_outlined, 'Jatuh Tempo Berikutnya', tenant.endDate != null ? DateFormat('d MMM yyyy').format(tenant.endDate!) : '-', context),
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
                      month: 'Bulan Ini',
                      amount: 'Sewa Kos',
                    ),
                    icon: const Icon(Icons.message_rounded, color: KosmoTheme.success),
                    label: const Text(
                      'Ingatkan WA',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.success, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KosmoTheme.success, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => WhatsappService.sendEmail(
                      email: tenant.email ?? '',
                      tenantName: tenant.name,
                      month: 'Bulan Ini',
                      amount: 'Sewa Kos',
                      ownerName: 'Owner Kosmo',
                    ),
                    icon: const Icon(Icons.email_rounded, color: KosmoTheme.secondary),
                    label: const Text(
                      'Ingatkan Email',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.secondary, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KosmoTheme.secondary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _buildInfoRow(IconData icon, String label, String value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

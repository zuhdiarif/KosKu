import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class TenantDetailView extends StatelessWidget {
  const TenantDetailView({super.key});

  void _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Data Penghuni',
      message: 'Apakah Anda yakin ingin menghapus data penghuni Andi Wijaya?',
      confirmLabel: 'Ya, Hapus',
      isDangerous: true,
    );

    if (confirm && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data penghuni berhasil dihapus.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const tenantName = 'Andi Wijaya';
    const roomNumber = 'Kamar 101';
    const phone = '081234567890';
    const email = 'andi.wijaya@email.com';

    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: AppBar(
        title: const Text('Detail Penghuni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tenantForm),
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
                    child: const Text(
                      'A',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: KosmoTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    tenantName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    roomNumber,
                    style: TextStyle(
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
                      color: KosmoTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Status: Aktif',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: KosmoTheme.primary,
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
                  _buildInfoRow(Icons.badge_outlined, 'No. KTP', '3171234567890001'),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.phone_outlined, 'No. WhatsApp', phone),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.email_outlined, 'Email', email),
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
                  _buildInfoRow(Icons.calendar_today_outlined, 'Tanggal Masuk', '1 Jan 2026'),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.event_available_outlined, 'Jatuh Tempo Berikutnya', '1 Sep 2026'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => WhatsappService.sendReminder(
                      phone: phone,
                      tenantName: tenantName,
                      month: 'Agustus 2026',
                      amount: '1.500.000',
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
                      email: email,
                      tenantName: tenantName,
                      month: 'Agustus 2026',
                      amount: '1.500.000',
                      ownerName: 'Owner Kosmo',
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

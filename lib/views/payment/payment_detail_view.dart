import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class PaymentDetailView extends StatelessWidget {
  const PaymentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: KosmoTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PENDING',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: KosmoTheme.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rp 1.500.000',
                    style: TextStyle(
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
                    _buildInfoRow('Penghuni', 'Budi Santoso'),
                    const Divider(),
                    _buildInfoRow('Kamar', 'Kamar A101'),
                    const Divider(),
                    _buildInfoRow('Jatuh Tempo', '15 Agustus 2026'),
                    const Divider(),
                    _buildInfoRow('Tanggal Bayar', '-'),
                    const Divider(),
                    _buildInfoRow('Catatan', 'Sewa Bulanan'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bukti Pembayaran',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Gambar Bukti', style: TextStyle(fontFamily: 'Poppins')),
                  style: TextButton.styleFrom(foregroundColor: KosmoTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Status diubah ke Lunas')),
                );
              },
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
                      phone: '081234567890',
                      tenantName: 'Budi Santoso',
                      month: 'Agustus 2026',
                      amount: '1.500.000',
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
                      email: 'budi@example.com',
                      tenantName: 'Budi Santoso',
                      month: 'Agustus 2026',
                      amount: '1.500.000',
                      ownerName: 'Owner',
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

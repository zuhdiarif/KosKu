import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_button.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const KosmoAppBar(
          title: 'Log & Template Pengingat',
        ),
        backgroundColor: KosmoTheme.background,
        body: Column(
          children: [
            Material(
              color: Theme.of(context).cardColor,
              child: const TabBar(
                labelColor: KosmoTheme.primary,
                unselectedLabelColor: KosmoTheme.textSecondary,
                indicatorColor: KosmoTheme.primary,
                labelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Riwayat Pengingat'),
                  Tab(text: 'Template Pesan'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHistoryTab(),
                  _buildTemplatesTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        final isWa = index % 2 == 0;

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
                    const Text(
                      'Pengingat Pembayaran',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: KosmoTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Terkirim',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: KosmoTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Halo Penghuni ${index + 1}, tagihan kos kamar ${101 + index} sebesar Rp 1.500.000 jatuh tempo pada ${15 + index} Agustus 2026.',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: KosmoTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isWa ? Icons.message_rounded : Icons.email_rounded,
                          size: 16,
                          color: isWa ? KosmoTheme.success : KosmoTheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isWa ? 'WhatsApp' : 'Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isWa ? KosmoTheme.success : KosmoTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '07 Ags 2026, 0${9 + index}:00',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: KosmoTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemplatesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Template Pesan WhatsApp',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: 'Halo {nama}, ini pengingat pembayaran kos bulan {bulan} sebesar Rp{nominal}. Mohon segera dilunasi. Terima kasih.',
            maxLines: 4,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Template Pesan Email',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: 'Yth. {nama},\n\nIni adalah pengingat pembayaran kos bulan {bulan} sebesar Rp{nominal}.\nMohon segera melakukan pelunasan.\n\nTerima kasih,\n{ownerName}',
            maxLines: 5,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
          const SizedBox(height: 28),
          KosmoButton(
            label: 'Simpan Perubahan Template',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template pengingat berhasil disimpan.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

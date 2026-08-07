import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const KosmoAppBar(
          title: 'Log Pengingat',
        ),
        backgroundColor: KosmoTheme.background,
        body: Column(
          children: [
            const Material(
              color: Colors.white,
              child: TabBar(
                labelColor: KosmoTheme.primary,
                unselectedLabelColor: KosmoTheme.textSecondary,
                indicatorColor: KosmoTheme.primary,
                labelStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Riwayat'),
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
        return Card(
          elevation: 1,
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
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: KosmoTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Terkirim',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: KosmoTheme.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Halo Budi, tagihan kos kamar A101 sebesar Rp 1.500.000 jatuh tempo pada 15 Agustus 2026.',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          index % 2 == 0 ? Icons.message : Icons.email,
                          size: 16,
                          color: KosmoTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          index % 2 == 0 ? 'WhatsApp' : 'Email',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: KosmoTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '07 Ags 2026, 09:00',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
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
            'Template WhatsApp',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: 'Halo {nama}, tagihan kos kamar {kamar} sebesar {nominal} jatuh tempo pada {tanggal}.',
            maxLines: 4,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Template Email',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: 'Yth. {nama},\n\nKami mengingatkan bahwa tagihan kos Anda untuk kamar {kamar} sebesar {nominal} jatuh tempo pada {tanggal}.\n\nTerima kasih.',
            maxLines: 5,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template disimpan')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: KosmoTheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Simpan Template',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

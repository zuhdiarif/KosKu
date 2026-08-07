import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_empty_state.dart';
import 'package:kosmo/providers/notification_provider.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<NotificationProvider>().loadByOwnerId(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const KosmoAppBar(
          title: 'Log & Template Pengingat',
        ),
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
    final provider = context.watch<NotificationProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.notificationList.isEmpty) {
      return const KosmoEmptyState(
        icon: Icons.notifications_off_outlined,
        title: 'Tidak Ada Riwayat',
        subtitle: 'Riwayat notifikasi akan muncul di sini',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final user = context.read<AuthProvider>().user;
        if (user != null) {
          await context.read<NotificationProvider>().loadByOwnerId(user.id);
        }
      },
      color: KosmoTheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: provider.notificationList.length,
        itemBuilder: (context, index) {
        final notification = provider.notificationList[index];
        final isWa = notification.sentVia == 'whatsapp';

        return Card(
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
                    Text(
                      notification.type == 'payment_reminder' ? 'Pengingat Pembayaran' : 'Notifikasi',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: notification.isSent 
                            ? KosmoTheme.primary.withValues(alpha: 0.1)
                            : KosmoTheme.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        notification.isSent ? 'Terkirim' : 'Pending',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: notification.isSent ? KosmoTheme.primary : KosmoTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
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
                      DateFormat('dd MMM yyyy, HH:mm').format(notification.createdAt),
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
    ),
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

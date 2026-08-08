import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/models/room_model.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/providers/room_provider.dart';
import 'package:kosmo/providers/tenant_provider.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class RoomDetailView extends StatelessWidget {
  final RoomModel room;

  const RoomDetailView({super.key, required this.room});

  void _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Kamar',
      message: 'Apakah Anda yakin ingin menghapus kamar ${room.roomNumber}?',
      confirmLabel: 'Hapus',
      isDangerous: true,
    );
    if (confirm && context.mounted) {
      final success = await context.read<RoomProvider>().delete(room.id, room.kosId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamar berhasil dihapus')),
        );
        Navigator.pop(context);
      } else if (context.mounted) {
        final error = context.read<RoomProvider>().error ?? 'Gagal menghapus kamar';
        KosmoDialog.showError(context: context, title: 'Gagal', message: error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    Color statusColor;
    Color statusBgColor;
    String statusLabel;

    switch (room.status.toLowerCase()) {
      case 'occupied':
        statusColor = KosmoTheme.error;
        statusBgColor = KosmoTheme.error.withValues(alpha: 0.1);
        statusLabel = 'Terisi';
        break;
      case 'maintenance':
        statusColor = KosmoTheme.warning;
        statusBgColor = KosmoTheme.warning.withValues(alpha: 0.1);
        statusLabel = 'Perbaikan';
        break;
      default:
        statusColor = KosmoTheme.primary;
        statusBgColor = KosmoTheme.primary.withValues(alpha: 0.1);
        statusLabel = 'Tersedia';
        break;
    }

    final tenantList = context.watch<TenantProvider>().tenantList.where((t) => t.roomId == room.id || t.roomId == room.roomNumber).toList();
    final TenantModel? currentTenant = tenantList.isNotEmpty ? tenantList.first : null;

    return Scaffold(
      appBar: KosmoAppBar(
        title: 'Kamar ${room.roomNumber}',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.roomForm,
                arguments: {'kosId': room.kosId, 'room': room},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: KosmoTheme.error),
            onPressed: () => _handleDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KosmoTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: KosmoTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.meeting_room_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kamar ${room.roomNumber}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (room.floor != null)
                          Text(
                            'Lantai ${room.floor}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: KosmoTheme.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Harga Sewa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: KosmoTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${formatCurrency.format(room.price)} / bulan',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status Kamar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: KosmoTheme.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusLabel,
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
                ],
              ),
            ),
            if (room.facilities != null && room.facilities!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Fasilitas Kamar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: room.facilities!.entries.map((e) {
                  return _buildFacilityChip(
                    Icons.check_circle_outline,
                    '${e.key}: ${e.value}',
                    context,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Penghuni Kamar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (currentTenant != null) ...[
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tenantDetail,
                    arguments: currentTenant,
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          currentTenant.name.isNotEmpty ? currentTenant.name[0].toUpperCase() : 'P',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: KosmoTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTenant.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentTenant.phone,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: KosmoTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => WhatsappService.sendReminder(
                          phone: currentTenant.phone,
                          tenantName: currentTenant.name,
                          month: 'Bulan Ini',
                          amount: formatCurrency.format(room.price),
                        ),
                        icon: const Icon(Icons.message_rounded, color: KosmoTheme.success),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Kamar ini belum memiliki penghuni.',
                      style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    KosmoButton(
                      label: 'Tambah Penghuni di Kamar Ini',
                      icon: Icons.person_add_rounded,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.tenantForm,
                          arguments: {'kosId': room.kosId, 'tenant': null},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: KosmoTheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
          ),
        ],
      ),
    );
  }
}

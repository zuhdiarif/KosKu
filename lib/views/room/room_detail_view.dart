import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/models/room_model.dart';
import 'package:kosmo/providers/room_provider.dart';
import 'package:kosmo/components/kosmo_dialog.dart';

class RoomDetailView extends StatelessWidget {
  final RoomModel room;
  const RoomDetailView({super.key, required this.room});

  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Kamar',
      message:
          'Apakah Anda yakin ingin menghapus kamar ${room.roomNumber}? Tindakan ini tidak dapat dibatalkan.',
      confirmLabel: 'Hapus',
      isDangerous: true,
    );

    if (confirm == true) {
      if (context.mounted) {
        final success = await context.read<RoomProvider>().delete(
          room.id,
          room.kosId,
        );
        if (success && context.mounted) {
          Navigator.pop(context);
        } else if (context.mounted) {
          final error =
              context.read<RoomProvider>().error ?? 'Gagal menghapus kamar';
          KosmoDialog.showError(
            context: context,
            title: 'Error',
            message: error,
          );
        }
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

    String statusLabel = 'Tersedia';
    Color statusColor = KosmoTheme.primary;
    Color statusBgColor = KosmoTheme.primary.withValues(alpha: 0.1);

    if (room.status == 'occupied') {
      statusLabel = 'Terisi';
      statusColor = KosmoTheme.error;
      statusBgColor = KosmoTheme.errorContainer;
    } else if (room.status == 'maintenance') {
      statusLabel = 'Maintenance';
      statusColor = KosmoTheme.warning;
      statusBgColor = KosmoTheme.warning.withValues(alpha: 0.1);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kamar ${room.roomNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.roomForm,
              arguments: {'kosId': room.kosId, 'room': room},
            ),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/room_interior.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: KosmoTheme.primary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.meeting_room,
                    size: 64,
                    color: KosmoTheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                  if (room.floor != null) ...[
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lantai',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: KosmoTheme.textSecondary,
                          ),
                        ),
                        Text(
                          'Lantai ${room.floor}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
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
            if (room.status == 'occupied') ...[
              const SizedBox(height: 24),
              const Text(
                'Penghuni Saat Ini',
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
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: KosmoTheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: const Text(
                        'P',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: KosmoTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Data Penghuni',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Fitur penghuni akan diimplementasikan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: KosmoTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: KosmoTheme.textSecondary,
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
    return Chip(
      avatar: Icon(icon, size: 16, color: KosmoTheme.primary),
      label: Text(
        label,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
      ),
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE1E3E4)),
      ),
    );
  }
}

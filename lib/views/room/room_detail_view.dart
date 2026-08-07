import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';

class RoomDetailView extends StatelessWidget {
  const RoomDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: AppBar(
        title: const Text('Detail Kamar 101'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.roomForm),
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
                  child: const Icon(Icons.meeting_room, size: 64, color: KosmoTheme.primary),
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
                    children: const [
                      Text(
                        'Harga Sewa',
                        style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
                      ),
                      Text(
                        'Rp 1.500.000 / bulan',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status Kamar',
                        style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: KosmoTheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Terisi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: KosmoTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Lantai',
                        style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.textSecondary),
                      ),
                      Text(
                        'Lantai 1',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              children: [
                _buildFacilityChip(Icons.ac_unit_rounded, 'AC'),
                _buildFacilityChip(Icons.wifi_rounded, 'WiFi High-Speed'),
                _buildFacilityChip(Icons.bed_rounded, 'Kasur Springbed'),
                _buildFacilityChip(Icons.shower_rounded, 'Kamar Mandi Dalam'),
                _buildFacilityChip(Icons.table_restaurant_rounded, 'Meja Belajar'),
              ],
            ),
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
                    backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                    child: const Text(
                      'A',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: KosmoTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Andi Wijaya',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Sejak: 1 Jan 2026 • 081234567891',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: KosmoTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: KosmoTheme.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: KosmoTheme.primary),
      label: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE1E3E4))),
    );
  }
}

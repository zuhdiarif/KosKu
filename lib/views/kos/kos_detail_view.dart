import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_dialog.dart';

class KosDetailView extends StatelessWidget {
  const KosDetailView({super.key});

  void _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Kos',
      message: 'Apakah Anda yakin ingin menghapus properti Kos Mawar? Seluruh data kamar & penghuni di dalamnya akan terhapus.',
      confirmLabel: 'Ya, Hapus',
      isDangerous: true,
    );

    if (confirm && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data kos berhasil dihapus.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: AppBar(
        title: const Text('Detail Kosmo Mawar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.kosForm),
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
                'assets/images/kos_building.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: KosmoTheme.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.home_work, size: 64, color: KosmoTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: KosmoTheme.textSecondary, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Jl. Sudirman No. 12, Jakarta',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: KosmoTheme.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem('Total Kamar', '15'),
                      _buildInfoItem('Terisi', '12'),
                      _buildInfoItem('Kosong', '3'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Kamar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KosmoTheme.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.roomForm);
                  },
                  icon: const Icon(Icons.add, color: KosmoTheme.primary, size: 20),
                  label: const Text(
                    'Tambah Kamar',
                    style: TextStyle(fontFamily: 'Poppins', color: KosmoTheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Kamar ${101 + index}',
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Rp 1.500.000 / bulan',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: KosmoTheme.textSecondary),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? KosmoTheme.errorContainer : KosmoTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        index == 0 ? 'Terisi' : 'Tersedia',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: index == 0 ? KosmoTheme.error : KosmoTheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KosmoTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: KosmoTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

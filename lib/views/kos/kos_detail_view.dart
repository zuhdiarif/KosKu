import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/components/kosmo_button.dart';

class KosDetailView extends StatelessWidget {
  final KosModel kos;
  
  const KosDetailView({super.key, required this.kos});

  void _handleDelete(BuildContext context) async {
    final confirm = await KosmoDialog.showConfirm(
      context: context,
      title: 'Hapus Kos',
      message: 'Apakah Anda yakin ingin menghapus properti ${kos.name}? Seluruh data kamar & penghuni di dalamnya akan terhapus.',
      confirmLabel: 'Ya, Hapus',
      isDangerous: true,
    );

    if (confirm && context.mounted) {
      final success = await context.read<KosProvider>().delete(kos.id);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kos berhasil dihapus.')),
        );
        Navigator.pop(context);
      } else if (context.mounted) {
        final error = context.read<KosProvider>().error ?? 'Terjadi kesalahan saat menghapus.';
        KosmoDialog.showError(context: context, title: 'Gagal Menghapus', message: error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail ${kos.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: KosmoTheme.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.kosForm, arguments: kos),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: KosmoTheme.textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kos.address,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (kos.description != null && kos.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      kos.description!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: KosmoTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoItem('Total Kamar', '${kos.totalRooms}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            KosmoButton(
              label: 'Lihat Daftar Kamar',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.roomList, arguments: kos.id);
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

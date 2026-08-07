import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';

class KosListView extends StatelessWidget {
  const KosListView({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.paymentList);
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: const KosmoAppBar(title: 'Daftar Kos'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.kosDetail);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/kos_building.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: KosmoTheme.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.home_work, color: KosmoTheme.primary, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kosmo Mawar ${index + 1}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: KosmoTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jl. Sudirman No. ${10 + index}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: KosmoTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '15 Kamar • Terisi 12',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: KosmoTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.kosForm);
        },
        backgroundColor: KosmoTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: KosmoBottomNav(
        currentIndex: 1,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

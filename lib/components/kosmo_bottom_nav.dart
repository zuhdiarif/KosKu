import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';

class KosmoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const KosmoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: KosmoTheme.primary,
      unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : KosmoTheme.textSecondary,
      selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.apartment_rounded), label: 'Kos'),
        BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Penghuni'),
        BottomNavigationBarItem(icon: Icon(Icons.payment_rounded), label: 'Bayar'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    );
  }
}

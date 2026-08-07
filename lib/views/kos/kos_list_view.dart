import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_bottom_nav.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_shimmer.dart';
import 'package:kosmo/components/kosmo_empty_state.dart';

class KosListView extends StatefulWidget {
  const KosListView({super.key});

  @override
  State<KosListView> createState() => _KosListViewState();
}

class _KosListViewState extends State<KosListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KosProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final kosProvider = context.watch<KosProvider>();
    final query = _searchController.text.toLowerCase();
    
    final filteredList = kosProvider.kosList.where((kos) {
      return kos.name.toLowerCase().contains(query) ||
             kos.address.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Daftar Kos'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: KosmoTextField(
              controller: _searchController,
              label: 'Cari Nama Kos atau Alamat...',
              prefixIcon: Icons.search_rounded,
              validator: null,
            ),
          ),
          Expanded(
            child: _buildContent(kosProvider, filteredList),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.kosForm, arguments: null);
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

  Widget _buildContent(KosProvider kosProvider, List<KosModel> filteredList) {
    if (kosProvider.isLoading && kosProvider.kosList.isEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => const KosmoShimmer(height: 120, width: double.infinity),
      );
    }

    if (kosProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(kosProvider.error!, style: const TextStyle(color: KosmoTheme.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<KosProvider>().loadAll(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (filteredList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<KosProvider>().loadAll(),
        color: KosmoTheme.primary,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: KosmoEmptyState(
              icon: Icons.home_work_outlined,
              title: 'Tidak Ada Kos',
              subtitle: 'Data kos tidak ditemukan. Silakan tambahkan kos baru.',
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<KosProvider>().loadAll(),
      color: KosmoTheme.primary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final kos = filteredList[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.kosDetail, arguments: kos);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                          kos.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kos.address,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: KosmoTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${kos.totalRooms} Kamar',
                          style: const TextStyle(
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
    );
  }
}

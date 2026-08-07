import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_empty_state.dart';
import 'package:kosmo/services/whatsapp_service.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/providers/tenant_provider.dart';

class TenantListView extends StatefulWidget {
  final String kosId;

  const TenantListView({super.key, required this.kosId});

  @override
  State<TenantListView> createState() => _TenantListViewState();
}

class _TenantListViewState extends State<TenantListView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TenantProvider>().loadByKosId(widget.kosId);
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await context.read<TenantProvider>().loadByKosId(widget.kosId);
  }

  @override
  Widget build(BuildContext context) {
    final tenantProvider = context.watch<TenantProvider>();
    final tenants = tenantProvider.tenantList.where((tenant) {
      final nameMatches = tenant.name.toLowerCase().contains(_searchQuery);
      final phoneMatches = tenant.phone.toLowerCase().contains(_searchQuery);
      return nameMatches || phoneMatches;
    }).toList();

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Daftar Penghuni'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: KosmoTextField(
              controller: _searchController,
              label: 'Cari Nama Penghuni / Nomor HP...',
              prefixIcon: Icons.search_rounded,
            ),
          ),
          Expanded(
            child: _buildContent(tenantProvider, tenants),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.tenantForm, arguments: {'kosId': widget.kosId, 'tenant': null});
        },
        backgroundColor: KosmoTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(TenantProvider provider, List<TenantModel> tenants) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: KosmoTheme.primary));
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: KosmoTheme.error),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Poppins', color: KosmoTheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadByKosId(widget.kosId),
              style: ElevatedButton.styleFrom(backgroundColor: KosmoTheme.primary),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        ),
      );
    }

    if (tenants.isEmpty) {
      return const KosmoEmptyState(
        icon: Icons.person_off_outlined,
        title: 'Belum ada penghuni',
        subtitle: 'Tambahkan penghuni baru menggunakan tombol + di bawah',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: KosmoTheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          final isArrears = tenant.status.toLowerCase() == 'overdue';
          final statusColor = isArrears ? KosmoTheme.error : (tenant.status.toLowerCase() == 'active' ? KosmoTheme.primary : KosmoTheme.textSecondary);
          final statusBgColor = isArrears ? KosmoTheme.error.withValues(alpha: 0.1) : (tenant.status.toLowerCase() == 'active' ? KosmoTheme.primary.withValues(alpha: 0.1) : KosmoTheme.textSecondary.withValues(alpha: 0.1));

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.tenantDetail, arguments: tenant);
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: KosmoTheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        tenant.name.isNotEmpty ? tenant.name[0].toUpperCase() : 'P',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: KosmoTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tenant.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kamar ${tenant.roomId} • ${tenant.phone}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: KosmoTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tenant.status.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => WhatsappService.sendReminder(
                            phone: tenant.phone,
                            tenantName: tenant.name,
                            month: '',
                            amount: '',
                          ),
                          icon: const Icon(Icons.message_rounded, color: KosmoTheme.success, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

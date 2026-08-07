import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/services/whatsapp_service.dart';

class TenantListView extends StatefulWidget {
  const TenantListView({super.key});

  @override
  State<TenantListView> createState() => _TenantListViewState();
}

class _TenantListViewState extends State<TenantListView> {
  final _searchController = TextEditingController();

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
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
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: KosmoTheme.primary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final isArrears = index % 3 == 0;
                  final tenantName = 'Penghuni ${index + 1}';
                  final phone = '08123456789$index';

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.tenantDetail);
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
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
                                'P${index + 1}',
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
                                    tenantName,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kamar ${101 + index} • $phone',
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
                                    color: isArrears ? KosmoTheme.errorContainer : KosmoTheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isArrears ? 'Nunggak' : 'Aktif',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isArrears ? KosmoTheme.error : KosmoTheme.primary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => WhatsappService.sendReminder(
                                    phone: phone,
                                    tenantName: tenantName,
                                    month: 'Agustus 2026',
                                    amount: '1.500.000',
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.tenantForm);
        },
        backgroundColor: KosmoTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

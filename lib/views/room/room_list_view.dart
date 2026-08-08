import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_shimmer.dart';
import 'package:kosmo/components/kosmo_empty_state.dart';
import 'package:kosmo/providers/room_provider.dart';

class RoomListView extends StatefulWidget {
  final String kosId;
  const RoomListView({super.key, required this.kosId});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomProvider>().loadByKosId(widget.kosId);
    });
  }

  Future<void> _refreshData() async {
    await context.read<RoomProvider>().loadByKosId(widget.kosId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoomProvider>();

    return Scaffold(
      appBar: const KosmoAppBar(title: 'Manajemen Kamar'),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tersedia', 'available'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Terisi', 'occupied'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Maintenance', 'maintenance'),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: KosmoTheme.primary,
              child: _buildBody(provider),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.roomForm,
            arguments: {'kosId': widget.kosId, 'room': null},
          );
        },
        backgroundColor: KosmoTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(RoomProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: KosmoShimmer(height: 100, width: double.infinity),
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Gagal memuat data kamar',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: KosmoTheme.error,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _refreshData,
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      );
    }

    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final filteredList = provider.roomList.where((room) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Tersedia' && room.status == 'available') {
        return true;
      }
      if (_selectedFilter == 'Terisi' && room.status == 'occupied') {
        return true;
      }
      if (_selectedFilter == 'Maintenance' && room.status == 'maintenance') {
        return true;
      }
      return false;
    }).toList();

    if (filteredList.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 60),
          KosmoEmptyState(
            icon: Icons.meeting_room_outlined,
            title: 'Belum Ada Kamar',
            subtitle: 'Kamar yang sesuai filter tidak ditemukan.',
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final room = filteredList[index];

        String statusLabel = 'Tersedia';
        Color statusColor = KosmoTheme.primary;
        Color statusBgColor = KosmoTheme.primary.withValues(alpha: 0.1);

        if (room.status == 'occupied') {
          statusLabel = 'Terisi';
          statusColor = KosmoTheme.error;
          statusBgColor = KosmoTheme.error.withValues(alpha: 0.1);
        } else if (room.status == 'maintenance') {
          statusLabel = 'Maintenance';
          statusColor = KosmoTheme.warning;
          statusBgColor = KosmoTheme.warning.withValues(alpha: 0.1);
        }

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.roomDetail, arguments: room);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE8ECE9),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/room_interior.jpg',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: KosmoTheme.primary.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.meeting_room,
                        color: KosmoTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kamar ${room.roomNumber}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
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
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${room.floor != null ? "Lantai ${room.floor} • " : ""}${formatCurrency.format(room.price)} / bln',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary,
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
    );
  }

  Widget _buildFilterChip(String label, [String? statusValue]) {
    final isSelected = _selectedFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryAccent : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryAccent
                : (isDark ? const Color(0xFF333333) : const Color(0xFFE1E3E4)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? KosmoTheme.darkTextSecondary : KosmoTheme.textSecondary),
          ),
        ),
      ),
    );
  }
}

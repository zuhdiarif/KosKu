import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/models/room_model.dart';
import 'package:kosmo/providers/room_provider.dart';

class RoomFormView extends StatefulWidget {
  final String kosId;
  final RoomModel? room;
  const RoomFormView({super.key, required this.kosId, this.room});

  @override
  State<RoomFormView> createState() => _RoomFormViewState();
}

class _RoomFormViewState extends State<RoomFormView> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _priceController = TextEditingController();
  final _facilitiesController = TextEditingController();
  String _selectedStatus = 'available';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _roomNumberController.text = widget.room!.roomNumber;
      _floorController.text = widget.room!.floor?.toString() ?? '';
      _priceController.text = widget.room!.price.toInt().toString();
      _selectedStatus = widget.room!.status;
      if (widget.room!.facilities != null) {
        _facilitiesController.text = widget.room!.facilities!.entries
            .map((e) => e.value)
            .join(', ');
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final facilitiesList = _facilitiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final facilitiesMap = {
      for (var i = 0; i < facilitiesList.length; i++)
        'item_$i': facilitiesList[i],
    };

    final newRoom = RoomModel(
      id: widget.room?.id ?? '',
      kosId: widget.kosId,
      roomNumber: _roomNumberController.text,
      floor: int.tryParse(_floorController.text),
      price: double.tryParse(_priceController.text) ?? 0,
      status: _selectedStatus,
      facilities: facilitiesMap.isEmpty ? null : facilitiesMap,
      createdAt: widget.room?.createdAt ?? DateTime.now(),
    );

    final provider = context.read<RoomProvider>();
    bool success;

    if (widget.room == null) {
      success = await provider.create(newRoom);
    } else {
      success = await provider.update(newRoom);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
      } else {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal',
          message:
              provider.error ?? 'Terjadi kesalahan saat menyimpan data kamar',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KosmoAppBar(
        title: widget.room == null ? 'Tambah Kamar' : 'Edit Kamar',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KosmoTextField(
                controller: _roomNumberController,
                label: 'Nomor Kamar (Contoh: 101)',
                prefixIcon: Icons.meeting_room_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nomor kamar wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _floorController,
                label: 'Posisi Lantai (Contoh: 1)',
                prefixIcon: Icons.layers_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Posisi lantai wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _priceController,
                label: 'Harga Sewa per Bulan (Rp)',
                prefixIcon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Harga sewa wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status Kamar',
                  prefixIcon: const Icon(Icons.info_outline_rounded),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'available',
                    child: Text(
                      'Tersedia',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'occupied',
                    child: Text(
                      'Terisi',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'maintenance',
                    child: Text(
                      'Maintenance',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _facilitiesController,
                label: 'Fasilitas Kamar (Pisahkan dengan koma)',
                prefixIcon: Icons.king_bed_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : KosmoButton(label: 'Simpan Data Kamar', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

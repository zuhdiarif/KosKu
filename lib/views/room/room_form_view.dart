import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';

class RoomFormView extends StatefulWidget {
  const RoomFormView({super.key});

  @override
  State<RoomFormView> createState() => _RoomFormViewState();
}

class _RoomFormViewState extends State<RoomFormView> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _priceController = TextEditingController();
  final _facilitiesController = TextEditingController();
  String _selectedStatus = 'Tersedia';

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data kamar berhasil disimpan.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: const KosmoAppBar(title: 'Formulir Kamar'),
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
                  if (val == null || val.trim().isEmpty) return 'Nomor kamar wajib diisi';
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
                  if (val == null || val.trim().isEmpty) return 'Posisi lantai wajib diisi';
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
                  if (val == null || val.trim().isEmpty) return 'Harga sewa wajib diisi';
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Tersedia', child: Text('Tersedia', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'Terisi', child: Text('Terisi', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance', style: TextStyle(fontFamily: 'Poppins'))),
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
                label: 'Fasilitas Kamar (AC, Kasur, WiFi, dll)',
                prefixIcon: Icons.king_bed_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              KosmoButton(
                label: 'Simpan Data Kamar',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';

class KosFormView extends StatefulWidget {
  const KosFormView({super.key});

  @override
  State<KosFormView> createState() => _KosFormViewState();
}

class _KosFormViewState extends State<KosFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _roomsController = TextEditingController();

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data kos berhasil disimpan.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: const KosmoAppBar(title: 'Formulir Kosmo'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  color: KosmoTheme.primary.withValues(alpha: 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo_outlined, size: 40, color: KosmoTheme.primary),
                      SizedBox(height: 8),
                      Text(
                        'Upload Foto Kosmo',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: KosmoTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              KosmoTextField(
                controller: _nameController,
                label: 'Nama Kos',
                prefixIcon: Icons.apartment_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama kos wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _addressController,
                label: 'Alamat Lengkap',
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Alamat wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _descController,
                label: 'Deskripsi & Fasilitas Umum',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _roomsController,
                label: 'Total Kamar',
                prefixIcon: Icons.meeting_room_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Jumlah kamar wajib diisi';
                  if (int.tryParse(val.trim()) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              KosmoButton(
                label: 'Simpan Data Kos',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

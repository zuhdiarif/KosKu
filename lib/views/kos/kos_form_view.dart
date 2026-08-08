import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';

class KosFormView extends StatefulWidget {
  final KosModel? kos;
  
  const KosFormView({super.key, this.kos});

  @override
  State<KosFormView> createState() => _KosFormViewState();
}

class _KosFormViewState extends State<KosFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _descController;
  late final TextEditingController _roomsController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.kos?.name ?? '');
    _addressController = TextEditingController(text: widget.kos?.address ?? '');
    _descController = TextEditingController(text: widget.kos?.description ?? '');
    _roomsController = TextEditingController(text: widget.kos?.totalRooms.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final authProvider = context.read<AuthProvider>();
    final kosProvider = context.read<KosProvider>();

    final isEditing = widget.kos != null;

    final kosModel = KosModel(
      id: widget.kos?.id ?? '',
      ownerId: widget.kos?.ownerId ?? authProvider.user?.id ?? '',
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descController.text.trim(),
      totalRooms: int.parse(_roomsController.text.trim()),
      createdAt: widget.kos?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (isEditing) {
      success = await kosProvider.update(kosModel);
    } else {
      success = await kosProvider.create(kosModel);
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kos berhasil disimpan.')),
        );
        Navigator.pop(context);
      } else {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal Menyimpan',
          message: kosProvider.error ?? 'Terjadi kesalahan yang tidak diketahui.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? KosmoTheme.onPrimaryContainer : KosmoTheme.primary;

    return Scaffold(
      appBar: KosmoAppBar(title: widget.kos == null ? 'Tambah Kos' : 'Edit Kos'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: KosmoTheme.primary.withValues(alpha: 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 36, color: primaryAccent),
                      const SizedBox(height: 8),
                      Text(
                        'Upload Foto Kosmo',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: primaryAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  children: [
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
                    const SizedBox(height: 24),
                    _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : KosmoButton(
                            label: 'Simpan Data Kos',
                            onPressed: _save,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

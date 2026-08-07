import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/providers/tenant_provider.dart';

class TenantFormView extends StatefulWidget {
  final String kosId;
  final TenantModel? tenant;

  const TenantFormView({super.key, required this.kosId, this.tenant});

  @override
  State<TenantFormView> createState() => _TenantFormViewState();
}

class _TenantFormViewState extends State<TenantFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _ktpController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _startDateController = TextEditingController();
  String _selectedStatus = 'active';
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    if (widget.tenant != null) {
      _nameController.text = widget.tenant!.name;
      _roomIdController.text = widget.tenant!.roomId;
      _ktpController.text = widget.tenant!.idCardNumber ?? '';
      _phoneController.text = widget.tenant!.phone;
      _emailController.text = widget.tenant!.email ?? '';
      _startDate = widget.tenant!.startDate;
      _startDateController.text = DateFormat('d MMM yyyy').format(_startDate!);
      _selectedStatus = widget.tenant!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomIdController.dispose();
    _ktpController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: KosmoTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('d MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      KosmoDialog.showError(
        context: context,
        title: 'Validasi Gagal',
        message: 'Tanggal masuk sewa wajib diisi',
      );
      return;
    }

    final provider = context.read<TenantProvider>();
    
    final newTenant = TenantModel(
      id: widget.tenant?.id ?? '',
      roomId: _roomIdController.text.trim(),
      kosId: widget.kosId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      idCardNumber: _ktpController.text.trim().isEmpty ? null : _ktpController.text.trim(),
      startDate: _startDate!,
      endDate: widget.tenant?.endDate,
      status: _selectedStatus,
      createdAt: widget.tenant?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.tenant == null) {
      success = await provider.create(newTenant);
    } else {
      success = await provider.update(newTenant);
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.tenant == null ? 'Data penghuni berhasil ditambahkan.' : 'Data penghuni berhasil diubah.')),
        );
        Navigator.pop(context);
      } else {
        KosmoDialog.showError(
          context: context,
          title: 'Gagal Menyimpan',
          message: provider.error ?? 'Terjadi kesalahan saat menyimpan data penghuni.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TenantProvider>().isLoading;

    return Scaffold(
      appBar: KosmoAppBar(title: widget.tenant == null ? 'Tambah Penghuni' : 'Edit Penghuni'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KosmoTextField(
                controller: _nameController,
                label: 'Nama Lengkap Penghuni',
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama penghuni wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _roomIdController,
                label: 'ID Kamar',
                prefixIcon: Icons.door_front_door_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Kamar wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _ktpController,
                label: 'Nomor KTP (Opsional)',
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _phoneController,
                label: 'Nomor WhatsApp (Contoh: 081234567890)',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nomor WhatsApp wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _emailController,
                label: 'Alamat Email (Opsional)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: KosmoTextField(
                    controller: _startDateController,
                    label: 'Tanggal Masuk Sewa',
                    prefixIcon: Icons.calendar_today_outlined,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Tanggal masuk sewa wajib diisi';
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status Keanggotaan',
                  prefixIcon: const Icon(Icons.info_outline_rounded),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Aktif', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'overdue', child: Text('Nunggak', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'inactive', child: Text('Nonaktif', style: TextStyle(fontFamily: 'Poppins'))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const Center(child: CircularProgressIndicator(color: KosmoTheme.primary))
                  : KosmoButton(
                      label: widget.tenant == null ? 'Tambah Penghuni' : 'Simpan Perubahan',
                      onPressed: _save,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

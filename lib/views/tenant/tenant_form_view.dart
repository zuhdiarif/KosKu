import 'package:flutter/material.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';

class TenantFormView extends StatefulWidget {
  const TenantFormView({super.key});

  @override
  State<TenantFormView> createState() => _TenantFormViewState();
}

class _TenantFormViewState extends State<TenantFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ktpController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _startDateController = TextEditingController();
  String _selectedStatus = 'Aktif';

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data penghuni berhasil disimpan.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KosmoTheme.background,
      appBar: const KosmoAppBar(title: 'Formulir Penghuni'),
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
                controller: _ktpController,
                label: 'Nomor KTP (16 Digit)',
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nomor KTP wajib diisi';
                  return null;
                },
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
                label: 'Alamat Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _startDateController,
                label: 'Tanggal Masuk Sewa',
                prefixIcon: Icons.calendar_today_outlined,
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
                  DropdownMenuItem(value: 'Aktif', child: Text('Aktif', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'Nunggak', child: Text('Nunggak', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif', style: TextStyle(fontFamily: 'Poppins'))),
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
              KosmoButton(
                label: 'Simpan Data Penghuni',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

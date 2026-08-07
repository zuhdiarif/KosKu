import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/components/kosmo_app_bar.dart';
import 'package:kosmo/components/kosmo_text_field.dart';
import 'package:kosmo/components/kosmo_button.dart';
import 'package:kosmo/components/kosmo_dialog.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:kosmo/providers/payment_provider.dart';

class PaymentFormView extends StatefulWidget {
  final PaymentModel? payment;
  const PaymentFormView({super.key, this.payment});

  @override
  State<PaymentFormView> createState() => _PaymentFormViewState();
}

class _PaymentFormViewState extends State<PaymentFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _tenantIdController = TextEditingController();
  final _roomIdController = TextEditingController();
  DateTime? _selectedDate;
  String _status = 'pending';
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      _amountController.text = widget.payment!.amount.toString();
      _notesController.text = widget.payment!.notes ?? '';
      _tenantIdController.text = widget.payment!.tenantId;
      _roomIdController.text = widget.payment!.roomId;
      _selectedDate = widget.payment!.dueDate;
      _status = widget.payment!.status;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _tenantIdController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      KosmoDialog.showError(context: context, title: 'Error', message: 'Tanggal jatuh tempo harus dipilih');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final paymentProvider = context.read<PaymentProvider>();
    final isEdit = widget.payment != null;
    
    final newPayment = PaymentModel(
      id: isEdit ? widget.payment!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      tenantId: _tenantIdController.text,
      roomId: _roomIdController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      dueDate: _selectedDate!,
      status: _status,
      notes: _notesController.text,
      createdAt: isEdit ? widget.payment!.createdAt : DateTime.now(),
      paymentDate: _status == 'paid' ? DateTime.now() : null,
      proofUrl: _imageFile?.path, // Simplified for this example
    );

    bool success = false;
    if (isEdit) {
      success = await paymentProvider.update(newPayment);
    } else {
      success = await paymentProvider.create(newPayment);
    }

    setState(() {
      _isSaving = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan pembayaran berhasil disimpan.')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        KosmoDialog.showError(context: context, title: 'Gagal Menyimpan', message: paymentProvider.error ?? 'Terjadi kesalahan');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KosmoAppBar(title: widget.payment == null ? 'Form Pembayaran' : 'Edit Pembayaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KosmoTextField(
                controller: _tenantIdController,
                label: 'ID Penghuni',
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Pilih penghuni / kamar';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _roomIdController,
                label: 'ID Kamar',
                prefixIcon: Icons.door_front_door_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'ID Kamar wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _amountController,
                label: 'Jumlah Pembayaran (Rp)',
                prefixIcon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Jumlah pembayaran wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal Jatuh Tempo',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _selectedDate == null ? 'Pilih Tanggal' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: 'Status Pembayaran',
                  prefixIcon: const Icon(Icons.info_outline_rounded),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending (Belum Lunas)', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'paid', child: Text('Lunas', style: TextStyle(fontFamily: 'Poppins'))),
                  DropdownMenuItem(value: 'overdue', child: Text('Terlambat / Nunggak', style: TextStyle(fontFamily: 'Poppins'))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              KosmoTextField(
                controller: _notesController,
                label: 'Catatan / Keterangan',
                prefixIcon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                'Unggah Bukti Transfer / Resi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: KosmoTheme.primary, size: 36),
                              SizedBox(height: 8),
                              Text(
                                'Klik untuk Unggah Foto Bukti Bayar',
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: KosmoTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 28),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : KosmoButton(
                      label: widget.payment == null ? 'Simpan Pembayaran' : 'Update Pembayaran',
                      onPressed: _save,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

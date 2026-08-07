import 'package:flutter/material.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:kosmo/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _service = PaymentService();
  List<PaymentModel> _paymentList = [];
  List<PaymentModel> _overdueList = [];
  bool _isLoading = false;
  String? _error;

  List<PaymentModel> get paymentList => _paymentList;
  List<PaymentModel> get overdueList => _overdueList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _paymentList = await _service.getAll();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadByTenantId(String tenantId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _paymentList = await _service.getByTenantId(tenantId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOverdue() async {
    _isLoading = true;
    notifyListeners();
    try {
      _overdueList = await _service.getOverdue();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(PaymentModel payment) async {
    try {
      await _service.create(payment);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(PaymentModel payment) async {
    try {
      await _service.update(payment);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _service.delete(id);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/services/tenant_service.dart';

class TenantProvider extends ChangeNotifier {
  final TenantService _service = TenantService();
  List<TenantModel> _tenantList = [];
  bool _isLoading = false;
  String? _error;

  List<TenantModel> get tenantList => _tenantList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByKosId(String kosId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _tenantList = await _service.getByKosId(kosId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(TenantModel tenant) async {
    try {
      await _service.create(tenant);
      await loadByKosId(tenant.kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(TenantModel tenant) async {
    try {
      await _service.update(tenant);
      await loadByKosId(tenant.kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id, String kosId) async {
    try {
      await _service.delete(id);
      await loadByKosId(kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

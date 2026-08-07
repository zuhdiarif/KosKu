import 'package:flutter/material.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/services/kos_service.dart';

class KosProvider extends ChangeNotifier {
  final KosService _service = KosService();
  List<KosModel> _kosList = [];
  bool _isLoading = false;
  String? _error;

  List<KosModel> get kosList => _kosList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _kosList = await _service.getAll();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(KosModel kos) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.create(kos);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(KosModel kos) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.update(kos);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.delete(id);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

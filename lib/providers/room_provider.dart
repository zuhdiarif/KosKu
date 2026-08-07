import 'package:flutter/material.dart';
import 'package:kosmo/models/room_model.dart';
import 'package:kosmo/services/room_service.dart';

class RoomProvider extends ChangeNotifier {
  final RoomService _service = RoomService();
  List<RoomModel> _roomList = [];
  bool _isLoading = false;
  String? _error;

  List<RoomModel> get roomList => _roomList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByKosId(String kosId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _roomList = await _service.getByKosId(kosId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(RoomModel room) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.create(room);
      await loadByKosId(room.kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(RoomModel room) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.update(room);
      await loadByKosId(room.kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id, String kosId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.delete(id);
      await loadByKosId(kosId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

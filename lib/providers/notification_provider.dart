import 'package:flutter/material.dart';
import 'package:kosmo/models/notification_model.dart';
import 'package:kosmo/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<NotificationModel> _notificationList = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notificationList => _notificationList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByOwnerId(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notificationList = await _service.getByOwnerId(ownerId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(NotificationModel notification) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.create(notification);
      await loadByOwnerId(notification.ownerId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAsSent(String id, String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.markAsSent(id);
      await loadByOwnerId(ownerId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/user_model.dart';
import 'package:kosmo/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _authService.currentUser != null;

  String _parseError(dynamic e) {
    final str = e.toString();
    if (e is AuthException) {
      if (str.contains('User already registered') || str.contains('already exists')) {
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau login.';
      }
      if (str.contains('Invalid login credentials')) {
        return 'Email atau password salah. Silakan periksa kembali.';
      }
      return e.message;
    }
    if (str.contains('AuthRetryableFetchException') || str.contains('SocketException') || str.contains('ClientException')) {
      return 'Gagal terhubung ke server Supabase. Pastikan koneksi internet aktif dan coba lagi.';
    }
    return str;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.login(email, password);
      _user = await _authService.getUserProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.register(email, password, fullName);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.verifyOtp(email, token);
      _user = await _authService.getUserProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

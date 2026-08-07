import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/user_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> register(String email, String password, String fullName) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<AuthResponse> verifyOtp(String email, String token) async {
    try {
      return await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
    } catch (_) {
      return await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
    }
  }

  Future<void> resendOtp(String email) async {
    await _client.auth.resend(
      email: email,
      type: OtpType.signup,
    );
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<UserModel?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;
    final data = await _client.from('users').select().eq('id', user.id).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }
}

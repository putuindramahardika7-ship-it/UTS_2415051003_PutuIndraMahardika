import 'package:flutter/material.dart';

class AuthUser {
  final String name;
  final String email;
  final String photoUrl;

  AuthUser({
    required this.name,
    required this.email,
    required this.photoUrl,
  });
}

class AuthProvider extends ChangeNotifier {
  AuthUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // Validasi khusus domain Undiksha
  bool isValidUndikshaDomain(String email) {
    return email.trim().toLowerCase().endsWith('@undiksha.ac.id');
  }

  // Simulasi/Proses Sign In Google dengan Validasi Domain Undiksha
  Future<bool> signInWithGoogle(String emailInput, String nameInput) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!isValidUndikshaDomain(emailInput)) {
      _errorMessage = 'Akses Ditolak! Anda harus menggunakan akun email resmi Undiksha (@undiksha.ac.id).';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = AuthUser(
      name: nameInput.isEmpty ? 'Mahasiswa Undiksha' : nameInput,
      email: emailInput.trim().toLowerCase(),
      photoUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=${emailInput.trim()}',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
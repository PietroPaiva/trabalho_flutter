import 'dart:convert';

import 'package:auroria/models/app_user.dart';
import 'package:auroria/services/task_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  AuthService(this._tasks);

  final TaskService _tasks;
  AppUser? _current;

  AppUser? get current => _current;
  bool get isLogged => _current != null;

  Future<List<AppUser>> _readUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('users');
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => AppUser.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(List<AppUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((user) => user.toMap()).toList());
    await prefs.setString('users', encoded);
  }

  String _hash(String email, String password) {
    return sha256.convert(utf8.encode('$email:$password')).toString();
  }

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('session_email');
    if (email == null) return;
    final users = await _readUsers();
    final matches = users.where((user) => user.email == email);
    if (matches.isEmpty) return;
    await _tasks.load(email);
    _current = matches.first;
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final users = await _readUsers();
    if (users.any((user) => user.email == normalized)) {
      return 'Este e-mail já está cadastrado';
    }
    users.add(
      AppUser(
        name: name.trim(),
        email: normalized,
        passwordHash: _hash(normalized, password),
      ),
    );
    await _writeUsers(users);
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final hash = _hash(normalized, password);
    final users = await _readUsers();
    final matches = users.where(
      (user) => user.email == normalized && user.passwordHash == hash,
    );
    if (matches.isEmpty) return 'E-mail ou senha incorretos';
    final user = matches.first;
    await _tasks.load(user.email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_email', user.email);
    _current = user;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_email');
    _tasks.clear();
    _current = null;
    notifyListeners();
  }
}
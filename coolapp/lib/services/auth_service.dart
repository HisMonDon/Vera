import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Your Firebase Web API key
  final String apiKey = 'AIzaSyBdq8QD00AVwIgVCP66RfUq_0X14mU5HlE';

  // URLs for Firebase Authentication API
  final String _signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
  final String _signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp';

  // Token storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _expiryTimeKey = 'expiry_time';

  // Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_signInUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveAuthData(data, email);
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  // Register new user
  Future<bool> registerWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_signUpUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveAuthData(data, email);
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Save authentication data to SharedPreferences
  Future<void> _saveAuthData(Map<String, dynamic> data, String email) async {
    final prefs = await SharedPreferences.getInstance();

    final token = data['idToken'];
    final expiresIn = int.parse(data['expiresIn']);
    final expiryTime = DateTime.now()
        .add(Duration(seconds: expiresIn))
        .toIso8601String();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_expiryTimeKey, expiryTime);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryTimeString = prefs.getString(_expiryTimeKey);

    if (token == null || expiryTimeString == null) {
      return false;
    }

    final expiryTime = DateTime.parse(expiryTimeString);
    return expiryTime.isAfter(DateTime.now());
  }

  // Get current user email
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Log out user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_expiryTimeKey);
  }
}

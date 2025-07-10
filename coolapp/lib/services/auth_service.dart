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
      print('AuthService: Attempting to sign in with email: $email');
      final response = await http.post(
        Uri.parse('$_signInUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      print('AuthService: Sign in response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('AuthService: Sign in successful, saving auth data...');
        await _saveAuthData(data, email);
        print('AuthService: Auth data saved successfully');

        // Verify the data was saved correctly
        final isLoggedIn = await this.isLoggedIn();
        print('AuthService: Verification - isLoggedIn after save: $isLoggedIn');

        return true;
      } else {
        final error = json.decode(response.body);
        print(
          'AuthService: Sign in failed with error: ${error['error']['message']}',
        );
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      print('AuthService: Sign in error: $e');
      return false;
    }
  }

  // Register new user
  Future<bool> registerWithEmail(String email, String password) async {
    try {
      print('AuthService: Attempting to register with email: $email');
      final response = await http.post(
        Uri.parse('$_signUpUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      print('AuthService: Register response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('AuthService: Registration successful, saving auth data...');
        await _saveAuthData(data, email);
        print('AuthService: Auth data saved successfully');

        // Verify the data was saved correctly
        final isLoggedIn = await this.isLoggedIn();
        print('AuthService: Verification - isLoggedIn after save: $isLoggedIn');

        return true;
      } else {
        final error = json.decode(response.body);
        print(
          'AuthService: Registration failed with error: ${error['error']['message']}',
        );
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      print('AuthService: Registration error: $e');
      return false;
    }
  }

  // Save authentication data to SharedPreferences
  Future<void> _saveAuthData(Map<String, dynamic> data, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = data['idToken'];
      final expiresIn = int.parse(data['expiresIn']);
      final expiryTime = DateTime.now()
          .add(Duration(seconds: expiresIn))
          .toIso8601String();

      print('AuthService: Saving token: ${token?.substring(0, 20)}...');
      print('AuthService: Saving email: $email');
      print('AuthService: Saving expiry time: $expiryTime');

      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_expiryTimeKey, expiryTime);

      print('AuthService: Data saved to SharedPreferences');
    } catch (e) {
      print('AuthService: Error saving auth data: $e');
      rethrow;
    }
  }

  // isLoggedIn
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final expiryTimeString = prefs.getString(_expiryTimeKey);

      print('AuthService: Checking login status...');
      print('AuthService: Token exists: ${token != null}');
      print('AuthService: Expiry time string: $expiryTimeString');

      if (token == null || expiryTimeString == null) {
        print('AuthService: User not logged in - missing token or expiry time');
        return false;
      }

      final expiryTime = DateTime.parse(expiryTimeString);
      final now = DateTime.now();
      final isValid = expiryTime.isAfter(now);

      print('AuthService: Expiry time: $expiryTime');
      print('AuthService: Current time: $now');
      print('AuthService: Token is valid: $isValid');

      return isValid;
    } catch (e) {
      print('AuthService: Error checking login status: $e');
      return false;
    }
  }

  // Get current user email
  Future<String?> getCurrentUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_userEmailKey);
      print('AuthService: Retrieved email: $email');
      return email;
    } catch (e) {
      print('AuthService: Error getting current user email: $e');
      return null;
    }
  }

  // Log out
  Future<void> signOut() async {
    try {
      print('AuthService: Signing out user...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_expiryTimeKey);
      print('AuthService: User signed out successfully');
    } catch (e) {
      print('AuthService: Error signing out: $e');
      rethrow;
    }
  }
}

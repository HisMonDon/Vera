import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coolapp/globals.dart' as globals;

class AuthService {
  final String apiKey = 'AIzaSyBdq8QD00AVwIgVCP66RfUq_0X14mU5HlE';
  final String _signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
  final String _signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp';

  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _expiryTimeKey = 'expiry_time';

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<String?> getSavedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  //var pastVideos = List<String>.filled(5, '');
  Future<List<String>?> getPastVideos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('past_videos_list');
  }

  Future<void> savePastVideos(List<String> videos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('past_videos_list', videos);
  }

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
        final name = await getUserNameFromFirestore(
          data['localId'],
          data['idToken'],
        );
        if (name != null) {
          globals.userName = name;
          await saveUserName(name);
        }
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    final _currentPasswordController = TextEditingController();
    try {
      final idToken = globals.idToken;
      if (idToken.isEmpty) return false;

      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idToken': idToken,
          'password': newPassword,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Update the stored token with the new one
        await _saveAuthData(data, await getCurrentUserEmail() ?? '');
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      print("Password change error: $e");
      return false;
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String name,
    List<String> pastVideos,
  ) async {
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
        await saveUserNameToFirestore(data['localId'], name, data['idToken']);
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error']['message']);
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = data['idToken'];
    final expiresIn = int.parse(data['expiresIn']);
    final expiryTime = DateTime.now()
        .add(Duration(seconds: expiresIn))
        .toIso8601String();
    final localId = data['localId'];

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_expiryTimeKey, expiryTime);
    await prefs.setString('userId', localId);
    globals.userId = localId;
    globals.idToken = token;
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final expiryTimeString = prefs.getString(_expiryTimeKey);

      if (token == null || expiryTimeString == null) return false;

      final expiryTime = DateTime.parse(expiryTimeString);
      final now = DateTime.now();
      return expiryTime.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  Future<String?> getCurrentUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_expiryTimeKey);
  }

  Future<void> saveUserNameToFirestore(
    String uid,
    String name,
    String idToken,
  ) async {
    if (uid.isEmpty || idToken.isEmpty) return;
    final url =
        'https://firestore.googleapis.com/v1/projects/vera-a4111/databases/(default)/documents/users/$uid';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': name},
        },
      }),
    );

    if (response.statusCode == 200) {
      globals.userName = name;
      await saveUserName(name);
    }
  }

  Future<String?> getUserNameFromFirestore(String uid, String idToken) async {
    final url =
        'https://firestore.googleapis.com/v1/projects/vera-a4111/databases/(default)/documents/users/$uid';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['fields']['name']['stringValue'];
    }
    return null;
  }
}

Future<void> savePastVideos(List<String> videos) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('past_videos_list', videos);
}

Future<void> savePastVideosToFirestore(
  String uid,
  List<String> pastVideos,
  String idToken,
) async {
  if (uid.isEmpty || idToken.isEmpty) return;

  final url =
      'https://firestore.googleapis.com/v1/projects/vera-a4111/databases/(default)/documents/users/$uid';

  final videoValues = pastVideos
      .map((video) => {'stringValue': video})
      .toList();

  final response = await http.patch(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'fields': {
        'pastVideos': {
          'arrayValue': {'values': videoValues},
        },
      },
    }),
  );

  if (response.statusCode == 200) {
    globals.pastVideos = pastVideos;
    await savePastVideosLocally(pastVideos);
  }
}

Future<List<String>> getPastVideosFromFirestore(
  String uid,
  String idToken,
) async {
  final url =
      'https://firestore.googleapis.com/v1/projects/vera-a4111/databases/(default)/documents/users/$uid';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $idToken'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['fields']?['pastVideos']?['arrayValue']?['values'] != null) {
      final videoList = data['fields']['pastVideos']['arrayValue']['values']
          .map<String>((item) => item['stringValue'] as String)
          .toList();

      return videoList;
    }
  }

  return []; //in case somehting goes wrong return empty
}

Future<void> savePastVideosLocally(List<String> videos) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('past_videos', videos);
}

Future<List<String>> getPastVideosLocally() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('past_videos') ?? [];
}

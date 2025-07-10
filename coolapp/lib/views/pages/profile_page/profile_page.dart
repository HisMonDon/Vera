import 'package:flutter/material.dart';
import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isInitializing = true;
  bool _isLogin = true;
  bool isLoggedIn = false;
  String _userEmail = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        final email = await _authService.getCurrentUserEmail();
        setState(() {
          isLoggedIn = true;
          _userEmail = email ?? '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check login status';
      });
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success;
      if (_isLogin) {
        success = await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await _authService.registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (success) {
        _emailController.clear();
        _passwordController.clear();
        await _checkLoginStatus();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isLogin
                    ? 'Login successful!'
                    : 'Account created successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = _isLogin
              ? 'Login failed. Please check your credentials.'
              : 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      setState(() {
        isLoggedIn = false;
        _userEmail = '';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to log out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isLogin ? 'Login' : 'Create Account',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!_isValidEmail(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          const SizedBox(height: 16),

          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                    });
                  },
            child: Text(
              _isLogin ? 'Create new account' : 'I already have an account',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, size: 50, color: Colors.blue),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          _userEmail,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 30),
        OutlinedButton.icon(
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Logout'),
          onPressed: _signOut,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: _isInitializing
                ? const CircularProgressIndicator()
                : (isLoggedIn ? _buildProfileView() : _buildLoginForm()),
          ),
        ),
      ),
    );
  }
}

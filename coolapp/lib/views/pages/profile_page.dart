import 'package:flutter/material.dart';
import 'package:coolapp/services/auth_service.dart';

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
  bool _isLogin = true; // Toggle between login and register
  bool _isLoggedIn = false;
  String _userEmail = '';

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
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      final email = await _authService.getCurrentUserEmail();
      setState(() {
        _isLoggedIn = true;
        _userEmail = email ?? '';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    bool success;
    if (_isLogin) {
      success = await _authService.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await _authService.registerWithEmail(
        _emailController.text,
        _passwordController.text,
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      _emailController.clear();
      _passwordController.clear();
      _checkLoginStatus();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Authentication successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed. Please try again.')),
      );
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logged out successfully')));
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: TextStyle(fontSize: 16),
              ),
            ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
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
          child: Icon(Icons.person, size: 50, color: Colors.blue),
        ),
        SizedBox(height: 20),
        Text(
          'Welcome!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          _userEmail,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 30),
        OutlinedButton.icon(
          icon: Icon(Icons.exit_to_app),
          label: Text('Logout'),
          onPressed: _signOut,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: _isLoggedIn ? _buildProfileView() : _buildLoginForm(),
          ),
        ),
      ),
    );
  }
}

import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final List<TextEditingController> _videoControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
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
    _userNameController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _showChangePasswordDialog() async {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    String? _errorMessage;
    bool _isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: globals.isLight
                      ? Color.fromARGB(255, 7, 77, 53)
                      : Colors.white,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    TextFormField(
                      style: TextStyle(
                        color: globals.isLight
                            ? Color.fromARGB(255, 7, 77, 53)
                            : Colors.white,
                      ),
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    //then have space
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(
                        color: globals.isLight
                            ? Color.fromARGB(255, 7, 77, 53)
                            : Colors.white,
                      ),
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        fillColor: globals.isLight
                            ? Color.fromARGB(255, 7, 77, 53)
                            : Colors.white,
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(
                        color: globals.isLight
                            ? Color.fromARGB(255, 7, 77, 53)
                            : Colors.white,
                      ),
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          if (_currentPasswordController.text.isEmpty) {
                            setState(() {
                              _errorMessage =
                                  'Please enter your current password';
                            });
                            return;
                          }
                          if (_newPasswordController.text.isEmpty) {
                            setState(() {
                              _errorMessage = 'Please enter a new password';
                            });
                            return;
                          }

                          if (_newPasswordController.text.length < 6) {
                            setState(() {
                              _errorMessage =
                                  'Password must be at least 6 characters';
                            });
                            return;
                          }

                          if (_newPasswordController.text !=
                              _confirmPasswordController.text) {
                            setState(() {
                              _errorMessage = 'Passwords do not match';
                            });
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });

                          try {
                            final email =
                                await _authService.getCurrentUserEmail() ?? '';
                            if (email.isEmpty) {
                              setState(() {
                                _errorMessage =
                                    'User session error. Please log in again.';
                                _isLoading = false;
                              });
                              return;
                            }

                            final isCurrentPasswordValid = await _authService
                                .verifyCurrentPassword(
                                  email,
                                  _currentPasswordController.text,
                                );

                            if (!isCurrentPasswordValid) {
                              setState(() {
                                _errorMessage = 'Current password is incorrect';
                                _isLoading = false;
                              });
                              return;
                            }
                            final success = await _authService.changePassword(
                              _currentPasswordController.text,
                              _newPasswordController.text,
                            );

                            if (success) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Password changed successfully',
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    34,
                                    200,
                                    134,
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                _errorMessage =
                                    'Failed to change password. ' +
                                    globals.errorMessage;
                                _isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage =
                                  'An error occurred. Please try again.';
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text('Submit'),
                      ),
              ],
            );
          },
        );
      },
    );

    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        final email = await _authService.getCurrentUserEmail();
        final name = await _authService.getSavedUserName();
        final recentVideos = await _authService.getPastVideos();

        //initialize video controllers with recent videos
        for (int i = 0; i < _videoControllers.length; i++) {
          if (i < (recentVideos?.length ?? 0)) {
            _videoControllers[i].text = recentVideos![i];
          } else {
            _videoControllers[i].text = '';
          }
        }

        setState(() {
          isLoggedIn = true;
          _userEmail = email ?? '';
          globals.userName = name ?? '';
          globals.pastVideos = recentVideos ?? [];
        });
      }
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
    if (!_formKey.currentState!.validate()) return;

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
        //collect video URLs from controllers
        final videoUrls = _videoControllers
            .map((controller) => controller.text.trim())
            .where((url) => url.isNotEmpty)
            .toList();

        success = await _authService.registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _userNameController.text,
          videoUrls,
        );
      }

      if (success) {
        globals.isLoggedIn = true;
        _emailController.clear();
        _passwordController.clear();
        _userNameController.clear();
        for (var controller in _videoControllers) {
          controller.clear();
        }
        await _checkLoginStatus();

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isLogin
                    ? 'Login successful!'
                    : 'Account created successfully!',
              ),
              backgroundColor: const Color.fromARGB(255, 34, 200, 134),
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      setState(() {
        isLoggedIn = false;
        _userEmail = '';
      });
      globals.isLoggedIn = false;
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: globals.isLight
                  ? Color.fromARGB(255, 15, 48, 40)
                  : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 159, 159),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: const Color.fromARGB(255, 211, 42, 42),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            style: TextStyle(
              color: globals.isLight
                  ? Color.fromARGB(255, 0, 0, 0)
                  : Color.fromARGB(255, 255, 255, 255),
            ),
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',

              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Please enter your email';
              if (!_isValidEmail(value.trim()))
                return 'Please enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: TextStyle(
              color: globals.isLight
                  ? Color.fromARGB(255, 7, 77, 53)
                  : Colors.white,
            ),
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your password';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (!_isLogin) ...[
            TextFormField(
              style: TextStyle(
                color: globals.isLight
                    ? Color.fromARGB(255, 7, 77, 53)
                    : Colors.white,
              ),
              controller: _userNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return 'Please enter your name';
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: globals.isLight
                    ? const Color.fromARGB(255, 15, 48, 40)
                    : Theme.of(context).primaryColor,
              ),
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: const TextStyle(
                  fontSize: 16,
                  //color: const Color.fromARGB(255, 130, 213, 200),
                ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: globals.isLight
                  ? const Color.fromARGB(255, 15, 48, 40)
                  : Theme.of(context).primaryColor,
            ),
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
              style: TextStyle(
                /*color: globals.isLight
                    ? const Color.fromARGB(255, 15, 48, 40)
                    : 
                    //Theme.of(context).primaryColor,*/
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    globals.isLoggedIn = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color.fromARGB(255, 187, 251, 201),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Color.fromARGB(255, 7, 77, 53),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome, ${globals.userName}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? Color.fromARGB(255, 7, 77, 53)
                : Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _userEmail,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          icon: const Icon(Icons.lock_reset),
          label: const Text('Change Password'),
          onPressed: _showChangePasswordDialog,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Logout'),
          onPressed: _signOut,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            //side: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.isLight
          ? const Color.fromARGB(255, 168, 230, 207)
          : Color.fromARGB(255, 14, 21, 20),
      appBar: TimedAppBar(),
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

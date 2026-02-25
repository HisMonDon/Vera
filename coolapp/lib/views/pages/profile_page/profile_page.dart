import 'package:coolapp/main.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    String? errorMessage;
    bool isLoading = false;

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
                    if (errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          errorMessage!,
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
                      controller: currentPasswordController,
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
                      controller: newPasswordController,
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
                      controller: confirmPasswordController,
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
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          if (currentPasswordController.text.isEmpty) {
                            setState(() {
                              errorMessage =
                                  'Please enter your current password';
                            });
                            return;
                          }
                          if (newPasswordController.text.isEmpty) {
                            setState(() {
                              errorMessage = 'Please enter a new password';
                            });
                            return;
                          }

                          if (newPasswordController.text.length < 6) {
                            setState(() {
                              errorMessage =
                                  'Password must be at least 6 characters';
                            });
                            return;
                          }

                          if (newPasswordController.text !=
                              confirmPasswordController.text) {
                            setState(() {
                              errorMessage = 'Passwords do not match';
                            });
                            return;
                          }

                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          try {
                            final email =
                                await _authService.getCurrentUserEmail() ?? '';
                            if (email.isEmpty) {
                              setState(() {
                                errorMessage =
                                    'User session error. Please log in again.';
                                isLoading = false;
                              });
                              return;
                            }

                            final isCurrentPasswordValid =
                                await _authService.verifyCurrentPassword(
                              email,
                              currentPasswordController.text,
                            );

                            if (!isCurrentPasswordValid) {
                              setState(() {
                                errorMessage = 'Current password is incorrect';
                                isLoading = false;
                              });
                              return;
                            }
                            final success = await _authService.changePassword(
                              currentPasswordController.text,
                              newPasswordController.text,
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
                                errorMessage =
                                    'Failed to change password. ${globals.errorMessage}';
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage =
                                  'An error occurred. Please try again.';
                              isLoading = false;
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

    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        final email = await _authService.getCurrentUserEmail();
        final name = await _authService.getSavedUserName();
        final recentVideos = await getPastVideosLocally();
        //load new firestore
        final isLightFromFirestore = await _authService
            .getThemePreferenceFromFirestore(globals.userId, globals.idToken);

        if (isLightFromFirestore != null &&
            isLightFromFirestore != globals.isLight) {
          MyApp.updateTheme(isLightFromFirestore);
        }

        //initialize video controllers with recent videos
        for (int i = 0; i < _videoControllers.length; i++) {
          if (i < recentVideos.length) {
            _videoControllers[i].text = recentVideos[i];
          } else {
            _videoControllers[i].text = '';
          }
        }

        setState(() {
          isLoggedIn = true;
          _userEmail = email ?? '';
          globals.userName = name ?? '';
          globals.pastVideos = recentVideos;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
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
        TextInput.finishAutofillContext(shouldSave: true);
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
      child: AutofillGroup(
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
            //email field
            TextFormField(
              style: TextStyle(
                color: globals.isLight
                    ? Color.fromARGB(255, 0, 0, 0)
                    : Color.fromARGB(255, 255, 255, 255),
              ),
              controller: _emailController,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email
              ],
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
            //password field
            TextFormField(
              style: TextStyle(
                color: globals.isLight
                    ? Color.fromARGB(255, 7, 77, 53)
                    : Colors.white,
              ),
              controller: _passwordController,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
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
            color:
                globals.isLight ? Color.fromARGB(255, 7, 77, 53) : Colors.white,
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
        child: Column(
          children: [
            if (kIsWeb)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Vera',
                      style: GoogleFonts.mPlus1(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: globals.isLight
                            ? Color.fromARGB(255, 15, 48, 40)
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: globals.isLight
                            ? Color.fromARGB(255, 15, 48, 40)
                            : Color.fromARGB(255, 167, 198, 131),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Web',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: globals.isLight
                              ? Colors.white
                              : Color.fromARGB(255, 15, 48, 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _isInitializing
                          ? const CircularProgressIndicator()
                          : (isLoggedIn
                              ? _buildProfileView()
                              : _buildLoginForm()),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "2026 Chenyu Studios",
                            style: TextStyle(
                              fontSize: 10,
                              color: globals.isLight
                                  ? Color.fromARGB(255, 0, 0, 0)
                                  : Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.copyright_sharp,
                            size: 15,
                            color: globals.isLight
                                ? Color.fromARGB(255, 0, 0, 0)
                                : Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:color_memorizer/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuthException
import 'register_page.dart';
import '../auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onLoginSuccess;
  final ValueChanged<Locale>? onLocaleChanged;
  final ValueChanged<bool>? onThemeChanged;

  const LoginPage({
    Key? key,
    this.onLoginSuccess,
    this.onLocaleChanged,
    this.onThemeChanged,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false; // State to manage loading indicator
  String? _errorMessage; // State to hold error messages

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles the login submission
  Future<void> _submit() async {
  if (_formKey.currentState!.validate()) {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && widget.onLoginSuccess != null) {
        final prefs = await _auth.loadUserPreferences(user.uid);

        if (prefs != null) {
          final lang = prefs['language'];
          final theme = prefs['theme'];

          if (lang != null) {
            Locale locale = Locale(lang);
            widget.onLocaleChanged?.call(locale);
          }

          if (theme != null) {
            widget.onThemeChanged?.call(theme == 'dark');
          }
        }

        if (!mounted) return;
        widget.onLoginSuccess!();
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.loginFailedGeneric;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _getAuthErrorMessage(context, e.code);
      });
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.firebaseError + ": ${e.message}";
      });
    } on SocketException {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.noInternetConnection;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.anUnexpectedErrorOccurred;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  // Helper function to get user-friendly error messages from Firebase error codes
  String _getAuthErrorMessage(BuildContext context, String errorCode) {
  final loc = AppLocalizations.of(context)!;
  switch (errorCode) {
    case 'invalid-email':
      return loc.emailInvalid;
    case 'user-disabled':
      return loc.userDisabled;
    case 'user-not-found':
      return loc.userNotFound;
    case 'wrong-password':
      return loc.wrongPassword;
    case 'too-many-requests':
      return loc.tooManyRequests;
    case 'operation-not-allowed':
      return loc.operationNotAllowed;
    case 'network-request-failed':
      return loc.noInternetConnection;
    case 'internal-error':
      return loc.internalError;
    case 'unknown':
      return loc.anUnexpectedErrorOccurred;
    default:
      return loc.loginFailedGeneric;
  }
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        isDark ? const Color(0xFF001D3D) : const Color(0xFFFFC300);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.emailLabel,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.emailRequired;
                  }
                  if (!value.contains('@')) {
                    return AppLocalizations.of(context)!.emailInvalid;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordLabel,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.passwordRequired;
                  }
                  if (value.length < 6) {
                    return AppLocalizations.of(context)!.passwordTooShort;
                  }
                  return null;
                },
              ),
              // Display error message if present
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                      // Disable button when loading to prevent duplicate actions
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.loginButton,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
              TextButton(
                // Disable button when loading
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                child: Text(AppLocalizations.of(context)!.registerInstead),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


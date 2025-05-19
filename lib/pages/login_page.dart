import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'register_page.dart';
import '../auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onLoginSuccess;
  final ValueChanged<Locale>? onLocaleChanged;
  final ValueChanged<bool>? onThemeChanged;
  final VoidCallback? onEnterGuestMode; // Callback for guest mode

  const LoginPage({
    Key? key,
    this.onLoginSuccess,
    this.onLocaleChanged,
    this.onThemeChanged,
    this.onEnterGuestMode,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
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
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(AppLocalizations.of(context)!.registerInstead),
              ),
              TextButton(
                onPressed: widget.onEnterGuestMode, // Call the guest mode function
                child: Text(AppLocalizations.of(context)!.enterAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
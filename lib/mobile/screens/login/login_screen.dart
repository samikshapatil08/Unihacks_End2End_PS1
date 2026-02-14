import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAlreadyLoggedIn();
  }

  Future<void> _checkAlreadyLoggedIn() async {
    if (await AuthService.isLoggedIn) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _errorMessage = null; _isLoading = true; });
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter username and password';
        _isLoading = false;
      });
      return;
    }
    final result = await AuthService.login(username, password);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = result.errorMessage ?? 'Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.bubble_chart, size: 80, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Reflection', textAlign: TextAlign.center, style: AppTypography.h1),
                  Text(
                    "Your company's internal space for thoughtful communication",
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 48),
                  if (_errorMessage != null) ...[
                    Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: Colors.red)),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username', hintText: 'Your username'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', hintText: 'Enter your password'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign In', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

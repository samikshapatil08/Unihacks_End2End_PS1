import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/auth_service.dart';

class WebSignupScreen extends StatefulWidget {
  const WebSignupScreen({super.key});

  @override
  State<WebSignupScreen> createState() => _WebSignupScreenState();
}

class _WebSignupScreenState extends State<WebSignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _errorMessage = null; _isLoading = true; });
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty) {
      setState(() { _errorMessage = 'Please enter a username'; _isLoading = false; });
      return;
    }
    if (password.isEmpty) {
      setState(() { _errorMessage = 'Please enter a password'; _isLoading = false; });
      return;
    }
    final result = await AuthService.register(
      username: username,
      password: password,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      firstName: _firstNameController.text.trim().isEmpty ? null : _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty ? null : _lastNameController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = result.errorMessage ?? 'Sign up failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
        children: [
          Expanded(
            child: Container(
              color: AppColors.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bubble_chart, size: 120, color: Colors.white),
                    const SizedBox(height: 24),
                    Text(
                      'Reflection',
                      style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Internal space for thoughtful team communication',
                      style: AppTypography.bodyLarge.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Create account', style: AppTypography.h1),
                        const SizedBox(height: 32),
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            style: AppTypography.bodySmall.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Your username',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email (optional)',
                            hintText: 'your@company.com',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'First name (optional)'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'Last name (optional)'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: '••••••••',
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Already have an account? Sign in'),
                        ),
                      ],
                    ),
                  ),
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

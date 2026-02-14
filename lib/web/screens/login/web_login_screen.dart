import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../widgets/responsive_container.dart';

class WebLoginScreen extends StatelessWidget {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left Side: Branding
          Expanded(
            child: Container(
              color: AppColors.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bubble_chart, size: 120, color: Colors.white),
                    const SizedBox(height: 24),
                    Text('Reflection', style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 48)),
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
          // Right Side: Login Form
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Welcome Back', style: AppTypography.h1),
                      const SizedBox(height: 32),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Work Email',
                          hintText: 'your.name@company.com',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
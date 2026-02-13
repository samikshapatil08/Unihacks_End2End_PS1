import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(name: 'John Doe', size: 80),
                const SizedBox(height: 16),
                Text('John Doe', style: AppTypography.h1),
                Text('Senior Product Designer', style: AppTypography.bodyMedium),
                Text('john.doe@company.com', style: AppTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('12', 'Reflections'),
              _buildStat('48', 'Comments'),
              _buildStat('23', 'Saved'),
            ],
          ),
          const SizedBox(height: 40),
          _buildOption(Icons.notifications_none, 'Notifications', 'Manage your notification preferences'),
          _buildOption(Icons.bookmark_border, 'Saved', ''),
          _buildOption(Icons.lock_outline, 'Privacy', 'Control who can see your reflections'),
          _buildOption(Icons.settings_outlined, 'Settings', 'App preferences and account'),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: AppTypography.h1),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: AppTypography.bodySmall) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
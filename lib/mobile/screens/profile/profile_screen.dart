import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/profile_service.dart';
import '../../../data/models/profile_model.dart';
import '../../../shared/widgets/avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final p = await ProfileService.getProfile();
    if (mounted) {
      setState(() {
        _profile = p;
        _loading = false;
        if (p == null) _error = 'Could not load profile';
      });
    }
  }

  Future<void> _signOut() async {
    await AuthService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: SafeArea(child: const Center(child: CircularProgressIndicator())),
      );
    }
    if (_error != null && _profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!, style: AppTypography.bodyMedium),
                const SizedBox(height: 16),
                TextButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }
    final p = _profile;
    final name = p?.displayName ?? 'User';
    final role = p?.role ?? '';
    final email = p?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(name: name, size: 80),
                const SizedBox(height: 16),
                Text(name, style: AppTypography.h1),
                Text(role, style: AppTypography.bodyMedium),
                Text(email, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('${p?.reflectionsCount ?? 0}', 'Reflections'),
              _buildStat('${p?.commentsCount ?? 0}', 'Comments'),
              _buildStat('${p?.savedCount ?? 0}', 'Saved'),
            ],
          ),
          const SizedBox(height: 40),
          _buildOption(Icons.notifications_none, 'Notifications', 'Manage your notification preferences'),
          _buildOption(Icons.bookmark_border, 'Saved', ''),
          _buildOption(Icons.lock_outline, 'Privacy', 'Control who can see your reflections'),
          _buildOption(Icons.settings_outlined, 'Settings', 'App preferences and account'),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
        ),
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

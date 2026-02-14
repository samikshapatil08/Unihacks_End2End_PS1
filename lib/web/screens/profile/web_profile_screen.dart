import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/profile_service.dart';
import '../../../data/models/profile_model.dart';
import '../../../shared/widgets/avatar.dart';
import '../../widgets/web_scaffold.dart';

class WebProfileScreen extends StatefulWidget {
  const WebProfileScreen({super.key});

  @override
  State<WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<WebProfileScreen> {
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
      return WebScaffold(
        title: 'Profile',
        selectedIndex: 3,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null && _profile == null) {
      return WebScaffold(
        title: 'Profile',
        selectedIndex: 3,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: AppTypography.bodyMedium),
              const SizedBox(height: 16),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    final p = _profile;
    final name = p?.displayName ?? 'User';
    final role = p?.role ?? '';

    return WebScaffold(
      title: 'Profile',
      selectedIndex: 3,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  AppAvatar(name: name, size: 100),
                  const SizedBox(height: 24),
                  Text(name, style: AppTypography.h1),
                  Text(role, style: AppTypography.bodyLarge),
                  const Divider(height: 40),
                  _statRow('${p?.reflectionsCount ?? 0}', 'Reflections'),
                  _statRow('${p?.commentsCount ?? 0}', 'Comments'),
                  _statRow('${p?.savedCount ?? 0}', 'Saved'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _settingTile(Icons.notifications_none, 'Notifications', 'Manage your notification preferences'),
                _settingTile(Icons.lock_outline, 'Privacy', 'Control who can see your shared insights'),
                _settingTile(Icons.settings_outlined, 'Account Settings', 'Manage email and app preferences'),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Sign Out of Account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String val, String lbl) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(lbl),
            const Spacer(),
            Text(val, style: AppTypography.h2),
          ],
        ),
      );

  Widget _settingTile(IconData icon, String title, String sub) => Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          subtitle: Text(sub),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}

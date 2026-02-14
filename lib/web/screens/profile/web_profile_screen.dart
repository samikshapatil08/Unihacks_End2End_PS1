import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';
import '../../widgets/web_scaffold.dart';

class WebProfileScreen extends StatelessWidget {
  const WebProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Profile',
      selectedIndex: 3,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Profile Card
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                children: [
                  const AppAvatar(name: 'John Doe', size: 100),
                  const SizedBox(height: 24),
                  Text('John Doe', style: AppTypography.h1),
                  Text('Senior Product Designer', style: AppTypography.bodyLarge),
                  const Divider(height: 40),
                  _statRow('12', 'Reflections'),
                  _statRow('48', 'Comments'),
                  _statRow('23', 'Saved'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Right Settings
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _settingTile(Icons.notifications_none, 'Notifications', 'Manage your notification preferences'),
                _settingTile(Icons.lock_outline, 'Privacy', 'Control who can see your shared insights'),
                _settingTile(Icons.settings_outlined, 'Account Settings', 'Manage email and app preferences'),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red),
                  child: const Text('Sign Out of Account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String val, String lbl) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Text(lbl), const Spacer(), Text(val, style: AppTypography.h2)]));

  Widget _settingTile(IconData icon, String title, String sub) => Card(child: ListTile(leading: Icon(icon, color: AppColors.primary), title: Text(title), subtitle: Text(sub), trailing: const Icon(Icons.chevron_right)));
}
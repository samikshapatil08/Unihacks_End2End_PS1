import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import 'responsive_container.dart';

class WebScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final int selectedIndex;

  const WebScaffold({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 1,
        title: ResponsiveContainer(
          maxWidth: 1100,
          usePadding: false,
          child: Row(
            children: [
              const Icon(Icons.bubble_chart, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Reflection', style: AppTypography.h2.copyWith(color: AppColors.primary)),
              const Spacer(),
              _navItem(context, 'Home', 0, '/home'),
              _navItem(context, 'Vault', 2, '/vault'),
              _navItem(context, 'Profile', 3, '/profile'),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/create'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Reflection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          maxWidth: 1000,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, int index, String route) {
    final bool isSelected = selectedIndex == index;
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: isSelected ? AppColors.primary : AppColors.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
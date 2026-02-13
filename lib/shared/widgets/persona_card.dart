import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import 'app_card.dart';

class PersonaCard extends StatelessWidget {
  final String name;
  final String insight;
  final VoidCallback onChat;

  const PersonaCard({
    super.key,
    required this.name,
    required this.insight,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(insight, style: AppTypography.bodyMedium),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onChat,
            child: Text(
              'Chat with this persona',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
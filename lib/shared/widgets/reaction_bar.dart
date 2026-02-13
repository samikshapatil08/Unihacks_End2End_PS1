import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';

class ReactionBar extends StatelessWidget {
  final int reactions;
  final int comments;

  const ReactionBar({
    super.key,
    required this.reactions,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.favorite_border, size: 18, color: AppColors.secondaryText),
        const SizedBox(width: 4),
        Text('$reactions', style: AppTypography.bodySmall),
        const SizedBox(width: 16),
        Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.secondaryText),
        const SizedBox(width: 4),
        Text('$comments', style: AppTypography.bodySmall),
      ],
    );
  }
}
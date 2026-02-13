import 'package:flutter/material.dart';
import 'avatar.dart';
import '../../core/constants/typography.dart';

class CommentTile extends StatelessWidget {
  final String name;
  final String role;
  final String content;
  final String time;

  const CommentTile({
    super.key,
    required this.name,
    required this.role,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(name: name, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time, style: AppTypography.bodySmall),
                  ],
                ),
                Text(role, style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Text(content, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
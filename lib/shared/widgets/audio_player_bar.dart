import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AudioPlayerBar extends StatelessWidget {
  final String currentPos;
  final String totalDur;

  const AudioPlayerBar({
    super.key,
    required this.currentPos,
    required this.totalDur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softSection,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, size: 48, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: 0.35,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentPos),
                    Text(totalDur),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
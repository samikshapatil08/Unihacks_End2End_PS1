import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/audio_player_bar.dart';
import '../../../shared/widgets/avatar.dart';

class AudioDiscussionScreen extends StatelessWidget {
  const AudioDiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Discussion')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              AppAvatar(name: 'Sarah Chen'),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sarah Chen', style: AppTypography.bodyLarge),
                  Text('Product Designer • 3h ago', style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Q4 Product Launch Retrospective', style: AppTypography.h1),
          const SizedBox(height: 24),
          const AudioPlayerBar(currentPos: '1:27', totalDur: '4:05'),
          const Divider(height: 48),
          Text('Transcript', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            "Hey everyone, I wanted to take a moment to reflect on our Q4 product launch. Overall, I think we did an amazing job, but there are definitely lessons we can take forward...",
            style: AppTypography.bodyMedium.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/audio_model.dart';
import '../../../shared/widgets/audio_player_bar.dart';
import '../../../shared/widgets/avatar.dart';

class AudioDiscussionScreen extends StatelessWidget {
  const AudioDiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! AudioModel) {
      return Scaffold(
        appBar: AppBar(title: const Text('Audio Discussion')),
        body: SafeArea(child: Center(child: Text('No audio selected.', style: AppTypography.bodyMedium))),
      );
    }
    final a = args;
    final authorLabel = a.timeAgo != null ? '${a.authorName} • ${a.timeAgo}' : a.authorName;

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Discussion')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              AppAvatar(name: a.authorName),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.authorName, style: AppTypography.bodyLarge),
                  Text(authorLabel, style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(a.title, style: AppTypography.h1),
          const SizedBox(height: 24),
          AudioPlayerBar(currentPos: '0:00', totalDur: a.duration),
          const Divider(height: 48),
          Text('Transcript', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            a.transcript ?? 'No transcript available.',
            style: AppTypography.bodyMedium.copyWith(height: 1.6),
          ),
        ],
        ),
      ),
    );
  }
}

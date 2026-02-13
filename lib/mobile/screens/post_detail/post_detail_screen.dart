import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/comment_tile.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.analytics_outlined), onPressed: () => Navigator.pushNamed(context, '/analysis')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              AppAvatar(name: post.authorName),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorName, style: AppTypography.bodyLarge),
                  Text(post.authorRole, style: AppTypography.bodySmall),
                ],
              ),
              const Spacer(),
              Text(post.timeAgo, style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 24),
          Text(post.title, style: AppTypography.h1),
          const SizedBox(height: 16),
          Text(post.content, style: AppTypography.bodyLarge.copyWith(height: 1.5)),
          const SizedBox(height: 24),
          Wrap(spacing: 8, children: post.tags.map((t) => TagChip(label: t)).toList()),
          const Divider(height: 48),
          Text('Comments (3)', style: AppTypography.h2),
          const CommentTile(
            name: 'David Kim',
            role: 'Senior Engineer',
            time: '1h ago',
            content: 'This resonates deeply with me. I had a similar realization during our last sprint.',
          ),
          const CommentTile(
            name: 'Lisa Zhang',
            role: 'UX Researcher',
            time: '45m ago',
            content: 'Would love to hear more about your interview process. Could we schedule time to discuss?',
          ),
        ],
      ),
    );
  }
}
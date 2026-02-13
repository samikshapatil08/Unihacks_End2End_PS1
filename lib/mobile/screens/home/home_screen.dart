import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/reaction_bar.dart';
import '../../../shared/widgets/bottom_nav.dart';
import '../../../core/services/mock_data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.getMockPosts();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Recent reflections from your team', style: AppTypography.bodySmall),
          const SizedBox(height: 16),
          ...posts.map((post) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              onTap: () => Navigator.pushNamed(context, '/post', arguments: post),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppAvatar(name: post.authorName),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.authorName, style: AppTypography.bodyLarge),
                          Text('${post.authorRole} • ${post.timeAgo}', style: AppTypography.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(post.title, style: AppTypography.h2),
                  const SizedBox(height: 8),
                  Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: post.tags.map((t) => TagChip(label: t)).toList(),
                  ),
                  const SizedBox(height: 16),
                  ReactionBar(reactions: post.reactionCount, comments: post.commentCount),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) Navigator.pushNamed(context, '/create');
          if (index == 2) Navigator.pushNamed(context, '/vault');
          if (index == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/reaction_bar.dart';
import '../../widgets/web_scaffold.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = MockDataService.getMockPosts();

    return WebScaffold(
      title: 'Home',
      selectedIndex: 0,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent reflections from your team', style: AppTypography.h2),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 260,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return AppCard(
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
                    const SizedBox(height: 16),
                    Text(post.title, style: AppTypography.h2),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: post.tags.map((t) => TagChip(label: t)).toList(),
                    ),
                    const Divider(height: 24),
                    ReactionBar(reactions: post.reactionCount, comments: post.commentCount),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
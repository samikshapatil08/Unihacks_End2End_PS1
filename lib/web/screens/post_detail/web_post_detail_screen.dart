import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/comment_tile.dart';
import '../../../core/utils/pdf_exporter.dart';
import '../../widgets/web_scaffold.dart';

class WebPostDetailScreen extends StatelessWidget {
  final GlobalKey _printKey = GlobalKey();

  WebPostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;

    return WebScaffold(
      title: 'Reflection Detail',
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          onPressed: () => PdfExporter.exportScreenToPDF(_printKey),
          tooltip: 'Export to PDF',
        ),
        IconButton(
          icon: const Icon(Icons.analytics_outlined),
          onPressed: () => Navigator.pushNamed(context, '/analysis'),
          tooltip: 'View AI Analysis',
        ),
      ],
      body: RepaintBoundary(
        key: _printKey,
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppAvatar(name: post.authorName, size: 60),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTypography.h2),
                      Text(post.authorRole, style: AppTypography.bodyMedium),
                    ],
                  ),
                  const Spacer(),
                  Text(post.timeAgo, style: AppTypography.bodySmall),
                ],
              ),
              const SizedBox(height: 40),
              Text(post.title, style: AppTypography.h1.copyWith(fontSize: 32)),
              const SizedBox(height: 24),
              Text(post.content, style: AppTypography.bodyLarge.copyWith(height: 1.8, fontSize: 18)),
              const SizedBox(height: 40),
              Wrap(spacing: 12, children: post.tags.map((t) => TagChip(label: t)).toList()),
              const Divider(height: 80),
              Text('Discussion (3)', style: AppTypography.h2),
              const SizedBox(height: 24),
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
                content: 'Would love to hear more about your interview process.',
              ),
              const SizedBox(height: 32),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softSection,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const AppAvatar(name: 'John Doe', size: 32),
          const SizedBox(width: 16),
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Add a thoughtful comment...', border: InputBorder.none, enabledBorder: InputBorder.none))),
          ElevatedButton(onPressed: () {}, child: const Text('Post')),
        ],
      ),
    );
  }
}
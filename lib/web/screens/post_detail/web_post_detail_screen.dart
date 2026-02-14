import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../core/constants/typography.dart';
import '../../../core/utils/pdf_exporter.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/comment_tile.dart';
import '../../widgets/web_scaffold.dart';

class WebPostDetailScreen extends StatefulWidget {
  WebPostDetailScreen({super.key});

  @override
  State<WebPostDetailScreen> createState() => _WebPostDetailScreenState();
}

class _WebPostDetailScreenState extends State<WebPostDetailScreen> {
  final _printKey = GlobalKey();
  final _repo = PostRepository();
  List<CommentDto> _comments = [];
  bool _commentsLoading = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final post = ModalRoute.of(context)?.settings.arguments as PostModel?;
    if (post != null) _loadComments(post.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments(String postId) async {
    setState(() => _commentsLoading = true);
    final list = await _repo.getComments(postId);
    if (mounted) setState(() { _comments = list; _commentsLoading = false; });
  }

  Future<void> _submitComment(String postId) async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    _commentController.clear();
    final created = await _repo.createComment(postId, content);
    if (created != null && mounted) {
      setState(() => _comments = [..._comments, created]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)?.settings.arguments as PostModel?;
    if (post == null) {
      return WebScaffold(
        title: 'Reflection Detail',
        body: SafeArea(child: const Center(child: Text('Post not found'))),
      );
    }

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
          onPressed: () => Navigator.pushNamed(context, '/analysis', arguments: post),
          tooltip: 'View AI Analysis',
        ),
      ],
      body: RepaintBoundary(
        key: _printKey,
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
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
              Text('Discussion (${_comments.length})', style: AppTypography.h2),
              if (_commentsLoading) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
              ..._comments.map((c) => CommentTile(
                    name: c.userName,
                    role: '',
                    time: _formatTimeAgo(c.createdAt),
                    content: c.content,
                  )),
              const SizedBox(height: 32),
              _buildCommentInput(post.id),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${diff.inDays ~/ 7}w ago';
    } catch (_) {
      return iso;
    }
  }

  Widget _buildCommentInput(String postId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          AppAvatar(name: 'User', size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a thoughtful comment...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onSubmitted: (_) => _submitComment(postId),
            ),
          ),
          ElevatedButton(onPressed: () => _submitComment(postId), child: const Text('Post')),
        ],
      ),
    );
  }
}

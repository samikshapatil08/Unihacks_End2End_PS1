import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/comment_tile.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _repo = PostRepository();
  List<CommentDto> _comments = [];
  bool _commentsLoading = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final post = ModalRoute.of(context)!.settings.arguments as PostModel?;
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
    final post = ModalRoute.of(context)!.settings.arguments as PostModel?;
    if (post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(child: const Center(child: Text('Post not found'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => Navigator.pushNamed(context, '/analysis', arguments: post),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
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
          Text('Comments (${_comments.length})', style: AppTypography.h2),
          if (_commentsLoading) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
          ..._comments.map((c) => CommentTile(
                name: c.userName,
                role: '',
                time: _formatTimeAgo(c.createdAt),
                content: c.content,
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(hintText: 'Add a thoughtful comment...', border: OutlineInputBorder()),
                  onSubmitted: (_) => _submitComment(post.id),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _submitComment(post.id), child: const Text('Post')),
            ],
          ),
        ],
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
}

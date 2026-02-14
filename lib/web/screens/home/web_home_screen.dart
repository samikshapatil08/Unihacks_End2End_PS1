import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/reaction_bar.dart';
import '../../widgets/web_scaffold.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final _repo = PostRepository();
  List<PostModel> _posts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoad();
  }

  Future<void> _checkAuthAndLoad() async {
    final loggedIn = await AuthService.isLoggedIn;
    if (!mounted) return;
    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() { _loading = true; _error = null; });
    final list = await _repo.fetchPosts();
    if (mounted) {
      setState(() {
        _posts = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Home',
      selectedIndex: 0,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: AppTypography.bodyMedium),
                      const SizedBox(height: 16),
                      TextButton(onPressed: _loadPosts, child: const Text('Retry')),
                    ],
                  ),
                )
              : Column(
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
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
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

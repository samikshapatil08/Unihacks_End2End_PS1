import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/reaction_bar.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: _loading
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
                : RefreshIndicator(
                    onRefresh: _loadPosts,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                    children: [
                      Text('Recent reflections from your team', style: AppTypography.bodySmall),
                      const SizedBox(height: 16),
                      ..._posts.map((post) => Padding(
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
                  ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
            final ok = await Navigator.pushNamed(context, '/create');
            if (ok == true) _loadPosts();
          }
          if (index == 2) Navigator.pushNamed(context, '/vault');
          if (index == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }
}

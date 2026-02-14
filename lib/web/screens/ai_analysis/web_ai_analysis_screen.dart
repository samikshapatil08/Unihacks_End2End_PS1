import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/ai_service.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/persona_card.dart';
import '../../widgets/web_scaffold.dart';

const _personaNames = ['Product Manager', 'Engineering Lead', 'Team Psychologist'];

class WebAiAnalysisScreen extends StatefulWidget {
  const WebAiAnalysisScreen({super.key});

  @override
  State<WebAiAnalysisScreen> createState() => _WebAiAnalysisScreenState();
}

class _WebAiAnalysisScreenState extends State<WebAiAnalysisScreen> {
  List<PersonaInsight> _personas = [];
  bool _loading = true;
  bool _generating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  Future<void> _loadAnalysis() async {
    final post = ModalRoute.of(context)?.settings.arguments as PostModel?;
    if (post == null) {
      setState(() { _loading = false; _error = 'No post context'; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    final list = await AiService.listAnalysis(post.id);
    if (!mounted) return;
    setState(() {
      _personas = list;
      _loading = false;
    });
  }

  Future<void> _generateAnalysis() async {
    final post = ModalRoute.of(context)?.settings.arguments as PostModel?;
    if (post == null) return;
    setState(() => _generating = true);
    for (final name in _personaNames) {
      await AiService.createAnalysis(post.id, name, analysisText: 'Analyze this reflection');
    }
    if (!mounted) return;
    await _loadAnalysis();
    if (mounted) setState(() => _generating = false);
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)?.settings.arguments as PostModel?;

    if (_loading) {
      return WebScaffold(
        title: 'AI Analysis',
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return WebScaffold(
        title: 'AI Analysis',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: AppTypography.bodyMedium),
              const SizedBox(height: 16),
              TextButton(onPressed: _loadAnalysis, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return WebScaffold(
      title: 'AI Analysis',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perspective Analysis', style: AppTypography.h1),
          const SizedBox(height: 8),
          Text(
            'Explore how different professional personas interpret this reflection.',
            style: AppTypography.bodyLarge,
          ),
          if (_personas.isEmpty) ...[
            const SizedBox(height: 24),
            const Text('No analysis yet. Generate perspectives for this reflection.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generating ? null : _generateAnalysis,
              child: _generating ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Generate analysis'),
            ),
          ],
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.8,
            children: _personas.map((p) => PersonaCard(
              name: p.name,
              insight: p.insight,
              onChat: () => Navigator.pushNamed(context, '/chat', arguments: {'persona': p.name, 'postId': post?.id}),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

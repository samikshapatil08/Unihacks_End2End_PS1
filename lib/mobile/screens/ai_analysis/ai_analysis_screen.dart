import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/ai_service.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/persona_card.dart';

const _personaNames = ['Product Manager', 'Engineering Lead', 'Team Psychologist'];

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
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
      return Scaffold(
        appBar: AppBar(title: const Text('AI Analysis')),
        body: SafeArea(child: const Center(child: CircularProgressIndicator())),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Analysis')),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!, style: AppTypography.bodyMedium),
                const SizedBox(height: 16),
                TextButton(onPressed: _loadAnalysis, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AI Analysis')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
        children: [
          Text('Multiple Perspectives', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            'Our AI has analyzed this reflection from different professional viewpoints. Select a persona to dive deeper.',
            style: AppTypography.bodyMedium,
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
          const SizedBox(height: 24),
          ..._personas.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PersonaCard(
                  name: p.name,
                  insight: p.insight,
                  onChat: () => Navigator.pushNamed(context, '/chat', arguments: {'persona': p.name, 'postId': post?.id}),
                ),
              )),
        ],
        ),
      ),
    );
  }
}

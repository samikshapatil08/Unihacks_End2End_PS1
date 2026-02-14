import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/persona_card.dart';
import '../../widgets/web_scaffold.dart';

class WebAiAnalysisScreen extends StatelessWidget {
  const WebAiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.8,
            children: [
              PersonaCard(
                name: 'Product Manager',
                insight: 'Highlights a critical gap in research methodology and impacts how we validate product decisions.',
                onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Product Manager'),
              ),
              PersonaCard(
                name: 'Engineering Lead',
                insight: 'Suggests building analytics to capture user hesitation patterns and pauses to quantify qualitative data.',
                onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Engineering Lead'),
              ),
              PersonaCard(
                name: 'Team Psychologist',
                insight: 'Demonstrates awareness of non-verbal communication which extends to the overall team development.',
                onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Team Psychologist'),
              ),
              PersonaCard(
                name: 'Communication Coach',
                insight: 'Profound insight: silence is a form of feedback. Recommends training on active listening.',
                onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Communication Coach'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
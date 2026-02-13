import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/persona_card.dart';

class AiAnalysisScreen extends StatelessWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Multiple Perspectives', style: AppTypography.h2),
          const SizedBox(height: 8),
          Text(
            'Our AI has analyzed this reflection from different professional viewpoints. Select a persona to dive deeper.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),
          PersonaCard(
            name: 'Product Manager',
            insight: 'From a product perspective, this reflection highlights a critical gap in our user research methodology.',
            onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Product Manager'),
          ),
          const SizedBox(height: 16),
          PersonaCard(
            name: 'Engineering Lead',
            insight: 'The technical implication here is that we should consider building better analytics to capture user hesitation.',
            onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Engineering Lead'),
          ),
          const SizedBox(height: 16),
          PersonaCard(
            name: 'Team Psychologist',
            insight: 'This reflection demonstrates excellent emotional intelligence. Sarah awareness of non-verbal cues is vital.',
            onChat: () => Navigator.pushNamed(context, '/chat', arguments: 'Team Psychologist'),
          ),
        ],
      ),
    );
  }
}
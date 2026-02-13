import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/tag_chip.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Knowledge Vault')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search saved reflections...')),
          const SizedBox(height: 24),
          Text('4 saved', style: AppTypography.bodySmall),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reflections on User Research Sessions', style: AppTypography.h2),
                Text('by Sarah Chen • Feb 10', style: AppTypography.bodySmall),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: const [TagChip(label: 'Research'), TagChip(label: 'Product')]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The Power of Vulnerability in Team', style: AppTypography.h2),
                Text('by Emma Williams • Feb 9', style: AppTypography.bodySmall),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: const [TagChip(label: 'Culture'), TagChip(label: 'Communication')]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../widgets/web_scaffold.dart';

class WebVaultScreen extends StatelessWidget {
  const WebVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Knowledge Vault',
      selectedIndex: 2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Knowledge Vault', style: AppTypography.h1),
              const Spacer(),
              SizedBox(width: 300, child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search reflections...'))),
            ],
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 180,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reflection #${index + 1}', style: AppTypography.h2),
                  Text('Feb 10, 2026', style: AppTypography.bodySmall),
                  const Spacer(),
                  const Wrap(spacing: 8, children: [TagChip(label: 'Design'), TagChip(label: 'Product')]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

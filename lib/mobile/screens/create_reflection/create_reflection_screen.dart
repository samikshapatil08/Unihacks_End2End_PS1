import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

class CreateReflectionScreen extends StatelessWidget {
  const CreateReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reflection'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Publish', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WRITING PROMPT', style: AppTypography.label),
            Text('What did you learn today?', style: AppTypography.h2),
            const SizedBox(height: 24),
            TextField(
              style: AppTypography.h1,
              decoration: const InputDecoration(
                hintText: 'Give your reflection a title...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                style: AppTypography.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'Take your time to reflect...\nShare your experiences, learnings, and insights.',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.local_offer_outlined),
              label: const Text('Add Tags'),
            ),
          ],
        ),
      ),
    );
  }
}
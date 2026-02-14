import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../widgets/web_scaffold.dart';

class WebCreateReflectionScreen extends StatefulWidget {
  const WebCreateReflectionScreen({super.key});

  @override
  State<WebCreateReflectionScreen> createState() => _WebCreateReflectionScreenState();
}

class _WebCreateReflectionScreenState extends State<WebCreateReflectionScreen> {
  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'New Reflection', // [cite: 303]
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WRITING PROMPT', style: AppTypography.label), // [cite: 305]
                      Text('What did you learn today?', style: AppTypography.h2.copyWith(fontSize: 24)), // [cite: 306]
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Publish Reflection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // 
                  ),
                ],
              ),
              const Divider(height: 64),
              TextField(
                style: AppTypography.h1.copyWith(fontSize: 32),
                decoration: const InputDecoration(
                  hintText: 'Give your reflection a title...', // 
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                maxLines: 15,
                style: AppTypography.bodyLarge.copyWith(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Take your time to reflect...\nShare your experiences, learnings, and insights to help your team grow together.', // [cite: 308, 309, 316, 317]
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_offer_outlined),
                    label: const Text('Add Tags'), // [cite: 310]
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Adding tags helps team members find your insights later.', style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
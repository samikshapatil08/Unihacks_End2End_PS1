import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/audio_player_bar.dart';
import '../../../core/utils/pdf_exporter.dart';
import '../../widgets/web_scaffold.dart';

class WebAudioDiscussionScreen extends StatelessWidget {
  final GlobalKey _printKey = GlobalKey();

  WebAudioDiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Audio Discussion',
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          onPressed: () => PdfExporter.exportScreenToPDF(_printKey),
          tooltip: 'Export Discussion to PDF',
        ),
      ],
      body: RepaintBoundary(
        key: _printKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Player and Info
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppAvatar(name: 'Sarah Chen', size: 54), // [cite: 194]
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sarah Chen', style: AppTypography.h2), // [cite: 194]
                            Text('Product Designer • 3h ago', style: AppTypography.bodySmall), // [cite: 196, 198]
                          ],
                        ),
                        const Spacer(),
                        const Chip(label: Text('Retrospective')), // [cite: 199]
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('Q4 Product Launch Retrospective', style: AppTypography.h1.copyWith(fontSize: 28)), // [cite: 197]
                    const SizedBox(height: 32),
                    const AudioPlayerBar(currentPos: '1:27', totalDur: '4:05'), // [cite: 200, 201]
                    const SizedBox(height: 40),
                    Text('Team Responses (3)', style: AppTypography.h2), // 
                    const SizedBox(height: 16),
                    _buildResponseTile('Michael Rodriguez', '2:15'), // [cite: 233, 236]
                    _buildResponseTile('Emma Williams', '1:42'), // [cite: 234, 237]
                    _buildResponseTile('David Kim', '3:08'), // [cite: 239, 240]
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            // Right Column: Transcript
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.softSection,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transcript', style: AppTypography.h2), // 
                    const SizedBox(height: 16),
                    Text(
                      "Hey everyone, I wanted to take a moment to reflect on our Q4 product launch. Overall, I think we did an amazing job, but there are definitely lessons we can take forward.\n\nFirst, the positive: our cross-functional collaboration was exceptional. The way engineering, design, and product worked together during the final sprint was exactly what was needed. We shipped on time and the quality was solid.", // [cite: 203-215]
                      style: AppTypography.bodyMedium.copyWith(height: 1.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseTile(String name, String duration) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: AppAvatar(name: name, size: 32),
      title: Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(duration, style: AppTypography.bodySmall),
          const SizedBox(width: 8),
          const Icon(Icons.play_arrow_outlined, size: 20),
        ],
      ),
    );
  }
}
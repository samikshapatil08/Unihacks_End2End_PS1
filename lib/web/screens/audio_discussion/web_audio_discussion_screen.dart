import 'package:flutter/material.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/audio_model.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/audio_player_bar.dart';
import '../../../core/utils/pdf_exporter.dart';
import '../../widgets/web_scaffold.dart';

class WebAudioDiscussionScreen extends StatefulWidget {
  const WebAudioDiscussionScreen({super.key});

  @override
  State<WebAudioDiscussionScreen> createState() => _WebAudioDiscussionScreenState();
}

class _WebAudioDiscussionScreenState extends State<WebAudioDiscussionScreen> {
  final GlobalKey _printKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! AudioModel) {
      return WebScaffold(
        title: 'Audio Discussion',
        body: Center(child: Text('No audio selected.', style: AppTypography.bodyMedium)),
      );
    }
    final a = args;
    final authorLabel = a.timeAgo != null ? '${a.authorName} • ${a.timeAgo}' : a.authorName;

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
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppAvatar(name: a.authorName, size: 54),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.authorName, style: AppTypography.h2),
                            Text(authorLabel, style: AppTypography.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(a.title, style: AppTypography.h1.copyWith(fontSize: 28)),
                    const SizedBox(height: 32),
                    AudioPlayerBar(currentPos: '0:00', totalDur: a.duration),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transcript', style: AppTypography.h2),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          a.transcript ?? 'No transcript available.',
                          style: AppTypography.bodyMedium.copyWith(height: 1.8),
                        ),
                      ),
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
}

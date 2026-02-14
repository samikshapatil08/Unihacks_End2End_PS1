import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../widgets/web_scaffold.dart';

class WebCreateReflectionScreen extends StatefulWidget {
  const WebCreateReflectionScreen({super.key});

  @override
  State<WebCreateReflectionScreen> createState() => _WebCreateReflectionScreenState();
}

class _WebCreateReflectionScreenState extends State<WebCreateReflectionScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _repo = PostRepository();
  String _selectedTag = kPostTagChoices.first;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Please add a title');
      return;
    }
    if (content.isEmpty) {
      setState(() => _error = 'Please add some content');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final post = await _repo.createPost(title: title, content: content, tag: _selectedTag);
    if (!mounted) return;
    setState(() => _loading = false);
    if (post != null) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = 'Failed to publish. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'New Reflection',
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
                      Text('WRITING PROMPT', style: AppTypography.label),
                      Text('What did you learn today?', style: AppTypography.h2.copyWith(fontSize: 24)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _loading ? null : _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Publish Reflection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: AppTypography.bodySmall.copyWith(color: Colors.red)),
              ],
              const Divider(height: 64),
              TextField(
                controller: _titleController,
                style: AppTypography.h1.copyWith(fontSize: 32),
                decoration: const InputDecoration(
                  hintText: 'Give your reflection a title...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedTag,
                decoration: const InputDecoration(labelText: 'Tag'),
                items: kPostTagChoices.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedTag = v ?? kPostTagChoices.first),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _contentController,
                maxLines: 15,
                style: AppTypography.bodyLarge.copyWith(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Take your time to reflect...\nShare your experiences, learnings, and insights to help your team grow together.',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

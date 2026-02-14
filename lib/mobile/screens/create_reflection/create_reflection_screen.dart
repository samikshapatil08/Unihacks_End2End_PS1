import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';

class CreateReflectionScreen extends StatefulWidget {
  const CreateReflectionScreen({super.key});

  @override
  State<CreateReflectionScreen> createState() => _CreateReflectionScreenState();
}

class _CreateReflectionScreenState extends State<CreateReflectionScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reflection'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _publish,
            child: _loading
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Publish', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WRITING PROMPT', style: AppTypography.label),
                Text('What did you learn today?', style: AppTypography.h2),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: AppTypography.bodySmall.copyWith(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  style: AppTypography.h1,
                  decoration: const InputDecoration(
                    hintText: 'Give your reflection a title...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedTag,
                  decoration: const InputDecoration(labelText: 'Tag'),
                  items: kPostTagChoices.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _selectedTag = v ?? kPostTagChoices.first),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  minLines: 8,
                  style: AppTypography.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Take your time to reflect...\nShare your experiences, learnings, and insights.',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

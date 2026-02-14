import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/ai_service.dart';
import '../../../shared/widgets/avatar.dart';

class PersonaChatScreen extends StatefulWidget {
  const PersonaChatScreen({super.key});

  @override
  State<PersonaChatScreen> createState() => _PersonaChatScreenState();
}

class _PersonaChatScreenState extends State<PersonaChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final List<({String sender, String text, bool isMe})> _messages = [];
  String _personaName = 'Assistant';
  String? _postId;
  bool _loading = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map) {
      _personaName = args['persona']?.toString() ?? 'Assistant';
      _postId = args['postId']?.toString();
    } else if (args is String) {
      _personaName = args;
    }
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_postId == null || _postId!.isEmpty) {
      setState(() {
        _messages.add((sender: _personaName, text: 'Open this chat from a reflection\'s AI Analysis to start.', isMe: false));
        _loaded = true;
      });
      return;
    }
    final list = await AiService.listPersonaChat(_postId!, personaName: _personaName);
    if (!mounted) return;
    final msgs = list.map((m) => (
      sender: m.senderType == 'user' ? 'Me' : _personaName,
      text: m.messageText,
      isMe: m.senderType == 'user',
    )).toList();
    setState(() {
      _messages.clear();
      if (msgs.isEmpty) {
        _messages.add((sender: _personaName, text: "Hello! I'm here to explore the $_personaName perspective. How can I help?", isMe: false));
      } else {
        _messages.addAll(msgs);
      }
      _loaded = true;
    });
    _scrollToEnd();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _loading) return;
    if (_postId == null || _postId!.isEmpty) return;
    _inputController.clear();
    setState(() => _messages.add((sender: 'Me', text: text, isMe: true)));
    _scrollToEnd();
    setState(() => _loading = true);
    await AiService.sendPersonaMessage(
      postId: _postId!,
      personaName: _personaName,
      messageText: text,
      senderType: 'user',
    );
    if (!mounted) return;
    await _loadMessages();
    if (mounted) setState(() => _loading = false);
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _postId != null && _postId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_personaName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            Text('AI Assistant', style: AppTypography.bodySmall),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return _buildMessage(m.sender, m.text, m.isMe);
              },
            ),
          ),
            if (_loading) const LinearProgressIndicator(),
            _buildInputArea(canSend: canSend),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String sender, String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) AppAvatar(name: sender, size: 32),
          const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.softSection,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text, style: TextStyle(color: isMe ? Colors.white : AppColors.primaryText)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea({required bool canSend}) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.card,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              enabled: canSend,
              decoration: InputDecoration(
                hintText: canSend ? 'Ask about risks, solutions...' : 'Open from a reflection\'s AI Analysis to chat',
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: canSend && !_loading ? _send : null,
          ),
        ],
      ),
    );
  }
}

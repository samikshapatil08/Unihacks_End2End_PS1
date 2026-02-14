import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/services/ai_service.dart';
import '../../../shared/widgets/avatar.dart';
import '../../widgets/web_scaffold.dart';

class WebPersonaChatScreen extends StatefulWidget {
  const WebPersonaChatScreen({super.key});

  @override
  State<WebPersonaChatScreen> createState() => _WebPersonaChatScreenState();
}

class _WebPersonaChatScreenState extends State<WebPersonaChatScreen> {
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
        _messages.add((sender: _personaName, text: "Hello! I'm here to explore the $_personaName perspective with you. What's on your mind?", isMe: false));
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

    return WebScaffold(
      title: 'Chat with $_personaName',
      body: Container(
        height: 600,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(32),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final m = _messages[i];
                  return _msg(m.sender, m.text, m.isMe);
                },
              ),
            ),
            if (_loading) const LinearProgressIndicator(),
            _buildInput(canSend: canSend),
          ],
        ),
      ),
    );
  }

  Widget _msg(String name, String txt, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) AppAvatar(name: name),
            if (!isMe) const SizedBox(width: 16),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary : AppColors.softSection,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(txt, style: TextStyle(color: isMe ? Colors.white : AppColors.primaryText, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({required bool canSend}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              enabled: canSend,
              decoration: InputDecoration(
                hintText: canSend ? 'Type your message...' : 'Open from a reflection\'s AI Analysis to chat',
                fillColor: AppColors.background,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: canSend && !_loading ? _send : null,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

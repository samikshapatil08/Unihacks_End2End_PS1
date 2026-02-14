import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';
import '../../widgets/web_scaffold.dart';

class WebPersonaChatScreen extends StatelessWidget {
  const WebPersonaChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personaName = ModalRoute.of(context)!.settings.arguments as String;

    return WebScaffold(
      title: 'Chat with $personaName',
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
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  _msg(personaName, "Hello! I'm here to explore the $personaName perspective with you. What's on your mind?", false),
                  _msg("Me", "How should we implement the 'silence training' mentioned?", true),
                  _msg(personaName, "I recommend starting with 5-second 'thinking pauses' in every design sync to normalize silence.", false),
                ],
              ),
            ),
            _buildInput(),
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

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type your message...', fillColor: AppColors.background))),
          const SizedBox(width: 16),
          FloatingActionButton(onPressed: () {}, backgroundColor: AppColors.primary, child: const Icon(Icons.send, color: Colors.white)),
        ],
      ),
    );
  }
}
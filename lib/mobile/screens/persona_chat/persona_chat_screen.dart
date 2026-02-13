import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/avatar.dart';

class PersonaChatScreen extends StatelessWidget {
  const PersonaChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personaName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(personaName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            Text('AI Assistant', style: AppTypography.bodySmall),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessage(personaName, "Hello! I'm here to explore the $personaName aspects. How can I help you?", false),
                _buildMessage("Me", "How to implement?", true),
                _buildMessage(personaName, "I notice there's an underlying theme of trust and psychological safety here. Have you considered team dynamics?", false),
              ],
            ),
          ),
          _buildInputArea(),
        ],
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

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.card,
      child: Row(
        children: [
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Ask about risks, solutions...'))),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send, color: AppColors.primary), onPressed: () {}),
        ],
      ),
    );
  }
}
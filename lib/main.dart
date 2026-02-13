import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'mobile/screens/login/login_screen.dart';
import 'mobile/screens/home/home_screen.dart';
import 'mobile/screens/create_reflection/create_reflection_screen.dart';
import 'mobile/screens/post_detail/post_detail_screen.dart';
import 'mobile/screens/ai_analysis/ai_analysis_screen.dart';
import 'mobile/screens/persona_chat/persona_chat_screen.dart';
import 'mobile/screens/audio_discussion/audio_discussion_screen.dart';
import 'mobile/screens/vault/vault_screen.dart';
import 'mobile/screens/profile/profile_screen.dart';

void main() {
  runApp(const ReflectionApp());
}

class ReflectionApp extends StatelessWidget {
  const ReflectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reflection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/create': (context) => const CreateReflectionScreen(),
        '/post': (context) => const PostDetailScreen(),
        '/analysis': (context) => const AiAnalysisScreen(),
        '/chat': (context) => const PersonaChatScreen(),
        '/audio': (context) => const AudioDiscussionScreen(),
        '/vault': (context) => const VaultScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
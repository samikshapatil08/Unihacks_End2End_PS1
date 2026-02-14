import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orgmind/core/utils/responsive.dart';
import 'package:orgmind/web/screens/ai_analysis/web_ai_analysis_screen.dart';
import 'package:orgmind/web/screens/audio_discussion/web_audio_discussion_screen.dart';
import 'package:orgmind/web/screens/create_reflection/web_create_reflection_screen.dart';
import 'package:orgmind/web/screens/home/web_home_screen.dart';
import 'package:orgmind/web/screens/login/web_login_screen.dart';
import 'package:orgmind/web/screens/persona_chat/web_persona_chat_screen.dart';
import 'package:orgmind/web/screens/post_detail/web_post_detail_screen.dart';
import 'package:orgmind/web/screens/profile/web_profile_screen.dart';
import 'package:orgmind/web/screens/vault/web_vault_screen.dart';
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
        '/login': (context) => Responsive(mobile: LoginScreen(), web: WebLoginScreen()),
        '/home': (context) => Responsive(mobile: HomeScreen(), web: WebHomeScreen()),
        '/create': (context) => Responsive(mobile:CreateReflectionScreen(), web:WebCreateReflectionScreen()),
        '/post': (context) => Responsive(mobile: const PostDetailScreen(),web: WebPostDetailScreen()),
        '/analysis': (context) => Responsive(mobile:AiAnalysisScreen(),web:WebAiAnalysisScreen()),
        '/chat': (context) => Responsive(mobile:PersonaChatScreen(),web: WebPersonaChatScreen()),
        '/audio': (context) =>Responsive(mobile:AudioDiscussionScreen(),web: WebAudioDiscussionScreen()),
        '/vault': (context) => Responsive(mobile: VaultScreen(),web: WebVaultScreen()),
        '/profile': (context) => Responsive(mobile: ProfileScreen(), web:WebProfileScreen()),
      },
    );
  }
}
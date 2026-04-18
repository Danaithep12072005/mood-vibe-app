import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'pages/sign_in_page.dart';
import 'pages/score_page.dart';
import 'pages/statistics_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_edit_page.dart';
import 'pages/add_entry_page.dart';
import 'pages/emotion_detail_page.dart';
import 'pages/ai_chat_page.dart';
import 'pages/register_page.dart';
import 'pages/edit_mood_page.dart';
import 'pages/playlist_page.dart';
import 'pages/music_player_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoodVibe',
      theme: ThemeData(
        fontFamily: 'Prompt', 
        scaffoldBackgroundColor: const Color(0xFFFDFCF1),
      ),
      home: SignInPage(), 
      routes: {
        '/login': (context) => SignInPage(),
        '/register': (context) => RegisterPage(),
        '/score': (context) => const ScorePage(),
        '/add_entry': (context) => const AddEntryPage(),
        '/emotion_detail': (context) => const EmotionDetailPage(),
        '/ai_chat': (context) => const AiChatPage(),
        '/statistics': (context) => const StatisticsPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile_edit': (context) => const ProfileEditPage(),
        '/edit_mood': (context) => const EditMoodPage(),
        '/playlist': (context) => const PlaylistPage(),
        '/music_player': (context) => const MusicPlayerPage(),
      },
    );
  }
}
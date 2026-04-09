import 'package:flutter/material.dart';


import 'pages/sign_in_page.dart';
import 'pages/register_page.dart';
import 'pages/score_page.dart';
import 'pages/statistics_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_edit_page.dart';
import 'pages/add_entry_page.dart';


// --- 2. Import Shared Widgets (สีและดีไซน์หลัก) ---
import 'utils/shared_widgets.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodVibe',
      theme: ThemeData(
  
        primaryColor: moodVibeOlive,
        fontFamily: 'Montserrat', 
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false, 
      
     
      initialRoute: '/', 
      routes: {
        '/': (context) => const SignInPage(),               
        '/register': (context) => const RegisterPage(),      
        '/score': (context) => const ScorePage(), 
        '/statistics': (context) => const StatisticsPage(),  
        '/settings': (context) => const SettingsPage(), 
        '/profile_edit': (context) => const ProfileEditPage(), 
        '/add_entry': (context) => const AddEntryPage(),         
      },
    );
  }
}
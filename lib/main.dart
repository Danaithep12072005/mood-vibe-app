import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'pages/sign_in_page.dart';
import 'pages/register_page.dart';
import 'pages/score_page.dart';
import 'pages/statistics_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_edit_page.dart';
import 'pages/add_entry_page.dart';


// --- 2. Import Shared Widgets (สีและดีไซน์หลัก) ---
import 'utils/shared_widgets.dart'; 

void main() async {
  // 1. บอกให้ Flutter เตรียมตัวให้พร้อมก่อนเปิดแอป
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. ปลุก Firebase ให้ตื่นขึ้นมาทำงาน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. สั่งรันแอปพลิเคชันของคุณ
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
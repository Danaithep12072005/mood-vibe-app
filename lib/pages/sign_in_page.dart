import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/shared_widgets.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedBottomClipper(),
              child: Container(
                color: moodVibeOlive,
                height: 320,
                width: double.infinity,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: MoodVibeLogo(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เข้าสู่ระบบ MoodVibe',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    label: 'อีเมล',
                    hint: 'กรอกอีเมลของคุณ',
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    label: 'รหัสผ่าน',
                    hint: 'กรอกรหัสผ่าน...',
                    icon: Icons.lock_outline_rounded,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 45),
                  CustomButton(
                    text: 'เข้าสู่ระบบ',
                    onPressed: () async {
                      // 📍 เรียกใช้ Mock Login
                      bool success = await ApiService.login(emailController.text, passwordController.text);
                      if (success && context.mounted) {
                        Navigator.pushReplacementNamed(context, '/score');
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ยังไม่มีบัญชีใช่ไหม?', style: TextStyle(color: moodVibeDarkBrown)),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('สมัครสมาชิก', style: TextStyle(color: moodVibeAccent, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: moodVibeDarkBrown,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const CustomTextField(
                    label: 'อีเมล',
                    hint: 'กรอกอีเมลของคุณ',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 25),
                  const CustomTextField(
                    label: 'รหัสผ่าน',
                    hint: 'กรอกรหัสผ่าน...',
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 45),
                  CustomButton(
                    text: 'เข้าสู่ระบบ',
                    onPressed: () {
                      // เมื่อกดเข้าสู่ระบบ ให้แทนที่หน้านี้ด้วยหน้า Score
                      Navigator.pushReplacementNamed(context, '/score');
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ยังไม่มีบัญชีใช่ไหม?',
                        style: TextStyle(color: moodVibeDarkBrown),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          // นำทางไปหน้าสมัครสมาชิก
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                            color: moodVibeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
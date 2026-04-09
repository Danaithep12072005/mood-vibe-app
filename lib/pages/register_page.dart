import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                child: Stack(
                  children: [
                    // ปุ่มย้อนกลับ (Back Button)
                    Positioned(
                      top: 50,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: moodVibeCream),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: MoodVibeLogo(),
                      ),
                    ),
                  ],
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
                    'สมัครสมาชิกใหม่',
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
                    text: 'สมัครสมาชิก',
                    onPressed: () {
                      // สมมติว่าสมัครเสร็จแล้ว นำทางไปหน้า Score
                      Navigator.pushNamedAndRemoveUntil(context, '/score', (route) => false);
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'มีบัญชีอยู่แล้วใช่ไหม?',
                        style: TextStyle(color: moodVibeDarkBrown),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          // ย้อนกลับไปหน้าล็อกอิน
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'เข้าสู่ระบบ',
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
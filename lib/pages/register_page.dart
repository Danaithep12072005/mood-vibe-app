import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  // 📍 แก้ไข 1: ลบคำว่า const ออกจากบรรทัดนี้
  RegisterPage({super.key}); 

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
                  // 📍 แก้ไข 2: เพิ่ม controller เข้าไปผูกกับกล่องข้อความ
                  CustomTextField(
                    label: 'อีเมล',
                    hint: 'กรอกอีเมลของคุณ',
                    icon: Icons.email_outlined,
                    controller: emailController, 
                  ),
                  const SizedBox(height: 25),
                  // 📍 แก้ไข 3: เพิ่ม controller เข้าไปผูกกับกล่องข้อความ
                  CustomTextField(
                    label: 'รหัสผ่าน',
                    hint: 'กรอกรหัสผ่าน...',
                    icon: Icons.lock_outline_rounded,
                    controller: passwordController, 
                  ),
                  const SizedBox(height: 45),
                  // 📍 แก้ไข 4: ใส่ระบบ Firebase ลงในปุ่มสมัครสมาชิก
                  CustomButton(
                    text: 'สมัครสมาชิก',
                    onPressed: () async {
                      try {
                        // สั่งให้ Firebase สร้างบัญชีใหม่
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        
                        // สมัครเสร็จแล้ว นำทางไปหน้า Score
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/score', (route) => false);
                        }

                      } on FirebaseAuthException catch (e) {
                        // ถ้าเกิด Error (เช่น อีเมลซ้ำ) ให้มีแถบแจ้งเตือนเด้งขึ้นมา
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.message}')),
                          );
                        }
                      }
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
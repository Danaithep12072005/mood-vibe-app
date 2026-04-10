import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key}); // ลบ const ออกแล้ว
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
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: moodVibeDarkBrown,
                    ),
                  ),
                  const SizedBox(height: 35),
                  // 📍 ผูก Controller กับกล่องอีเมล
                  CustomTextField(
                    label: 'อีเมล',
                    hint: 'กรอกอีเมลของคุณ',
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  const SizedBox(height: 25),
                  // 📍 ผูก Controller กับกล่องรหัสผ่าน
                  CustomTextField(
                    label: 'รหัสผ่าน',
                    hint: 'กรอกรหัสผ่าน...',
                    icon: Icons.lock_outline_rounded,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 45),
                  // 📍 ใส่ระบบ Firebase ในปุ่มกด
                  CustomButton(
                    text: 'เข้าสู่ระบบ',
                    onPressed: () async {
                      try {
                        // 1. สั่งให้ Firebase ตรวจสอบอีเมลและรหัสผ่าน
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        // 2. ถ้าล็อคอินผ่าน ให้แทนที่หน้านี้ด้วยหน้า Score
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/score');
                        }
                      } on FirebaseAuthException catch (e) {
                        // 3. ถ้า Error ให้เปลี่ยนข้อความเป็นภาษาไทยที่เข้าใจง่าย
                        if (context.mounted) {
                          String errorMessage =
                              'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';

                          // เช็ครหัส Error จาก Firebase แล้วแปลเป็นไทย
                          if (e.code == 'invalid-email') {
                            errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
                          } else if (e.code == 'user-not-found') {
                            errorMessage =
                                'ไม่พบอีเมลนี้ในระบบ โปรดสมัครสมาชิก';
                          } else if (e.code == 'wrong-password') {
                            errorMessage = 'รหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง';
                          } else if (e.code == 'invalid-credential') {
                            errorMessage = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
                          } else if (e.code == 'too-many-requests') {
                            errorMessage =
                                'คุณพยายามเข้าสู่ระบบบ่อยเกินไป โปรดรอสักครู่';
                          }

                          // แสดงแถบแจ้งเตือนด้านล่าง
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage,
                                style: const TextStyle(fontSize: 14),
                              ),
                              backgroundColor: Colors
                                  .redAccent, // แอบเติมสีแดงให้ดูเป็นแจ้งเตือน Error
                              behavior: SnackBarBehavior
                                  .floating, // ให้แถบเด้งลอยขึ้นมาสวยๆ
                            ),
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

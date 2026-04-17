import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/shared_widgets.dart';

class RegisterPage extends StatelessWidget {
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
                    Positioned(
                      top: 50, left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: moodVibeCream),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Padding(padding: EdgeInsets.only(top: 80), child: MoodVibeLogo()),
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
                  const Text('สมัครสมาชิกใหม่', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
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
                    hint: 'ตั้งรหัสผ่าน (อย่างน้อย 6 ตัว)...',
                    icon: Icons.lock_outline_rounded,
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 45),
                  CustomButton(
                    text: 'สมัครสมาชิก',
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'), backgroundColor: Colors.orange),
                        );
                        return;
                      }

                      bool success = await ApiService.register(email, password);
                      
                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('สมัครสมาชิกสำเร็จ!'), backgroundColor: Colors.green),
                        );
                        Navigator.pushNamedAndRemoveUntil(context, '/score', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('สมัครไม่สำเร็จ กรุณาตรวจสอบอีเมลและรหัสผ่าน'), backgroundColor: Colors.redAccent),
                        );
                      }
                    },
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
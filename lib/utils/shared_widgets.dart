import 'package:flutter/material.dart';

// กำหนดค่าสีคงที่
const Color moodVibeOlive = Color(0xFFA4A972);
const Color moodVibeCream = Color(0xFFFDFCF1);
const Color moodVibeDarkBrown = Color(0xFF533B2B);
const Color moodVibeAccent = Color(0xFFE58B5E);

// วิดเจ็ตสำหรับช่องป้อนข้อมูล (Input Field)
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: moodVibeDarkBrown,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: moodVibeCream,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // 📍 แก้ไขจุดนี้
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: moodVibeDarkBrown.withValues(alpha: 0.5)), // 📍 แก้ไขจุดนี้
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: moodVibeDarkBrown.withValues(alpha: 0.4), // 📍 แก้ไขจุดนี้
                        fontSize: 16),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: moodVibeDarkBrown, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// วิดเจ็ตสำหรับปุ่มกด (Button)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: moodVibeDarkBrown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

// วิดเจ็ตสำหรับสร้างส่วนโค้งด้านบน
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// วิดเจ็ตโลโก้ MoodVibe
class MoodVibeLogo extends StatelessWidget {
  const MoodVibeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://moodvibe.app/images/moodvibe_logo.png',
      height: 60,
      color: moodVibeCream,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.spa, color: moodVibeCream, size: 60),
    );
  }
}
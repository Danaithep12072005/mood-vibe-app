import 'package:flutter/material.dart';

const Color moodVibeOlive = Color(0xFFA4A972);
const Color moodVibeCream = Color(0xFFFDFCF1);
const Color moodVibeDarkBrown = Color(0xFF533B2B);
const Color moodVibeAccent = Color(0xFFE58B5E);

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: moodVibeDarkBrown, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: moodVibeDarkBrown.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: moodVibeOlive),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: isPassword,
                  decoration: InputDecoration(hintText: hint, border: InputBorder.none),
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: moodVibeDarkBrown.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: moodVibeDarkBrown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          minimumSize: const Size(double.infinity, 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}

class MoodVibeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const MoodVibeBottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;
    switch (index) {
      case 0: Navigator.pushReplacementNamed(context, '/score'); break;
      case 1: Navigator.pushReplacementNamed(context, '/ai_chat'); break;
      case 2: Navigator.pushReplacementNamed(context, '/statistics'); break;
      case 3: Navigator.pushReplacementNamed(context, '/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home_rounded, color: selectedIndex == 0 ? moodVibeDarkBrown : Colors.grey.shade400, size: 30), onPressed: () => _onItemTapped(context, 0)),
            IconButton(icon: Icon(Icons.chat_bubble_rounded, color: selectedIndex == 1 ? moodVibeDarkBrown : Colors.grey.shade400, size: 28), onPressed: () => _onItemTapped(context, 1)),
            const SizedBox(width: 48),
            IconButton(icon: Icon(Icons.bar_chart_rounded, color: selectedIndex == 2 ? moodVibeDarkBrown : Colors.grey.shade400, size: 30), onPressed: () => _onItemTapped(context, 2)),
            IconButton(icon: Icon(Icons.person_rounded, color: selectedIndex == 3 ? moodVibeDarkBrown : Colors.grey.shade400, size: 30), onPressed: () => _onItemTapped(context, 3)),
          ],
        ),
      ),
    );
  }
}

class MoodVibeAddButton extends StatelessWidget {
  const MoodVibeAddButton({super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: moodVibeOlive,
      elevation: 4,
      onPressed: () => Navigator.pushNamed(context, '/add_entry'),
      child: const Icon(Icons.add, color: Colors.white, size: 35),
    );
  }
}

class MoodVibeLogo extends StatelessWidget {
  const MoodVibeLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.spa_rounded, color: moodVibeCream, size: 70);
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
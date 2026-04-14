import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class MusicPlayerPage extends StatelessWidget {
  final String trackName;
  final String artistName;
  final String imageUrl;
  final String? previewUrl;

  const MusicPlayerPage({
    super.key, 
    required this.trackName, 
    required this.artistName, 
    required this.imageUrl,
    this.previewUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeOlive,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.music_off, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "โหมดทดสอบ Minimal Test",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "ปิดระบบเสียงชั่วคราวเพื่อทดสอบ Firebase\nถ้าคุณเข้ามาถึงหน้านี้ได้... แปลว่าแอปรันผ่านแล้ว 100%!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
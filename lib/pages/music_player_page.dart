import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/shared_widgets.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});
  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late YoutubePlayerController _controller;
  String songTitle = 'กำลังโหลด...';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      songTitle = args['title'] ?? 'เพลงแนะนำ';
      String videoId = args['youtubeId'] ?? 'dQw4w9WgXcQ'; // รับ ID มาเล่นวิดีโอ
      
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeDarkBrown,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)), const SizedBox(width: 15), const Text('กลับสู่เพลย์ลิสต์', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
            ),
            const SizedBox(height: 20),
            // แสดงผลวิดีโอ YouTube ในหน้าเล่นเพลง
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(songTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const Spacer(),
            const Icon(Icons.spa_rounded, color: Colors.white54, size: 50),
            const SizedBox(height: 10),
            const Text('MoodVibe กำลังเล่นเพลงฮีลใจให้คุณ...', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
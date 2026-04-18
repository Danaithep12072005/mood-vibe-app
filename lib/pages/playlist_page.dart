import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import '../utils/shared_widgets.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Map<String, String>> _songs = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchYoutubeTracks();
  }

  Future<void> _fetchYoutubeTracks() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String? playlistId = args?['playlistId'];
    
    if (playlistId != null) {
      // เรียกใช้ YoutubeService เพื่อดึงข้อมูลวิดีโอ
      final tracks = await YoutubeService.getPlaylistItems(playlistId);
      if (mounted) {
        setState(() {
          _songs = tracks;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: moodVibeOlive))
        : Column(
            children: [
              _buildHeader(args),
              Expanded(
                child: _songs.isEmpty 
                  ? const Center(child: Text('ไม่พบวิดีโอในเพลย์ลิสต์นี้'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: _songs.length,
                      itemBuilder: (context, index) => _buildSongCard(_songs[index]),
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? args) {
    return Container(
      width: double.infinity, // 🟢 เพิ่มบรรทัดนี้เพื่อบังคับให้กรอบกว้างเต็มจอเสมอ
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
      decoration: const BoxDecoration(
        color: moodVibeDarkBrown, 
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40), 
          bottomRight: Radius.circular(40)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), 
            onPressed: () => Navigator.pop(context)
          ),
          const SizedBox(height: 20),
          Text(
            args?['name'] ?? 'เพลย์ลิสต์แนะนำ', 
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
          ),
          Text(
            args?['description'] ?? '', 
            style: const TextStyle(color: Colors.white70)
          ),
        ],
      ),
    );
  }

  Widget _buildSongCard(Map<String, String> song) {
    return GestureDetector(
      // ส่งข้อมูลเพลงไปหน้า Music Player
      onTap: () => Navigator.pushNamed(context, '/music_player', arguments: song), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10), 
              child: Image.network(song['image']!, width: 50, height: 50, fit: BoxFit.cover)
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(song['title']!, style: const TextStyle(fontWeight: FontWeight.bold)), 
                  Text(song['artist']!, style: const TextStyle(color: Colors.grey, fontSize: 12))
                ]
              )
            ),
            const Icon(Icons.play_circle_fill, color: moodVibeOlive, size: 30),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/foundation.dart'; // 📍 ต้องเพิ่มบรรทัดนี้เพื่อใช้ debugPrint
// import 'package:spotify/spotify.dart';

// class SpotifyService {
//   static const String _clientId = '9bb2e948d466408198adf1e456511a59';
//   static const String _clientSecret = '8edcd623047d43dcaa53d1c236244aa8';

//   static SpotifyApi? _spotifyApi;

//   static void initialize() {
//     final credentials = SpotifyApiCredentials(_clientId, _clientSecret);
//     _spotifyApi = SpotifyApi(credentials);
//   }

//   static Future<Track?> searchMoodTrack(String mood) async {
//     if (_spotifyApi == null) {
//       initialize();
//     }

//     String searchQuery = 'lofi chill'; 
//     if (mood == 'SAD') searchQuery = 'sad thai songs';
//     if (mood == 'STRESS') searchQuery = 'relaxing piano';
//     if (mood == 'CHILL') searchQuery = 'acoustic chill';
//     if (mood == 'HAPPY') searchQuery = 'happy hits';

//     try {
//       // 📍 ระบุประเภทการค้นหาให้ชัดเจน (เช่น ค้นหาเฉพาะเพลง/Track)
//       final searchResult = await _spotifyApi!.search.get(searchQuery).first(1);
      
//       for (var pages in searchResult) {
//         // ✅ ตรวจสอบว่าเป็นผลลัพธ์จาก Tracks หรือไม่
//         if (pages is Iterable<Track> && pages.isNotEmpty) {
//            return pages.first;
//         }
//       }
//     } catch (e) {
//       debugPrint('🔴 Spotify Error: $e');
//     }
// }
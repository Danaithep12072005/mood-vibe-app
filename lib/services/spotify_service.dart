import 'package:spotify/spotify.dart';

class SpotifyService {
  // 📍 เอารหัสจากหน้า Settings เมื่อกี้มาวางตรงนี้ครับ
  static const String _clientId = '9bb2e948d466408198adf1e456511a59';
  static const String _clientSecret = '8edcd623047d43dcaa53d1c236244aa8';

  static SpotifyApi? _spotifyApi;

  static void initialize() {
    final credentials = SpotifyApiCredentials(_clientId, _clientSecret);
    _spotifyApi = SpotifyApi(credentials);
  }

  // ฟังก์ชันค้นหาเพลงตามอารมณ์ที่ AI วิเคราะห์ได้
  static Future<Track?> searchMoodTrack(String mood) async {
    if (_spotifyApi == null) initialize();

    String searchQuery = 'lofi chill'; 
    if (mood == 'SAD') searchQuery = 'sad thai songs';
    if (mood == 'STRESS') searchQuery = 'relaxing piano';
    if (mood == 'CHILL') searchQuery = 'acoustic chill';
    if (mood == 'HAPPY') searchQuery = 'happy hits';

    try {
      final searchResult = await _spotifyApi!.search.get(searchQuery).first(1);
      for (var pages in searchResult) {
        if (pages.items != null && pages.items!.isNotEmpty) {
          return pages.items!.first as Track;
        }
      }
    } catch (e) {
      print('🔴 Spotify Error: $e');
    }
    return null;
  }
}
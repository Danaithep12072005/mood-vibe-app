import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  // ⚠️ เอา API Key ที่ก๊อปมาแปะตรงนี้ครับ
  static const String apiKey = 'AIzaSyCy3DFt52ABQCH43blOEruLJ9vQjz8HgVM'; 

  static Future<List<Map<String, String>>> getPlaylistItems(String playlistId) async {
    final String url = 
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=$playlistId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, String>> tracks = [];

        for (var item in data['items']) {
          final snippet = item['snippet'];
          tracks.add({
            'title': snippet['title'] ?? 'Unknown Title',
            'artist': snippet['videoOwnerChannelTitle'] ?? 'YouTube Artist',
            'image': snippet['thumbnails']['high']['url'] ?? '',
            'youtubeId': snippet['resourceId']['videoId'], // ID สำหรับกดเข้าไปเล่น
          });
        }
        return tracks;
      }
    } catch (e) {
      print('YouTube API Error: $e');
    }
    return [];
  }
}
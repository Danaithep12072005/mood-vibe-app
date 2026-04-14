import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // 📍 สูตรลับ 10.0.2.2 ทะลุ Emulator ไปหาพอร์ต 3000 ของ Node.js
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // 🌟 ฟังก์ชันดึงข้อมูลอารมณ์ทั้งหมด
  static Future<List<dynamic>> fetchMoods() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/moods'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('พังจ้า โค้ด: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้: $e');
      return [];
    }
  }

  // 🌟 ฟังก์ชันบันทึกข้อมูลอารมณ์ (ยิงไปหา Node.js)
  static Future<bool> saveMood(int moodIndex, String topic, String detail) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/moods'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mood_index': moodIndex,
          'topic': topic,
          'detail': detail,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('บันทึกข้อมูลไม่ได้: $e');
      return false; // ถึง Error ก็ไม่เป็นไร ให้ผ่านไปหน้าต่อไปได้
    }
  }

  // 🌟 ฟังก์ชันจำลอง Login (Mock Auth)
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // หน่วงเวลาให้ดูสมจริง
    return true; // บังคับให้ล็อกอินผ่านเสมอสำหรับการทดสอบ UI
  }

  // 🌟 ฟังก์ชันจำลอง Register
  static Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
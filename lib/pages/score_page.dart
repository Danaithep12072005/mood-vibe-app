import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/shared_widgets.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _recentMoods = [];
  int _mentalScore = 0;

  final List<Color> moodColors = [
    const Color(0xFF9B8AF4),
    const Color(0xFFFF8B53),
    const Color(0xFF9F7754),
    const Color(0xFFFFCE54),
    const Color(0xFFA0B967),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await ApiService.fetchMoodHistory();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _recentMoods = history.take(7).toList();
        if (_recentMoods.isNotEmpty) {
          _mentalScore = ((_recentMoods.first['mood_index'] as int) + 1) * 20;
        }
      });
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    List<String> months = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    return '${months[date.month - 1]}\n${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: moodVibeOlive,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () => Navigator.pushReplacementNamed(context, '/login')),
                      ]
                    )
                  ),
                  const Text('คะแนนสุขภาพจิตวันนี้', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  _isLoading 
                    ? const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator(color: Colors.white)) 
                    : Text('$_mentalScore', style: const TextStyle(fontSize: 120, color: Colors.white, fontWeight: FontWeight.w300)),
                  Text(_recentMoods.isEmpty ? 'ยินดีต้อนรับ!\nมาเริ่มบันทึกอารมณ์ก้าวแรกกันเถอะ' : 'วันนี้จิตใจของคุณเป็นยังไงบ้าง?', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5)),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
              decoration: const BoxDecoration(color: moodVibeCream, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
              transform: Matrix4.translationValues(0, -40, 0),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text('ประวัติอารมณ์ของคุณ (7 วัน)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                  const SizedBox(height: 20),
                  if (_recentMoods.isEmpty && !_isLoading)
                    const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: Opacity(opacity: 0.3, child: Icon(Icons.face_retouching_natural, size: 100, color: moodVibeDarkBrown)))),
                  ..._recentMoods.map((mood) {
                    int score = ((mood['mood_index'] as int) + 1) * 20;
                    Color mColor = moodColors[mood['mood_index']];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/edit_mood', arguments: mood);
                        _loadData();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                        child: Row(
                          children: [
                            Text(_formatDate(mood['timestamp']), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mood['topic'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: moodVibeDarkBrown), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(mood['detail'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mColor, width: 4)),
                              child: Center(child: Text('$score', style: const TextStyle(fontWeight: FontWeight.bold, color: moodVibeDarkBrown))),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MoodVibeAddButton(),
      bottomNavigationBar: const MoodVibeBottomNavBar(selectedIndex: 0),
    );
  }
}
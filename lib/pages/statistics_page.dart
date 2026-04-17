import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/shared_widgets.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  final List<Map<String, dynamic>> moodConfig = [
    {'icon': Icons.sentiment_very_dissatisfied, 'color': Color(0xFF9B8AF4)}, 
    {'icon': Icons.sentiment_dissatisfied, 'color': Color(0xFFFF8B53)},      
    {'icon': Icons.sentiment_neutral, 'color': Color(0xFF9F7754)},           
    {'icon': Icons.sentiment_satisfied, 'color': Color(0xFFFFCE54)},         
    {'icon': Icons.sentiment_very_satisfied, 'color': Color(0xFFA0B967)},    
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ApiService.fetchMoodHistory();
    if (mounted) {
      setState(() {
        _history = data;
        _isLoading = false;
      });
    }
  }

  Map<String, int?> _getWeeklyMoods() {
    Map<String, int?> weekly = {'จันทร์': null, 'อังคาร': null, 'พุธ': null, 'พฤหัส.': null, 'ศุกร์': null, 'เสาร์': null, 'อาทิตย์': null};
    for (var entry in _history) {
      if (entry['timestamp'] == null) continue;
      DateTime date = entry['timestamp'].toDate();
      List<String> days = ['', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัส.', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
      weekly[days[date.weekday]] ??= entry['mood_index'];
    }
    return weekly;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyMoods = _getWeeklyMoods();
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: moodVibeDarkBrown, width: 1.5)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: moodVibeDarkBrown), onPressed: () => Navigator.pushReplacementNamed(context, '/score'))),
              const SizedBox(height: 20),
              const Text('สถิติอารมณ์', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 8),
              Text('ภาพรวมอารมณ์ของคุณใน 14 วันที่ผ่านมา', style: TextStyle(fontSize: 14, color: moodVibeDarkBrown.withOpacity(0.7))),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: moodVibeOlive, shape: BoxShape.circle)), const SizedBox(width: 6), const Text('อารมณ์บวก', style: TextStyle(fontSize: 12))]), const SizedBox(width: 12), Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: moodVibeAccent, shape: BoxShape.circle)), const SizedBox(width: 6), const Text('อารมณ์ลบ', style: TextStyle(fontSize: 12))])]), const Text('14 วันล่าสุด', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
              const SizedBox(height: 20),
              Container(
                width: double.infinity, height: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: _isLoading ? const Center(child: CircularProgressIndicator()) : _history.isEmpty ? const Center(child: Text('ไม่มีข้อมูลการบันทึก')) : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(14, (index) {
                  double h = (index < _history.length) ? (30.0 + (_history[index]['mood_index'] * 25)) : 20.0;
                  bool isPos = (index < _history.length) ? (_history[index]['mood_index'] >= 3) : true;
                  return Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 12, height: h, decoration: BoxDecoration(color: isPos ? moodVibeOlive : moodVibeAccent, borderRadius: BorderRadius.circular(10))), const SizedBox(height: 8), Container(width: 4, height: 4, decoration: BoxDecoration(color: isPos ? moodVibeOlive : moodVibeAccent, shape: BoxShape.circle))]);
                })),
              ),
              const SizedBox(height: 30),
              const Text('สัดส่วนอารมณ์', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: weeklyMoods.entries.map((e) => Column(children: [Container(width: 35, height: 35, decoration: BoxDecoration(color: e.value != null ? moodConfig[e.value!]['color'].withOpacity(0.2) : Colors.grey.shade200, shape: BoxShape.circle), child: Icon(e.value != null ? moodConfig[e.value!]['icon'] : Icons.circle, size: 20, color: e.value != null ? moodConfig[e.value!]['color'] : Colors.grey.shade400)), const SizedBox(height: 8), Text(e.key, style: const TextStyle(fontSize: 10, color: moodVibeDarkBrown))])).toList()),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MoodVibeAddButton(),
      bottomNavigationBar: const MoodVibeBottomNavBar(selectedIndex: 2),
    );
  }
}
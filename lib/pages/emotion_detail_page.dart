import 'package:flutter/material.dart';
import '../services/api_service.dart'; // 📍 นำเข้า ApiService ของเรา
import '../utils/shared_widgets.dart';

class EmotionDetailPage extends StatefulWidget {
  const EmotionDetailPage({super.key});

  @override
  State<EmotionDetailPage> createState() => _EmotionDetailPageState();
}

class _EmotionDetailPageState extends State<EmotionDetailPage> {
  int selectedMoodIndex = 0; 
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'color': const Color(0xFF9B8AF4), 'icon': Icons.sentiment_very_dissatisfied}, 
    {'color': const Color(0xFFFF8B53), 'icon': Icons.sentiment_dissatisfied},      
    {'color': const Color(0xFF9F7754), 'icon': Icons.sentiment_neutral},           
    {'color': const Color(0xFFFFCE54), 'icon': Icons.sentiment_satisfied},         
    {'color': const Color(0xFFA0B967), 'icon': Icons.sentiment_very_satisfied},    
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) selectedMoodIndex = args;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: moodVibeDarkBrown, width: 1.5)),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: moodVibeDarkBrown),
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.only(right: 2),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text('บันทึกสาเหตุอารมณ์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                ],
              ),
              const SizedBox(height: 40),

              const Text('หัวข้อเรื่องราว', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _topicController, 
                  decoration: InputDecoration(
                    hintText: 'เครียดเรื่องอะไร',
                    hintStyle: TextStyle(color: moodVibeDarkBrown.withValues(alpha: 0.4)),
                    prefixIcon: const Icon(Icons.description_outlined, color: moodVibeDarkBrown),
                    suffixIcon: const Icon(Icons.edit_outlined, color: moodVibeDarkBrown),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  style: const TextStyle(color: moodVibeDarkBrown),
                ),
              ),
              const SizedBox(height: 30),

              const Text('ทบทวนอารมณ์ของคุณ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(moods.length, (index) {
                  bool isSelected = selectedMoodIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMoodIndex = index),
                    child: Container(
                      width: 55, height: 55,
                      decoration: BoxDecoration(
                        color: isSelected ? (moods[index]['color'] as Color).withValues(alpha: 0.3) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Icon(moods[index]['icon'], size: 45, color: moods[index]['color'])),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              const Text('เล่ารายละเอียดให้เราฟังหน่อย...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: moodVibeDarkBrown.withValues(alpha: 0.3)),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _detailController, 
                      maxLines: null, 
                      decoration: InputDecoration(
                        hintText: 'อธิบายความรู้สึกของท่าน',
                        hintStyle: TextStyle(color: moodVibeDarkBrown.withValues(alpha: 0.4)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      style: const TextStyle(color: moodVibeDarkBrown),
                    ),
                    Positioned(bottom: 15, right: 15, child: Icon(Icons.post_add, color: moodVibeDarkBrown.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                  // 📍 ยิง API ผ่าน Node.js ของเรา
                  await ApiService.saveMood(
                    selectedMoodIndex,
                    _topicController.text,
                    _detailController.text,
                  );
                  
                  if (context.mounted) {
                    Navigator.pushNamed(context, '/ai_chat', arguments: {'topic': _topicController.text, 'detail': _detailController.text});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: moodVibeDarkBrown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('กดยืนยันเพื่อวิเคราะห์', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.check, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
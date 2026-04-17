import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/shared_widgets.dart';

class EditMoodPage extends StatefulWidget {
  const EditMoodPage({super.key});
  @override
  State<EditMoodPage> createState() => _EditMoodPageState();
}

class _EditMoodPageState extends State<EditMoodPage> {
  int selectedMoodIndex = 0; 
  String docId = '';
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'color': Color(0xFF9B8AF4), 'icon': Icons.sentiment_very_dissatisfied, 'label': 'รู้สึกแย่มาก'}, 
    {'color': Color(0xFFFF8B53), 'icon': Icons.sentiment_dissatisfied, 'label': 'เศร้า'},      
    {'color': Color(0xFF9F7754), 'icon': Icons.sentiment_neutral, 'label': 'เฉยปกติ'},           
    {'color': Color(0xFFFFCE54), 'icon': Icons.sentiment_satisfied, 'label': 'มีความสุข'},         
    {'color': Color(0xFFA0B967), 'icon': Icons.sentiment_very_satisfied, 'label': 'มีความสุขมากแจ่มใส'},    
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && docId.isEmpty) {
      docId = args['id'] ?? '';
      selectedMoodIndex = args['mood_index'] ?? 0;
      _topicController.text = args['topic'] ?? '';
      _detailController.text = args['detail'] ?? '';
    }
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
                    child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: moodVibeDarkBrown), onPressed: () => Navigator.pop(context)),
                  ),
                  const SizedBox(width: 15),
                  const Text('แก้ไขบันทึกอารมณ์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                ],
              ),
              const SizedBox(height: 40),
              const Text('หัวข้อเรื่องราว', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: TextField(controller: _topicController, decoration: const InputDecoration(hintText: 'วันนี้เครียดเรื่องอะไร...', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), prefixIcon: Icon(Icons.edit_note_rounded, color: moodVibeOlive))),
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
                    child: Column(
                      children: [
                        AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: isSelected ? 1.0 : 0.3, child: Icon(moods[index]['icon'], size: 50, color: moods[index]['color'])),
                        const SizedBox(height: 5),
                        if (isSelected) Container(width: 6, height: 6, decoration: BoxDecoration(color: moods[index]['color'], shape: BoxShape.circle)),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              const Text('เล่ารายละเอียดให้เราฟังหน่อย...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 10),
              Container(
                height: 180,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)),
                child: TextField(controller: _detailController, maxLines: null, decoration: const InputDecoration(hintText: 'อธิบายความรู้สึกของคุณที่นี่...', border: InputBorder.none, contentPadding: EdgeInsets.all(20))),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'บันทึกการแก้ไข',
                onPressed: () async {
                  if (docId.isEmpty) return;
                  bool isUpdated = await ApiService.updateMood(docId, selectedMoodIndex, _topicController.text, _detailController.text);
                  if (mounted && isUpdated) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
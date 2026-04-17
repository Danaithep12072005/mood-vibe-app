import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/shared_widgets.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});
  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isAiTyping = false;
  bool _isInitialMessageSent = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    const apiKey = '';
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'คุณคือ MoodVibe ที่ปรึกษาที่อบอุ่นสำหรับวัยรุ่น ให้คำปรึกษาได้ทุกอารมณ์ไม่ว่าผู้ใช้จะรู้สึกแย่หรือมีความสุข '
        'ตอบให้สั้น กระชับ เป็นกันเอง และให้กำลังใจเสมอ ปิดท้ายด้วยแท็ก: [SAD], [STRESS], [CHILL], [HAPPY], [NORMAL] ตามความเหมาะสม'
      ),
    );
    _chat = _model.startChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialMessageSent) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _isInitialMessageSent = true;
        String prompt = 'วันนี้ฉันรู้สึก "${args['mood']}" เรื่อง "${args['topic']}" รายละเอียดคือ: ${args['detail']}';
        WidgetsBinding.instance.addPostFrameCallback((_) => _sendMessage(autoMessage: prompt));
      }
    }
  }

  Future<void> _sendMessage({String? autoMessage}) async {
    String userText = autoMessage ?? _textController.text;
    if (userText.trim().isEmpty) return;
    if (mounted) {
      setState(() {
        messages.add({'sender': 'user', 'text': userText});
        if (autoMessage == null) _textController.clear();
        isAiTyping = true;
      });
    }
    _scrollToBottom();
    try {
      final response = await _chat.sendMessage(Content.text(userText));
      if (mounted) {
        setState(() {
          isAiTyping = false;
          messages.add({'sender': 'ai', 'text': response.text ?? 'ขอโทษทีเพื่อน ผมมึนไปนิด'});
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isAiTyping = false;
          String errorMsg = e.toString();
          // 📍 ดักจับ Error 503 เซิร์ฟเวอร์เต็ม แล้วเปลี่ยนเป็นภาษาไทย
          if (errorMsg.contains('503') || errorMsg.contains('high demand')) {
            messages.add({'sender': 'ai', 'text': 'ขออภัยด้วยนะเพื่อน 🥺 ตอนนี้มีคนปรึกษา AI เยอะมากๆ จนระบบของ Google คิวเต็มชั่วคราว รบกวนรอสัก 1-2 นาทีแล้วส่งข้อความมาใหม่นะครับ!'});
          } else {
            messages.add({'sender': 'ai', 'text': 'ระบบ AI ขัดข้องชั่วคราว ลองเช็คอินเทอร์เน็ตดูนะ ($e)'});
          }
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new), 
                  onPressed: () => Navigator.pushReplacementNamed(context, '/score')
                ),
                const SizedBox(width: 15),
                const Text('AI วิเคราะห์อารมณ์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (isAiTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) return const Padding(padding: EdgeInsets.all(10), child: Text('MoodVibe กำลังคิด...'));
                final msg = messages[index];
                bool isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: isUser ? moodVibeDarkBrown : Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text(msg['text'], style: TextStyle(color: isUser ? Colors.white : moodVibeDarkBrown, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: TextField(controller: _textController, decoration: InputDecoration(hintText: 'คุยกับเราได้นะ...', filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)), onSubmitted: (_) => _sendMessage())),
                const SizedBox(width: 10),
                IconButton(icon: const Icon(Icons.send_rounded, color: moodVibeOlive, size: 30), onPressed: () => _sendMessage()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
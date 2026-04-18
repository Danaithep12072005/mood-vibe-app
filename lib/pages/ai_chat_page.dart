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

  final Map<String, Map<String, dynamic>> playlistMap = {
    '[VERY_SAD]': {
      'name': 'โอบกอดในวันที่แตกสลาย',
      'playlistId': 'GGHCHAwKfGk&list=OLAK5uy_kHx0--474MDRH9KwxQoSXeGeC-NggpVSs',
      'description': 'สำหรับวันที่ใจพังที่สุด ให้เพลงอยู่เป็นเพื่อนนะ',
    },
    '[SAD]': {
      'name': 'พื้นที่สำหรับคนเศร้า',
      'playlistId': 'OLAK5uy_mIbPWnivfKgExBt_VMFHq0Tdgitoi7ARg', 
      'description': 'ปล่อยใจไปกับทำนองช้าๆ ในวันที่ฝนตกในใจ',
    },
    '[NORMAL]': {
      'name': 'วันธรรมดาที่แสนพิเศษ',
      'playlistId': 'OLAK5uy_k-f6g3eY_7wTIva7v7J4FlJCXo_TJ7amQ',
      'description': 'เพลงฟังสบายๆ เพิ่มพลังงานบวก',
    },
    '[HAPPY]': {
      'name': 'เติมความสดใสให้เต็มร้อย',
      'playlistId': 'OLAK5uy_kdXmVQM5F_m0OlzAqqG_fqJJGHiL4A-nc', 
      'description': 'ดนตรีจังหวะน่ารักๆ สำหรับคนที่มีรอยยิ้ม',
    },
    '[VERY_HAPPY]': {
      'name': 'โลกสดใสแจ่มใสที่สุด',
      'playlistId': 'OLAK5uy_lRytWBMKxAXnL8CPcvcaP15urnSll42ME', 
      'description': 'ดีใจด้วยนะ! มาฉลองความสุขนี้กัน',
    },
  };

  @override
  void initState() {
    super.initState();
    const apiKey = '';
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: Content.system('คุณคือ MoodVibe ที่ปรึกษาที่อบอุ่น กฎ: วิเคราะห์อารมณ์แล้วปิดท้ายด้วย Tag [VERY_SAD], [SAD], [NORMAL], [HAPPY], หรือ [VERY_HAPPY] เพียง 1 อันเสมอ'),
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
        _sendMessage(autoMessage: 'วันนี้ฉันรู้สึก "${args['mood']}" เรื่อง "${args['topic']}": ${args['detail']}');
      }
    }
  }

  Future<void> _sendMessage({String? autoMessage}) async {
    String userText = autoMessage ?? _textController.text;
    if (userText.trim().isEmpty) return;
    
    if (autoMessage == null) {
      _textController.clear();
    }
    
    setState(() { 
      messages.add({'sender': 'user', 'text': userText}); 
      isAiTyping = true; 
    });
    _scrollToBottom();
    
    try {
      final response = await _chat.sendMessage(Content.text(userText));
      setState(() { 
        isAiTyping = false; 
        messages.add({'sender': 'ai', 'text': response.text ?? '...' }); 
      });
      _scrollToBottom();
    } catch (e) { 
      print("🚨 Gemini Error: $e");
      setState(() { 
        isAiTyping = false; 
        messages.add({
          'sender': 'ai', 
          'text': 'ขออภัยค่ะ ระบบ AI ขัดข้องชั่วคราว รบกวนลองอีกครั้งนะคะ\n\n(Error: $e)' 
        }); 
      }); 
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOut
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildChatList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20),
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new), 
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/score', (route) => false)
          ), 
          const SizedBox(width: 15), 
          const Text('AI วิเคราะห์อารมณ์', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
        ]
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: messages.length + (isAiTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) return const Text('MoodVibe กำลังคิด...');
        final msg = messages[index];
        bool isUser = msg['sender'] == 'user';
        String rawText = msg['text'];
        
        String? foundTag;
        for (var tag in playlistMap.keys) { 
          if (rawText.contains(tag)) { foundTag = tag; break; } 
        }
        String displayText = rawText.replaceAll(RegExp(r'\[.*?\]'), '').trim();

        return Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10), 
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isUser ? moodVibeDarkBrown : Colors.white, 
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(displayText, style: TextStyle(color: isUser ? Colors.white : moodVibeDarkBrown)),
            ),
            if (!isUser && foundTag != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moodVibeOlive, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  icon: const Icon(Icons.headphones),
                  label: Text('เปิดเพลย์ลิสต์: ${playlistMap[foundTag]!['name']}'),
                  onPressed: () => Navigator.pushNamed(context, '/playlist', arguments: playlistMap[foundTag]),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20), 
      color: Colors.white, 
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController, 
              decoration: const InputDecoration(hintText: 'คุยกับเราได้นะ...', border: InputBorder.none),
              onSubmitted: (_) => _sendMessage()
            )
          ), 
          IconButton(
            icon: const Icon(Icons.send, color: moodVibeOlive), 
            onPressed: () => _sendMessage()
          )
        ]
      )
    );
  }
}
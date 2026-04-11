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
  bool _isInitialMessageSent = false; // ตัวเช็คว่าเคยส่งข้อความอัตโนมัติไปหรือยัง
  
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    final apiKey = 'AIzaSyDS3FzEsk5HRKcWdGFAXYrKwPFnF3gYWbo'; 

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'คุณคือ MoodVibe ผู้ให้คำปรึกษาด้านสุขภาพจิตใจสำหรับนักศึกษาวัยรุ่น '
        'คุณมีนิสัยอบอุ่น เป็นผู้ฟังที่ดี ไม่ตัดสิน และคอยให้กำลังใจเสมอ ตอบให้สั้น กระชับ เป็นกันเอง เหมือนคุยกับเพื่อน '
        'กฎสำคัญ: ทุกครั้งที่คุณตอบจบ ให้คุณวิเคราะห์ว่าผู้ใช้น่าจะต้องการเพลงแนวไหน แล้วใส่แท็กในวงเล็บเหลี่ยมต่อท้ายข้อความเสมอ '
        'เลือกได้ 4 แท็กนี้เท่านั้น: [SAD], [STRESS], [CHILL], [HAPPY]'
      ),
    );
    _chat = _model.startChat();
  }

  // 📍 2. ฟังก์ชันรับข้อมูลจากหน้าก่อนหน้า พอเปิดหน้านี้ปุ๊บ จะดึงมาเช็คทันที
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // ถ้ายังไม่เคยส่งข้อความอัตโนมัติ ให้ดึงข้อมูลมาส่ง
    if (!_isInitialMessageSent) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (args != null) {
        String topic = args['topic'] ?? '';
        String detail = args['detail'] ?? '';
        
        // ถ้าผู้ใช้มีการพิมพ์หัวข้อหรือรายละเอียดมา
        if (topic.isNotEmpty || detail.isNotEmpty) {
          _isInitialMessageSent = true;
          
          // จัดรูปแบบข้อความที่จะส่งให้ AI
          String prompt = '';
          if (topic.isNotEmpty && detail.isNotEmpty) {
            prompt = 'วันนี้ฉันรู้สึกไม่ค่อยโอเคเรื่อง: "$topic"\nรายละเอียดคือ: $detail';
          } else if (topic.isNotEmpty) {
            prompt = 'วันนี้ฉันรู้สึกไม่ค่อยโอเคเรื่อง: "$topic"';
          } else {
            prompt = 'วันนี้ฉันรู้สึก: $detail';
          }
          
          // รอให้หน้าจอโหลดเสร็จแป๊บนึง แล้วค่อยสั่ง AI พิมพ์อัตโนมัติ
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _sendMessage(autoMessage: prompt);
          });
        }
      }
    }
  }

  // 📍 3. ปรับฟังก์ชันส่งข้อความ ให้รองรับการส่งอัตโนมัติ (autoMessage)
  Future<void> _sendMessage({String? autoMessage}) async {
    // ถ้าเป็นข้อความอัตโนมัติให้ใช้ autoMessage ถ้าพิมพ์เองให้ใช้ _textController
    String userText = autoMessage ?? _textController.text; 
    
    if (userText.trim().isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userText, 'hasMusic': false});
      if (autoMessage == null) _textController.clear(); // ล้างกล่องข้อความเฉพาะตอนพิมพ์เอง
      isAiTyping = true; 
    });

    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(userText));
      String aiText = response.text ?? 'ขออภัยครับ ระบบประมวลผลมีปัญหาเล็กน้อย';
      bool showMusic = false;

      if (aiText.contains('[SAD]') || aiText.contains('[STRESS]') || 
          aiText.contains('[CHILL]') || aiText.contains('[HAPPY]')) {
        showMusic = true;
        aiText = aiText.replaceAll('[SAD]', '').replaceAll('[STRESS]', '')
                       .replaceAll('[CHILL]', '').replaceAll('[HAPPY]', '').trim();
      }

      if (mounted) {
        setState(() {
          isAiTyping = false;
          messages.add({
            'sender': 'ai',
            'text': aiText,
            'hasMusic': showMusic, 
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isAiTyping = false;
          messages.add({'sender': 'ai', 'text': 'ขออภัยครับ ตอนนี้ผมกำลังเชื่อมต่อระบบไม่ได้ ลองตรวจสอบอินเทอร์เน็ตดูนะครับ', 'hasMusic': false});
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20, left: 20, right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Row(
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
                if (index == messages.length && isAiTyping) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _buildAiLoadingMessage(),
                  );
                }

                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: msg['sender'] == 'user'
                      ? _buildUserMessage(msg['text'])
                      : _buildAiMessageWithMusic(msg['text'], showMusic: msg['hasMusic'] ?? false),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'วันนี้อยากเล่าอะไรให้ฟังบ้าง...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50, width: 50,
                  decoration: const BoxDecoration(color: moodVibeOlive, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.subdirectory_arrow_left, color: Colors.white),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: moodVibeDarkBrown,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(0),
              ),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 18, backgroundColor: moodVibeDarkBrown.withOpacity(0.8),
          child: const Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildAiMessageWithMusic(String text, {bool showMusic = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18, backgroundColor: Colors.white,
          child: Icon(Icons.spa, color: moodVibeDarkBrown.withOpacity(0.5), size: 20),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: const Color(0xFFEBE5DF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(color: moodVibeDarkBrown, fontSize: 15, height: 1.4, fontWeight: FontWeight.w600)),
                
                if (showMusic) ...[
                  const SizedBox(height: 15),
                  Container(
                    height: 140, width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1493225457284-0bf53ce815fc?w=500'), fit: BoxFit.cover),
                    ),
                    child: Stack(
                      children: [
                        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(0.3))),
                        const Positioned(
                          top: 15, left: 15,
                          child: Row(children: [Icon(Icons.music_note, color: Colors.white, size: 16), SizedBox(width: 5), Text('เพลย์ลิสต์: ฮีลใจวัยเรียน', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]),
                        ),
                        Center(child: Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.play_arrow, color: moodVibeDarkBrown, size: 30))),
                        Positioned(
                          bottom: 15, left: 15, right: 15,
                          child: Row(
                            children: [
                              const Text('25:00', style: TextStyle(color: Colors.white, fontSize: 10)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 3, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
                                  child: Row(children: [Container(width: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))), Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiLoadingMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.spa, color: moodVibeDarkBrown.withOpacity(0.5), size: 20)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFEBE5DF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('AI กำลังประมวลผล...', style: TextStyle(color: moodVibeDarkBrown, fontSize: 13)),
              const SizedBox(width: 8),
              Row(
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: moodVibeAccent, shape: BoxShape.circle)), const SizedBox(width: 3),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: moodVibeAccent, shape: BoxShape.circle)), const SizedBox(width: 3),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: moodVibeAccent, shape: BoxShape.circle)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
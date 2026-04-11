import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; 
import '../utils/shared_widgets.dart';
// 📍 เพิ่มการ Import Service และหน้าเล่นเพลง
import '../services/spotify_service.dart';
import 'music_player_page.dart';

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
    // 📍 เรียกใช้งาน Spotify Service ตั้งแต่เริ่มหน้าหน้าจอ
    SpotifyService.initialize();

    final apiKey = 'AIzaSyC7HK2fQo0FFhtp4ESXlLTALC-phezeuaY'; 

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialMessageSent) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        String topic = args['topic'] ?? '';
        String detail = args['detail'] ?? '';
        
        if (topic.isNotEmpty || detail.isNotEmpty) {
          _isInitialMessageSent = true;
          String prompt = '';
          if (topic.isNotEmpty && detail.isNotEmpty) {
            prompt = 'วันนี้ฉันรู้สึกไม่ค่อยโอเคเรื่อง: "$topic"\nรายละเอียดคือ: $detail';
          } else if (topic.isNotEmpty) {
            prompt = 'วันนี้ฉันรู้สึกไม่ค่อยโอเคเรื่อง: "$topic"';
          } else {
            prompt = 'วันนี้ฉันรู้สึก: $detail';
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _sendMessage(autoMessage: prompt);
          });
        }
      }
    }
  }

  Future<void> _sendMessage({String? autoMessage}) async {
    String userText = autoMessage ?? _textController.text; 
    if (userText.trim().isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': userText, 'hasMusic': false, 'musicTag': ''});
      if (autoMessage == null) _textController.clear(); 
      isAiTyping = true; 
    });

    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(userText));
      String aiText = response.text ?? 'ขออภัยครับ ระบบประมวลผลมีปัญหาเล็กน้อย';
      
      String detectedTag = '';
      if (aiText.contains('[SAD]')) detectedTag = 'SAD';
      else if (aiText.contains('[STRESS]')) detectedTag = 'STRESS';
      else if (aiText.contains('[CHILL]')) detectedTag = 'CHILL';
      else if (aiText.contains('[HAPPY]')) detectedTag = 'HAPPY';

      bool showMusic = detectedTag.isNotEmpty;

      if (showMusic) {
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
            'musicTag': detectedTag, 
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('🔴 AI Error: $e'); 

      if (mounted) {
        setState(() {
          isAiTyping = false;
          messages.add({
            'sender': 'ai', 
            'text': 'ขออภัยครับ ตอนนี้ผมกำลังเชื่อมต่อระบบไม่ได้ ลองตรวจสอบอินเทอร์เน็ตดูนะครับ', 
            'hasMusic': false, 
            'musicTag': ''
          });
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
                      : _buildAiMessageWithMusic(msg['text'], showMusic: msg['hasMusic'] ?? false, musicTag: msg['musicTag'] ?? ''),
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

  Widget _buildAiMessageWithMusic(String text, {bool showMusic = false, String musicTag = ''}) {
    
    // 📍 ข้อมูลเบื้องต้นสำหรับโชว์ใน Chat (รูปภาพยังใช้ของเดิมได้ครับ)
    Map<String, Map<String, String>> uiDisplayData = {
      'SAD': {
        'title': 'Sad Indie (เศร้า)',
        'image': 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=500', 
      },
      'STRESS': {
        'title': 'Peaceful Piano (ผ่อนคลาย)',
        'image': 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=500', 
      },
      'CHILL': {
        'title': 'Chill Vibes (ชิลล์ๆ)',
        'image': 'https://images.unsplash.com/photo-1529156069898-49953eb1b5ae?w=500', 
      },
      'HAPPY': {
        'title': 'Mood Booster (สดใส)',
        'image': 'https://images.unsplash.com/photo-1534152815023-e6ebecf5eb9f?w=500', 
      },
    };

    final displayInfo = uiDisplayData[musicTag] ?? {
      'title': 'เพลงโปรดของคุณ',
      'image': 'https://images.unsplash.com/photo-1493225457284-0bf53ce815fc?w=500',
    };

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
                  // 📍 ปรับปรุงส่วนการกด (OnTap) เพื่อไปยังหน้า MusicPlayerPage
                  GestureDetector(
                    onTap: () async {
  // 1. แจ้งเตือนผู้ใช้นิดนึงว่ากำลังโหลดเพลง
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('กำลังเตรียมเพลงฮีลใจให้คุณ...'), duration: Duration(seconds: 1)),
  );

  // 2. ไปดึงข้อมูลเพลงจริงจาก Spotify ผ่าน Service ที่เราสร้างไว้
  final track = await SpotifyService.searchMoodTrack(musicTag);

  if (track != null && mounted) {
    // 3. ถ้าเจอเพลง ให้เด้งไปหน้าเครื่องเล่นเพลงสีเขียวทันที
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(
          trackName: track.name ?? 'Unknown Track',
          artistName: track.artists?.first.name ?? 'Unknown Artist',
          imageUrl: track.album?.images?.first.url ?? displayInfo['image']!,
          previewUrl: track.previewUrl, // 🎵 ส่งลิงก์เสียงไปเล่นในเครื่อง
        ),
      ),
    );
  } else {
    // กรณีที่หาเพลงไม่เจอ หรือ API มีปัญหา
    print('🔴 ไม่พบเพลงจาก Spotify หรือลืมใส่ Client ID/Secret');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ขออภัยครับ ไม่สามารถโหลดเพลงได้ในขณะนี้')),
    );
  }
},
                    child: Container(
                      height: 140, width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: NetworkImage(displayInfo['image']!), fit: BoxFit.cover),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))],
                      ),
                      child: Stack(
                        children: [
                          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(0.4))),
                          Positioned(
                            top: 15, left: 15, right: 15,
                            child: Row(children: [
                              const Icon(Icons.headphones, color: Colors.white, size: 16), 
                              const SizedBox(width: 5), 
                              Expanded(
                                child: Text(
                                  'AI แนะนำ: ${displayInfo['title']}', 
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10), 
                              decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle), 
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 30)
                            )
                          ),
                          Positioned(
                            bottom: 15, left: 15, right: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('แตะเพื่อเริ่มฟังเพลงฮีลใจ', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
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
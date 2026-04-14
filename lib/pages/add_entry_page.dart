import 'package:flutter/material.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  // สร้าง Controller สำหรับจัดการการเลื่อนหน้าจอ
  final PageController _pageController = PageController(initialPage: 0); // เริ่มต้นที่หน้าแรก (index 0)
  int currentIndex = 0;

  // ข้อมูลอารมณ์ทั้ง 5 แบบ (สี, ข้อความ, ไอคอน)
  final List<Map<String, dynamic>> moods = [
    {
      'label': 'รู้สึกแย่มาก',
      'color': const Color(0xFF9B8AF4), // สีม่วง
      'icon': Icons.sentiment_very_dissatisfied,
    },
    {
      'label': 'รู้สึกเศร้า',
      'color': const Color(0xFFFF8B53), // สีส้ม
      'icon': Icons.sentiment_dissatisfied,
    },
    {
      'label': 'รู้สึกเฉยๆ',
      'color': const Color(0xFF9F7754), // สีน้ำตาล
      'icon': Icons.sentiment_neutral,
    },
    {
      'label': 'รู้สึกมีความสุข',
      'color': const Color(0xFFFFCE54), // สีเหลือง
      'icon': Icons.sentiment_satisfied,
    },
    {
      'label': 'รู้สึกแจ่มใสมาก',
      'color': const Color(0xFFA0B967), // สีเขียว
      'icon': Icons.sentiment_very_satisfied,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: moods[currentIndex]['color'],
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: SafeArea(
          child: Column(
            children: [
              // ปุ่มปิด (X) มุมซ้ายบน
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ข้อความทักทาย
              const Text(
                '👋 สวัสดี!',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'วันนี้คุณรู้สึกอย่างไรบ้าง?',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 40),
              
              // ส่วนที่ให้ปัดซ้าย-ขวา (PageView)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index; // อัปเดต index เมื่อมีการเลื่อนหน้า
                    });
                  },
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    return _buildMoodFace(moods[index]);
                  },
                ),
              ),
              
              // ส่วนล่าง: ตัวบอกสถานะแบบโค้ง และปุ่มถัดไป
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  children: [
                    _buildCurvedIndicator(),
                    const SizedBox(height: 50),
                    
                    // --- ปุ่ม "ถัดไป" / "บันทึก" ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: moods[currentIndex]['color'], // สีตัวหนังสือเปลี่ยนตามพื้นหลัง
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // เช็คว่าถ้ายังไม่ถึงหน้าสุดท้าย ให้เลื่อนไปหน้าถัดไป
                        if (currentIndex < moods.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // ถ้าอยู่หน้าสุดท้ายแล้ว (index 4 สีเขียว) ให้เปลี่ยนหน้าไปหน้าบันทึกสาเหตุอารมณ์
                          Navigator.pushNamed(
                            context, 
                            '/emotion_detail',
                            arguments: currentIndex, // ส่งค่าอารมณ์ไปด้วย
                          );
                        }
                      },
                      child: Text(
                        // ถ้าอยู่หน้าสุดท้าย ให้ปุ่มเปลี่ยนเป็นคำว่า "เริ่มบันทึก" แทน
                        currentIndex == moods.length - 1 ? 'เริ่มบันทึกอารมณ์' : 'ถัดไป',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สร้างใบหน้าอารมณ์ตรงกลาง
  Widget _buildMoodFace(Map<String, dynamic> mood) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15), // 📍 เปลี่ยนจาก withOpacity เป็น withValues // วงกลมพื้นหลังโปร่งแสง
            shape: BoxShape.circle,
          ),
          child: Icon(
            mood['icon'],
            size: 100,
            color: Colors.black.withValues(alpha: 0.6), // สีหน้าไอคอน
          ),
        ),
        const SizedBox(height: 30),
        Text(
          mood['label'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget สร้างจุดวงกลมแบบโค้ง (Indicator)
  Widget _buildCurvedIndicator() {
    // กำหนดความสูง (Y-offset) ของแต่ละจุด เพื่อให้เกิดรูปทรงโค้ง
    final List<double> yOffsets = [0, 15, 25, 15, 0];

    return SizedBox(
      height: 40, // ความสูงเผื่อความโค้ง
      child: Stack(
        alignment: Alignment.center,
        children: [
          // เส้นประด้านหลัง (จำลองด้วยกล่องยาวๆ โปร่งแสง)
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            color: Colors.black.withValues(alpha: 0.1),
          ),
          // จุดวงกลมทั้ง 5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(moods.length, (index) {
              bool isActive = index <= currentIndex; // จุดที่ผ่านมาแล้วให้เป็นสีขาว
              
              return Transform.translate(
                offset: Offset(0, yOffsets[index]), // ดันจุดขึ้นลงตามค่าที่ตั้งไว้
                child: GestureDetector(
                  onTap: () {
                    // แตะที่จุดเพื่อเปลี่ยนหน้าทันที
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    // วงกลมเล็กๆ ด้านใน
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? moods[currentIndex]['color'] : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
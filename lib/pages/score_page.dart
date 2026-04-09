import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: moodVibeOlive),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'คะแนนสุขภาพจิตวันนี้',
                          style: TextStyle(
                            fontSize: 22,
                            color: moodVibeCream,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 96,
                            color: moodVibeCream,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'ยินดีต้อนรับ!\nมาเริ่มบันทึกอารมณ์ก้าวแรกกันเถอะ',
                          style: TextStyle(
                            fontSize: 18,
                            color: moodVibeCream,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: moodVibeCream,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text(
                          'ยังไม่มีข้อมูลการบันทึก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: moodVibeDarkBrown,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Image.network(
                          'https://moodvibe.app/images/moodvibe_pixel_face.png',
                          height: 160,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.face_retouching_natural,
                                size: 160,
                                color: Colors.grey,
                              ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ปุ่ม Log out
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: moodVibeCream),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: moodVibeCream,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. เมนูหน้าแรก (Active)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home, color: moodVibeDarkBrown, size: 28),
                    const SizedBox(height: 6),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: const BoxDecoration(
                        color: moodVibeDarkBrown,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                
                // 2. เมนูแชท
                // 2. เมนูแชท
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: moodVibeDarkBrown.withOpacity(0.5),
                    size: 28,
                  ),
                  onPressed: () {
                    // เชื่อมไปหน้า AI Chat ที่เราเพิ่งสร้าง
                    Navigator.pushNamed(context, '/ai_chat'); 
                  },
                ),
                
                const SizedBox(width: 40), // เว้นช่องว่างให้ปุ่มบวก
                
                // 3. เมนูสถิติ (กดแล้วไปหน้า Statistics)
                IconButton(
                  icon: Icon(
                    Icons.analytics_outlined,
                    color: moodVibeDarkBrown.withOpacity(0.5),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/statistics');
                  },
                ),
                
                // 4. เมนูโปรไฟล์/ตั้งค่า (กดแล้วไปหน้า Settings)
                IconButton(
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: moodVibeDarkBrown.withOpacity(0.5),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
          
          // ปุ่มบวก (+) เปลี่ยนหน้าไปยัง Add Entry Page
          Positioned(
            top: -20,
            child: FloatingActionButton(
              onPressed: () {
                // เชื่อมไปยังหน้าบันทึกอารมณ์ที่คุณเพิ่งสร้าง
                Navigator.pushNamed(context, '/add_entry'); 
              },
              backgroundColor: moodVibeOlive,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
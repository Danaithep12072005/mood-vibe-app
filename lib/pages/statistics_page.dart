import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ปุ่มย้อนกลับ
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: moodVibeDarkBrown, width: 1.5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: moodVibeDarkBrown),
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.only(right: 2),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'สถิติอารมณ์',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: moodVibeDarkBrown),
              ),
              const SizedBox(height: 8),
              Text(
                'ภาพรวมอารมณ์ของคุณใน 14 วันที่ผ่านมา',
                style: TextStyle(fontSize: 14, color: moodVibeDarkBrown.withValues(alpha: 0.7)), // 📍 แก้ไขจุดนี้
              ),
              const SizedBox(height: 20),
              
              // Filter ย้อนหลัง 14 วัน
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: moodVibeOlive, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('อารมณ์บวก', style: TextStyle(color: moodVibeDarkBrown, fontSize: 12)),
                      const SizedBox(width: 12),
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: moodVibeAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('อารมณ์ลบ', style: TextStyle(color: moodVibeDarkBrown, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05), // 📍 แก้ไขจุดนี้
                          blurRadius: 5
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: moodVibeDarkBrown),
                        SizedBox(width: 6),
                        Text('14 วันล่าสุด', style: TextStyle(color: moodVibeDarkBrown, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // กล่องกราฟ (สถานะว่างเปล่า)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05), // 📍 แก้ไขจุดนี้
                      blurRadius: 10, 
                      offset: const Offset(0, 5)
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ไม่มีข้อมูลในขณะนี้', style: TextStyle(color: moodVibeDarkBrown, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    // ไอคอนแว่นขยาย Pixel
                    Image.network(
                      'https://moodvibe.app/images/pixel_search.png', 
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.search, size: 60, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // สัดส่วนอารมณ์
              const Text('สัดส่วนอารมณ์', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัส.', 'ศุกร์', 'เสาร์', 'อาทิตย์'].map((day) {
                  return Column(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                      ),
                      const SizedBox(height: 8),
                      Text(day, style: const TextStyle(fontSize: 10, color: moodVibeDarkBrown)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          decoration: const BoxDecoration(
            color: moodVibeCream,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, 
                spreadRadius: 1, 
                blurRadius: 15, 
                offset: Offset(0, -5)
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home_outlined, color: moodVibeDarkBrown.withValues(alpha: 0.5), size: 28), // 📍 แก้ไขจุดนี้
                onPressed: () => Navigator.pushReplacementNamed(context, '/score')
              ),
              Icon(Icons.chat_bubble_outline_rounded, color: moodVibeDarkBrown.withValues(alpha: 0.5), size: 28), // 📍 แก้ไขจุดนี้
              const SizedBox(width: 40),
              // Analytics Active
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.analytics, color: moodVibeDarkBrown, size: 28),
                  const SizedBox(height: 6),
                  Container(height: 5, width: 5, decoration: const BoxDecoration(color: moodVibeDarkBrown, shape: BoxShape.circle)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.person_outline_rounded, color: moodVibeDarkBrown.withValues(alpha: 0.5), size: 28), // 📍 แก้ไขจุดนี้
                onPressed: () => Navigator.pushNamed(context, '/settings')
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          child: FloatingActionButton(
            onPressed: () {
              // 📍 แนะนำให้เชื่อมไปหน้าบันทึกอารมณ์เหมือนหน้าอื่นๆ
              Navigator.pushNamed(context, '/add_entry');
            },
            backgroundColor: moodVibeOlive,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false; // เก็บสถานะปุ่ม Dark Mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วน Header โค้งสีน้ำตาลเข้ม และ รูปโปรไฟล์
            Stack(
              clipBehavior: Clip.none, // ยอมให้ widget ล้นขอบ Stack ได้
              alignment: Alignment.topCenter,
              children: [
                // 1. พื้นหลังสีน้ำตาลโค้ง
                Container(
                  height: 220, // ลดความสูงลงเล็กน้อย
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: moodVibeDarkBrown,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                
                // 2. ปุ่มย้อนกลับ และ ข้อความ "การตั้งค่า" (จัดให้อยู่ด้านบน)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.all(color: Colors.white, width: 1.5)
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            padding: const EdgeInsets.only(right: 2), // ขยับไอคอนให้ตรงกลางวงกลม
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'การตั้งค่า', 
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 3. รูปโปรไฟล์ (จัดให้อยู่กึ่งกลางรอยต่อ)
                Positioned(
                  bottom: -50, // ดันรูปลงมาครึ่งหนึ่งของขนาดรูป (radius 50)
                  child: Container(
                    padding: const EdgeInsets.all(5), // สร้างขอบสีขาวรอบรูป
                    decoration: const BoxDecoration(
                      color: moodVibeCream, 
                      shape: BoxShape.circle
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            
            // เว้นระยะห่างด้านล่างรูปโปรไฟล์
            const SizedBox(height: 70), 
            
            // ข้อมูลผู้ใช้
            const Text(
              'weeraphat.uth@student.mahidol.edu', 
              style: TextStyle(color: moodVibeDarkBrown, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),
            
            // ส่วนของเมนูการตั้งค่า
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'การตั้งค่าทั่วไป', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)
                  ),
                  const SizedBox(height: 15),
                  
                  // เมนู ข้อมูลส่วนตัว
                  _buildSettingTile(
                    title: 'ข้อมูลส่วนตัว',
                    icon: Icons.person_outline,
                    onTap: () => Navigator.pushNamed(context, '/profile_edit'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 15),
                  
                  // เมนู Dark Mode
                  _buildSettingTile(
                    title: 'Dark Mode',
                    icon: Icons.dark_mode_outlined,
                    onTap: () {},
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: moodVibeOlive,
                      onChanged: (value) {
                        setState(() { isDarkMode = value; });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // เมนู Log Out
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Log Out', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)
                      ),
                      Icon(Icons.more_vert, size: 18, color: moodVibeDarkBrown.withOpacity(0.5)), // ไอคอน 3 จุด
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'Log Out',
                    icon: Icons.logout,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 40), // เว้นระยะล่างสุด
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // วิดเจ็ตปุ่มตั้งค่า (ใช้ซ้ำได้)
  Widget _buildSettingTile({required String title, required IconData icon, required Widget trailing, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // ปรับให้โค้งน้อยลงเหมือนในรูป
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 10, 
              offset: const Offset(0, 5)
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: moodVibeDarkBrown),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: moodVibeDarkBrown)
              )
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
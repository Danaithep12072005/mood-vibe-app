import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/shared_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String userEmail = 'กำลังโหลดข้อมูล...'; 
  String? githubAvatarUrl; // 📍 ตัวแปรเก็บ URL รูปจาก GitHub

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); 
  }

  void _loadUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? 'ไม่มีข้อมูลอีเมล (ไม่ได้ล็อกอิน)';
    });
  }

  // 📍 ฟังก์ชันเด้งกล่องให้กรอกชื่อ GitHub
  void _showGitHubDialog() {
    final TextEditingController githubController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ดึงรูปจาก GitHub', style: TextStyle(color: moodVibeDarkBrown, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: githubController,
            decoration: const InputDecoration(
              hintText: 'ใส่ชื่อ Username (เช่น man00)', // แอบเห็นชื่อโฟลเดอร์ในคอมคุณครับ 😆
              prefixIcon: Icon(Icons.code),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: moodVibeOlive),
              onPressed: () {
                if (githubController.text.isNotEmpty) {
                  setState(() {
                    // สร้าง URL รูปจากชื่อที่พิมพ์
                    githubAvatarUrl = 'https://github.com/${githubController.text.trim()}.png';
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('ตกลง', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: moodVibeDarkBrown,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            padding: const EdgeInsets.only(right: 2),
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text('การตั้งค่า', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                
                // 📍 ปุ่มรูปโปรไฟล์ (กดแล้วกล่อง GitHub เด้ง)
                Positioned(
                  bottom: -50,
                  child: GestureDetector(
                    onTap: _showGitHubDialog, // เรียกฟังก์ชันกรอกชื่อ GitHub
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: moodVibeCream, shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        // ถ้ามี URL ให้โชว์รูปจากเน็ต ถ้าไม่มีให้โชว์ไอคอนคน
                        backgroundImage: githubAvatarUrl != null ? NetworkImage(githubAvatarUrl!) : null,
                        child: githubAvatarUrl == null
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 70), 
            
            Text(
              userEmail, 
              style: const TextStyle(color: moodVibeDarkBrown, fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 30),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('การตั้งค่าทั่วไป', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                  const SizedBox(height: 15),
                  
                  _buildSettingTile(
                    title: 'ข้อมูลส่วนตัว',
                    icon: Icons.person_outline,
                    onTap: () => Navigator.pushNamed(context, '/profile_edit'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 15),
                  
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
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                      Icon(Icons.more_vert, size: 18, color: moodVibeDarkBrown.withOpacity(0.5)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'Log Out',
                    icon: Icons.logout,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      }
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({required String title, required IconData icon, required Widget trailing, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Icon(icon, color: moodVibeDarkBrown),
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: moodVibeDarkBrown))),
            trailing,
          ],
        ),
      ),
    );
  }
}
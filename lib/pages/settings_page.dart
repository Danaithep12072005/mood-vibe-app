import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 📍 1. เพิ่ม Firestore เข้ามา
import '../utils/shared_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String userEmail = 'กำลังโหลดข้อมูล...';
  String? localAvatarPath;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 📍 2. เปลี่ยนมาเรียกฟังก์ชันโหลดข้อมูลทั้งหมด
  }

  // 📍 3. ฟังก์ชันโหลดทั้งอีเมล และ รูปโปรไฟล์จาก Firebase
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'ไม่มีข้อมูลอีเมล';
      });

      // ดึงข้อมูลรูปโปรไฟล์ที่เคยเซฟไว้ในฐานข้อมูลมาแสดง
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('avatarPath')) {
            setState(() {
              localAvatarPath = data['avatarPath'];
            });
          }
        }
      } catch (e) {
        debugPrint("โหลดรูปโปรไฟล์ไม่สำเร็จ: $e");
      }
    }
  }

  void _showAvatarPicker() {
    List<String> avatars = [
      'assets/avatars/images1.jpg',
      'assets/avatars/images2.jpg',
      'assets/avatars/images3.jpg',
      'assets/avatars/images4.jpg',
      'assets/avatars/images5.jpg',
      'assets/avatars/images6.jpg',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'เลือกรูปโปรไฟล์น่ารักๆ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: moodVibeDarkBrown,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        // 1. เปลี่ยนรูปบนหน้าจอทันที
                        setState(() {
                          localAvatarPath = avatars[index];
                        });
                        Navigator.pop(context); // ปิดหน้าต่าง

                        // 📍 4. แอบเซฟที่อยู่รูปลงฐานข้อมูล Firebase เงียบๆ
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                            'avatarPath': avatars[index],
                          }, SetOptions(merge: true)); // ใช้ merge เพื่อไม่ให้วันเกิด/เพศ หาย
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: moodVibeOlive, width: 2),
                          image: DecorationImage(
                            image: AssetImage(avatars[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'การตั้งค่า',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: moodVibeCream,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: localAvatarPath != null
                            ? AssetImage(localAvatarPath!)
                            : null,
                        child: localAvatarPath == null
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
              style: const TextStyle(
                color: moodVibeDarkBrown,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'การตั้งค่าทั่วไป',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: moodVibeDarkBrown),
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'ข้อมูลส่วนตัว',
                    icon: Icons.person_outline,
                    onTap: () => Navigator.pushNamed(context, '/profile_edit'),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: moodVibeDarkBrown),
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
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [],
                  ),
                  const SizedBox(height: 15),
                  _buildSettingTile(
                    title: 'Log Out',
                    icon: Icons.logout,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }
                    },
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: moodVibeDarkBrown),
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

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: moodVibeDarkBrown),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: moodVibeDarkBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
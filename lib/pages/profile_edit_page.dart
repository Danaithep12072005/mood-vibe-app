import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/shared_widgets.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String selectedGender = 'ชาย'; 
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // โหลดข้อมูลเดิมมาแสดงตอนเปิดหน้า
  }

  // ฟังก์ชันโหลดข้อมูลจาก Database
  Future<void> _loadProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          dobController.text = doc.get('dob') ?? '';
          selectedGender = doc.get('gender') ?? 'ชาย';
        });
      }
    }
  }

  // ฟังก์ชันเด้งปฏิทินเลือกวันเกิด
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(1900), 
      lastDate: DateTime.now(), 
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: moodVibeOlive, 
              onPrimary: Colors.white, 
              onSurface: moodVibeDarkBrown, 
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // ฟังก์ชันบันทึกข้อมูล
  Future<void> _saveProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 1. บันทึกวันเกิดและเพศลง Database (Firestore)
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'dob': dobController.text,
        'gender': selectedGender,
      }, SetOptions(merge: true));

      // 2. ถ้าระบุรหัสผ่านใหม่ ให้ทำการเปลี่ยนรหัสผ่าน
      if (passwordController.text.isNotEmpty) {
        if (passwordController.text.length >= 6) {
          await user.updatePassword(passwordController.text);
        } else {
          throw Exception('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร');
        }
      }

      // 3. แจ้งเตือนและกดย้อนกลับ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลสำเร็จ!', style: TextStyle(fontSize: 14)),
            backgroundColor: moodVibeOlive,
            behavior: SnackBarBehavior.floating,
          )
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}', style: const TextStyle(fontSize: 14)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodVibeCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
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
                    const Text('ข้อมูลส่วนตัว', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                  ],
                ),
                const SizedBox(height: 40),
                
                CustomTextField(
                  label: 'Password',
                  hint: 'กรอกรหัสผ่านใหม่ (ถ้าต้องการเปลี่ยน)',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                ),
                const SizedBox(height: 25),
                
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer( 
                    child: CustomTextField(
                      label: 'Date of Birth',
                      hint: 'ระบุวันเกิดของคุณ',
                      icon: Icons.calendar_month_outlined,
                      controller: dobController,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('เพศ', style: TextStyle(fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
                    Text('เลือกได้ตัวเลือกเดียว', style: TextStyle(fontSize: 12, color: moodVibeDarkBrown.withOpacity(0.5))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildGenderRadio('ชาย')),
                    const SizedBox(width: 20),
                    Expanded(child: _buildGenderRadio('หญิง')),
                  ],
                ),
                
                const SizedBox(height: 60), 
                
                CustomButton(
                  text: 'บันทึกข้อมูล',
                  onPressed: _saveProfile,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderRadio(String title) {
    bool isSelected = selectedGender == title;
    return GestureDetector(
      onTap: () {
        setState(() { selectedGender = title; });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          border: Border.all(color: isSelected ? moodVibeOlive : Colors.transparent, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: moodVibeDarkBrown)),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? moodVibeOlive : Colors.grey, width: 2),
              ),
              child: isSelected
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: moodVibeOlive, shape: BoxShape.circle)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
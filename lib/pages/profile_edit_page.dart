import 'package:flutter/material.dart';
import '../utils/shared_widgets.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String selectedGender = 'ชาย'; // ค่าเริ่มต้นเพศ

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
              // ส่วนหัว
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
              
              // รหัสผ่าน
              const CustomTextField(
                label: 'Password',
                hint: '***************',
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 25),
              
              // วันเกิด
              const CustomTextField(
                label: 'Date of Birth',
                hint: 'ระบุวันเกิดของคุณ',
                icon: Icons.calendar_month_outlined,
              ),
              const SizedBox(height: 25),
              
              // เลือกเพศ
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
              
              const Spacer(),
              // ปุ่มบันทึกข้อมูล
              CustomButton(
                text: 'บันทึกข้อมูล',
                onPressed: () {
                  // บันทึกเสร็จแล้วย้อนกลับ
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // วิดเจ็ตสำหรับปุ่มเลือกเพศ
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
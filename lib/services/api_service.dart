import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) { return false; }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e) { return null; }
  }

  static Future<bool> updateUserProfile({String? dob, String? gender, String? avatarPath}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      Map<String, dynamic> data = {};
      if (dob != null) data['dob'] = dob;
      if (gender != null) data['gender'] = gender;
      if (avatarPath != null) data['avatarPath'] = avatarPath;
      await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      await user.updatePassword(newPassword);
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> saveMood(int moodIndex, String topic, String detail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      await _firestore.collection('moods').add({
        'uid': user.uid,
        'email': user.email,
        'mood_index': moodIndex,
        'topic': topic,
        'detail': detail,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> updateMood(String docId, int moodIndex, String topic, String detail) async {
    try {
      await _firestore.collection('moods').doc(docId).update({
        'mood_index': moodIndex,
        'topic': topic,
        'detail': detail,
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<List<Map<String, dynamic>>> fetchMoodHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];
      final querySnapshot = await _firestore
          .collection('moods')
          .where('uid', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Fetch Error: $e'); 
      return [];
    }
  }
}
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';
import 'package:flutter/material.dart'; 

class StorageService {
  // Key untuk menyimpan data di SharedPreferences
  static const String _keyActivities = 'activities_list';

  /// ✅ SIMPAN semua aktivitas ke local storage
  static Future<void> saveActivities(List<ActivityModel> activities) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert list ActivityModel → List<Map> → JSON String
    final List<Map<String, dynamic>> activitiesMap = activities.map((activity) {
      return {
        'title': activity.title,
        'lastDate': activity.lastDate,
        'daysAgo': activity.daysAgo,
        'iconColorValue': activity.iconColor.value, // Simpan sebagai int
        'iconCodePoint': activity.icon.codePoint,   // Simpan sebagai int
        'iconFontFamily': activity.icon.fontFamily, // Simpan fontFamily
        'status': activity.status,
      };
    }).toList();
    
    final jsonString = jsonEncode(activitiesMap);
    await prefs.setString(_keyActivities, jsonString);
  }

  /// ✅ LOAD semua aktivitas dari local storage
  static Future<List<ActivityModel>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyActivities);
    
    if (jsonString == null) return []; // Belum ada data
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      
      return decoded.map((item) {
        return ActivityModel(
          title: item['title'],
          lastDate: item['lastDate'],
          daysAgo: item['daysAgo'],
          iconColor: Color(item['iconColorValue']),
          icon: IconData(
            item['iconCodePoint'],
            fontFamily: item['iconFontFamily'],
          ),
          status: item['status'],
        );
      }).toList();
    } catch (e) {
      print('Error loading activities: $e');
      return []; // Return empty list jika error
    }
  }

  /// ✅ TAMBAH 1 aktivitas baru ke storage
  static Future<void> addActivity(ActivityModel newActivity) async {
    final currentActivities = await loadActivities();
    currentActivities.insert(0, newActivity); // Tambah di posisi pertama
    await saveActivities(currentActivities);
  }

  /// ✅ HAPUS aktivitas berdasarkan index/title (opsional untuk nanti)
  static Future<void> deleteActivity(String title) async {
    final currentActivities = await loadActivities();
    currentActivities.removeWhere((activity) => activity.title == title);
    await saveActivities(currentActivities);
  }

  /// ✅ UPDATE aktivitas (opsional untuk Sprint 2)
  static Future<void> updateActivity(String oldTitle, ActivityModel updatedActivity) async {
    final currentActivities = await loadActivities();
    final index = currentActivities.indexWhere((a) => a.title == oldTitle);
    if (index != -1) {
      currentActivities[index] = updatedActivity;
      await saveActivities(currentActivities);
    }
  }
}
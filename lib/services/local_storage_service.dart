import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _healthDataKey = 'health_data';
  static const String _preferencesKey = 'app_preferences';

  // Save user data
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Get user data
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  // Save health data
  static Future<void> saveHealthData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_healthDataKey, json.encode(data));
  }

  // Get health data
  static Future<Map<String, dynamic>?> getHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getString(_healthDataKey);
    if (dataJson != null) {
      return json.decode(dataJson);
    }
    return null;
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class UserDataProvider extends ChangeNotifier {
  UserModel? _user;
  Map<String, dynamic>? _healthData;

  UserModel? get user => _user;
  Map<String, dynamic>? get healthData => _healthData;

  UserDataProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _user = await LocalStorageService.getUser();
    _healthData = await LocalStorageService.getHealthData();
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    _user = user;
    await LocalStorageService.saveUser(user);
    notifyListeners();
  }

  Future<void> updateHealthData(Map<String, dynamic> data) async {
    _healthData = data;
    await LocalStorageService.saveHealthData(data);
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorageService.clearAll();
    _user = null;
    _healthData = null;
    notifyListeners();
  }
}
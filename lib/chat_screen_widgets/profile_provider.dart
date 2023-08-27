import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String? _profileImageUrl;

  ProfileProvider(String? initialImageUrl) : _profileImageUrl = initialImageUrl;

  String? get profileImageUrl => _profileImageUrl;

  void setProfileImageUrl(String imageUrl) {
    _profileImageUrl = imageUrl;
    notifyListeners();
  }
}

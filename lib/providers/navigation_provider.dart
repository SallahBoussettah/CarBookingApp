import 'package:flutter/material.dart';

/// Provider for managing navigation state
class NavigationProvider with ChangeNotifier {
  /// Current tab index
  int _currentIndex = 0;

  /// Get the current tab index
  int get currentIndex => _currentIndex;

  /// Set the current tab index
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
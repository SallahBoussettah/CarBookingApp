import 'package:flutter/material.dart';
import 'package:car_booking_app/models/user.dart';

/// Provider for managing user data
class UserProvider extends ChangeNotifier {
  /// Current user
  User? _currentUser;

  /// Loading status
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Get current user
  User? get currentUser => _currentUser;

  /// Get loading status
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Initialize with mock data for development
  UserProvider() {
    // Load mock user data for development
    _loadMockUser();
  }

  /// Load mock user data
  Future<void> _loadMockUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Create mock user
      _currentUser = User(
        id: 'user123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1 (555) 123-4567',
        profilePicture: 'assets/images/profile/default_avatar.png',
        address: '123 Main St, Anytown, CA 12345',
        preferredPaymentMethod: 'Credit Card',
        driverLicenseNumber: 'DL12345678',
        driverLicenseIssueDate: DateTime(2020, 1, 15),
        driverLicenseExpiryDate: DateTime(2025, 1, 15),
        isEmailVerified: true,
        isPhoneVerified: true,
        joinedDate: DateTime(2023, 3, 10),
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load user data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? preferredPaymentMethod,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Update user data
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        preferredPaymentMethod: preferredPaymentMethod,
      );

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile picture
  Future<bool> updateProfilePicture(String imagePath) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Update profile picture
      _currentUser = _currentUser!.copyWith(
        profilePicture: imagePath,
      );

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile picture: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Clear user data
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to sign out: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
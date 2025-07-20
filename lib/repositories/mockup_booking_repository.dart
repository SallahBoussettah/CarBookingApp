import 'dart:async';
import 'dart:math';

import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/repositories/booking_repository.dart';

/// Implementation of BookingRepository that uses in-memory storage
class MockupBookingRepository implements BookingRepository {
  // Singleton instance
  static final MockupBookingRepository _instance = MockupBookingRepository._internal();
  
  // Factory constructor to return the singleton instance
  factory MockupBookingRepository() => _instance;
  
  // Private constructor
  MockupBookingRepository._internal();
  
  // In-memory storage of bookings
  final List<Booking> _bookings = [];
  
  // Random number generator for ID generation
  final Random _random = Random();
  
  // Simulated network delay in milliseconds
  final int _simulatedDelay = 800;
  
  @override
  Future<List<Booking>> getUserBookings() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: _simulatedDelay));
    
    // Return a copy of the list to prevent modification
    return List.from(_bookings);
  }
  
  @override
  Future<Booking?> getBookingById(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: _simulatedDelay));
    
    // Find booking by ID
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      // Return null if booking not found
      return null;
    }
  }
  
  @override
  Future<String> createBooking(Booking booking) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: _simulatedDelay));
    
    // Generate a new ID if the booking doesn't have one or has an empty one
    final String bookingId = booking.id.isEmpty ? _generateBookingId() : booking.id;
    
    // Create a new booking with the generated ID
    final newBooking = booking.copyWith(id: bookingId);
    
    // Validate booking after setting the ID
    if (!newBooking.isValid()) {
      throw Exception('Invalid booking: ${newBooking.getValidationErrors().join(', ')}');
    }
    
    // Add to in-memory storage
    _bookings.add(newBooking);
    
    // Return the booking ID
    return bookingId;
  }
  
  @override
  Future<bool> updateBooking(Booking booking) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: _simulatedDelay));
    
    // Validate booking
    if (!booking.isValid()) {
      throw Exception('Invalid booking: ${booking.getValidationErrors().join(', ')}');
    }
    
    // Find the index of the booking with the same ID
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    
    // If booking not found, return false
    if (index == -1) {
      return false;
    }
    
    // Replace the booking at the found index
    _bookings[index] = booking;
    
    return true;
  }
  
  @override
  Future<bool> cancelBooking(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: _simulatedDelay));
    
    // Find the index of the booking with the given ID
    final index = _bookings.indexWhere((b) => b.id == id);
    
    // If booking not found, return false
    if (index == -1) {
      return false;
    }
    
    // Get the booking
    final booking = _bookings[index];
    
    // Update the booking status to cancelled
    _bookings[index] = booking.copyWith(status: BookingStatus.cancelled);
    
    return true;
  }
  
  /// Generates a unique booking ID
  String _generateBookingId() {
    // Generate a random 6-character alphanumeric string
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final result = StringBuffer();
    
    // Current timestamp for uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Add 6 random characters
    for (var i = 0; i < 6; i++) {
      result.write(chars[_random.nextInt(chars.length)]);
    }
    
    // Combine with timestamp to ensure uniqueness
    return 'BK-${result.toString()}-${timestamp.substring(timestamp.length - 4)}';
  }
  
  /// Clear all bookings (for testing purposes)
  void clear() {
    _bookings.clear();
  }
}
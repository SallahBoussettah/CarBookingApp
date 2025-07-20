import 'package:car_booking_app/models/booking.dart';

/// Interface for booking data operations
abstract class BookingRepository {
  /// Get all bookings for the current user
  /// 
  /// Returns a Future that completes with a list of all user bookings
  Future<List<Booking>> getUserBookings();
  
  /// Get a booking by its ID
  /// 
  /// [id] The ID of the booking to retrieve
  /// Returns a Future that completes with the booking if found, or null if not found
  Future<Booking?> getBookingById(String id);
  
  /// Create a new booking
  /// 
  /// [booking] The booking to create
  /// Returns a Future that completes with the ID of the created booking
  Future<String> createBooking(Booking booking);
  
  /// Update an existing booking
  /// 
  /// [booking] The booking to update
  /// Returns a Future that completes with a boolean indicating success
  Future<bool> updateBooking(Booking booking);
  
  /// Cancel a booking
  /// 
  /// [id] The ID of the booking to cancel
  /// Returns a Future that completes with a boolean indicating success
  Future<bool> cancelBooking(String id);
}
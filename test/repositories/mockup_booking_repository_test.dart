import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/repositories/mockup_booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockupBookingRepository', () {
    late MockupBookingRepository repository;
    
    setUp(() {
      repository = MockupBookingRepository();
      repository.clear(); // Clear any existing bookings
    });
    
    test('getUserBookings should return empty list initially', () async {
      final bookings = await repository.getUserBookings();
      expect(bookings.isEmpty, true);
    });
    
    test('createBooking should add a booking and return an ID', () async {
      final booking = Booking(
        id: '', // Empty ID, will be generated
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      final bookingId = await repository.createBooking(booking);
      
      // Verify ID is not empty
      expect(bookingId.isNotEmpty, true);
      expect(bookingId.startsWith('BK-'), true);
      
      // Verify booking was added
      final bookings = await repository.getUserBookings();
      expect(bookings.length, 1);
      expect(bookings[0].id, bookingId);
      expect(bookings[0].carId, 'car-123');
    });
    
    test('getBookingById should return correct booking', () async {
      // Create a booking first
      final booking = Booking(
        id: 'test-id',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      await repository.createBooking(booking);
      
      // Get booking by ID
      final retrievedBooking = await repository.getBookingById('test-id');
      
      // Verify booking is not null and has the correct ID
      expect(retrievedBooking, isNotNull);
      expect(retrievedBooking!.id, 'test-id');
      expect(retrievedBooking.carId, 'car-123');
    });
    
    test('getBookingById should return null for invalid ID', () async {
      final booking = await repository.getBookingById('invalid-id');
      expect(booking, isNull);
    });
    
    test('updateBooking should update an existing booking', () async {
      // Create a booking first
      final booking = Booking(
        id: 'test-id',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      await repository.createBooking(booking);
      
      // Update the booking
      final updatedBooking = booking.copyWith(
        status: BookingStatus.confirmed,
        totalCost: 200.0,
      );
      
      final result = await repository.updateBooking(updatedBooking);
      
      // Verify update was successful
      expect(result, true);
      
      // Verify booking was updated
      final retrievedBooking = await repository.getBookingById('test-id');
      expect(retrievedBooking!.status, BookingStatus.confirmed);
      expect(retrievedBooking.totalCost, 200.0);
    });
    
    test('updateBooking should return false for non-existent booking', () async {
      final booking = Booking(
        id: 'non-existent',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      final result = await repository.updateBooking(booking);
      expect(result, false);
    });
    
    test('cancelBooking should update booking status to cancelled', () async {
      // Create a booking first
      final booking = Booking(
        id: 'test-id',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      await repository.createBooking(booking);
      
      // Cancel the booking
      final result = await repository.cancelBooking('test-id');
      
      // Verify cancellation was successful
      expect(result, true);
      
      // Verify booking status was updated
      final retrievedBooking = await repository.getBookingById('test-id');
      expect(retrievedBooking!.status, BookingStatus.cancelled);
    });
    
    test('cancelBooking should return false for non-existent booking', () async {
      final result = await repository.cancelBooking('non-existent');
      expect(result, false);
    });
    
    test('repository should be a singleton', () {
      final repository1 = MockupBookingRepository();
      final repository2 = MockupBookingRepository();
      
      expect(identical(repository1, repository2), true);
    });
    
    test('getUserBookings should return a new list each time', () async {
      // Create a booking first
      final booking = Booking(
        id: 'test-id',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 1),
        returnDate: DateTime(2023, 5, 3),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      await repository.createBooking(booking);
      
      final bookings1 = await repository.getUserBookings();
      final bookings2 = await repository.getUserBookings();
      
      // Lists should not be identical (different instances)
      expect(identical(bookings1, bookings2), false);
      
      // But they should be equal (same content)
      expect(bookings1.length, bookings2.length);
      expect(bookings1[0].id, bookings2[0].id);
    });
    
    test('createBooking should throw exception for invalid booking', () async {
      // Create an invalid booking (return date before pickup date)
      final booking = Booking(
        id: 'test-id',
        carId: 'car-123',
        pickupDate: DateTime(2023, 5, 3), // Later than return date
        returnDate: DateTime(2023, 5, 1), // Earlier than pickup date
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 14, minute: 0),
        totalCost: 150.0,
      );
      
      // Expect an exception when creating the booking
      expect(() => repository.createBooking(booking), throwsException);
    });
  });
}
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Booking', () {
    // Create test data
    final pickupDate = DateTime(2025, 7, 20);
    final returnDate = DateTime(2025, 7, 23);
    final pickupTime = const TimeOfDay(hour: 10, minute: 0);
    final returnTime = const TimeOfDay(hour: 14, minute: 0);
    final pricePerDay = 100.0;

    test('should create a valid Booking instance', () {
      final booking = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
      );

      expect(booking.id, 'booking-001');
      expect(booking.carId, 'car-001');
      expect(booking.pickupDate, pickupDate);
      expect(booking.returnDate, returnDate);
      expect(booking.pickupTime, pickupTime);
      expect(booking.returnTime, returnTime);
      expect(booking.totalCost, 300.0);
      expect(booking.status, BookingStatus.pending);
    });

    test('should create booking with calculated cost', () {
      final booking = Booking.create(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        pricePerDay: pricePerDay,
      );

      // 3 days difference
      expect(booking.totalCost, 300.0);
    });

    test('should convert to and from JSON correctly', () {
      final booking = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
        status: BookingStatus.confirmed,
      );

      final json = booking.toJson();
      final fromJson = Booking.fromJson(json);

      expect(fromJson.id, booking.id);
      expect(fromJson.carId, booking.carId);
      expect(fromJson.pickupDate.isAtSameMomentAs(booking.pickupDate), true);
      expect(fromJson.returnDate.isAtSameMomentAs(booking.returnDate), true);
      expect(fromJson.pickupTime.hour, booking.pickupTime.hour);
      expect(fromJson.pickupTime.minute, booking.pickupTime.minute);
      expect(fromJson.returnTime.hour, booking.returnTime.hour);
      expect(fromJson.returnTime.minute, booking.returnTime.minute);
      expect(fromJson.totalCost, booking.totalCost);
      expect(fromJson.status, booking.status);
    });

    test('should create a copy with updated fields', () {
      final booking = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
      );

      final newReturnDate = DateTime(2025, 7, 24);
      final updated = booking.copyWith(
        returnDate: newReturnDate,
        status: BookingStatus.confirmed,
      );

      expect(updated.id, booking.id);
      expect(updated.carId, booking.carId);
      expect(updated.pickupDate, booking.pickupDate);
      expect(updated.returnDate, newReturnDate);
      expect(updated.pickupTime, booking.pickupTime);
      expect(updated.returnTime, booking.returnTime);
      expect(updated.totalCost, booking.totalCost);
      expect(updated.status, BookingStatus.confirmed);
    });

    group('validation', () {
      test('should be valid with correct values', () {
        final booking = Booking(
          id: 'booking-001',
          carId: 'car-001',
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 300.0,
        );

        expect(booking.isValid(), true);
        expect(booking.getValidationErrors(), isEmpty);
      });

      test('should be invalid with empty id', () {
        final booking = Booking(
          id: '',
          carId: 'car-001',
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 300.0,
        );

        expect(booking.isValid(), false);
        expect(booking.getValidationErrors(), contains('Booking ID cannot be empty'));
      });

      test('should be invalid with empty car id', () {
        final booking = Booking(
          id: 'booking-001',
          carId: '',
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 300.0,
        );

        expect(booking.isValid(), false);
        expect(booking.getValidationErrors(), contains('Car ID cannot be empty'));
      });

      test('should be invalid with zero or negative cost', () {
        final booking = Booking(
          id: 'booking-001',
          carId: 'car-001',
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 0.0,
        );

        expect(booking.isValid(), false);
        expect(booking.getValidationErrors(), contains('Total cost must be greater than 0'));
      });

      test('should be invalid if return date is before pickup date', () {
        final booking = Booking(
          id: 'booking-001',
          carId: 'car-001',
          pickupDate: returnDate, // Swapped dates
          returnDate: pickupDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 300.0,
        );

        expect(booking.isValid(), false);
        expect(booking.getValidationErrors(), contains('Return date cannot be before pickup date'));
      });

      test('should be invalid if return time is before pickup time on same day', () {
        final booking = Booking(
          id: 'booking-001',
          carId: 'car-001',
          pickupDate: pickupDate,
          returnDate: pickupDate, // Same day
          pickupTime: const TimeOfDay(hour: 14, minute: 0),
          returnTime: const TimeOfDay(hour: 10, minute: 0), // Earlier time
          totalCost: 300.0,
        );

        expect(booking.isValid(), false);
        expect(booking.getValidationErrors(), 
          contains('Return time cannot be before pickup time on the same day'));
      });

      test('should collect multiple validation errors', () {
        final booking = Booking(
          id: '',
          carId: '',
          pickupDate: returnDate, // Swapped dates
          returnDate: pickupDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          totalCost: 0.0,
        );

        final errors = booking.getValidationErrors();
        expect(errors.length, 4);
        expect(errors, contains('Booking ID cannot be empty'));
        expect(errors, contains('Car ID cannot be empty'));
        expect(errors, contains('Total cost must be greater than 0'));
        expect(errors, contains('Return date cannot be before pickup date'));
      });
    });

    group('cost calculation', () {
      test('should calculate cost for multiple days', () {
        final cost = Booking.calculateCost(
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: pickupTime,
          returnTime: returnTime,
          pricePerDay: pricePerDay,
        );

        // 3 days difference
        expect(cost, 300.0);
      });

      test('should calculate cost for same day', () {
        final cost = Booking.calculateCost(
          pickupDate: pickupDate,
          returnDate: pickupDate,
          pickupTime: const TimeOfDay(hour: 10, minute: 0),
          returnTime: const TimeOfDay(hour: 18, minute: 0),
          pricePerDay: pricePerDay,
        );

        // Same day counts as 1 day
        expect(cost, 100.0);
      });

      test('should calculate cost with partial day', () {
        final cost = Booking.calculateCost(
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: const TimeOfDay(hour: 14, minute: 0),
          returnTime: const TimeOfDay(hour: 18, minute: 0),
          pricePerDay: pricePerDay,
        );

        // 3 days + 4 hours (1/6 of a day)
        expect(cost, closeTo(316.67, 0.01));
      });

      test('should calculate duration in days', () {
        final booking = Booking.create(
          id: 'booking-001',
          carId: 'car-001',
          pickupDate: pickupDate,
          returnDate: returnDate,
          pickupTime: const TimeOfDay(hour: 14, minute: 0),
          returnTime: const TimeOfDay(hour: 18, minute: 0),
          pricePerDay: pricePerDay,
        );

        // 3 days + 4 hours (1/6 of a day)
        expect(booking.durationInDays, closeTo(3.167, 0.01));
      });
    });

    test('helper methods work correctly', () {
      // Test isSameDay
      expect(Booking.isSameDay(
        DateTime(2025, 7, 20),
        DateTime(2025, 7, 20, 23, 59),
      ), true);
      
      expect(Booking.isSameDay(
        DateTime(2025, 7, 20),
        DateTime(2025, 7, 21),
      ), false);

      // Test isTimeBefore
      expect(Booking.isTimeBefore(
        const TimeOfDay(hour: 10, minute: 0),
        const TimeOfDay(hour: 14, minute: 0),
      ), true);
      
      expect(Booking.isTimeBefore(
        const TimeOfDay(hour: 14, minute: 0),
        const TimeOfDay(hour: 10, minute: 0),
      ), false);
      
      expect(Booking.isTimeBefore(
        const TimeOfDay(hour: 14, minute: 0),
        const TimeOfDay(hour: 14, minute: 30),
      ), true);
    });

    test('equality works correctly', () {
      final booking1 = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
      );

      final booking2 = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: DateTime(2025, 7, 20), // Same date but different instance
        returnDate: DateTime(2025, 7, 23), // Same date but different instance
        pickupTime: const TimeOfDay(hour: 10, minute: 0), // Same time but different instance
        returnTime: const TimeOfDay(hour: 14, minute: 0), // Same time but different instance
        totalCost: 300.0,
      );

      final booking3 = Booking(
        id: 'booking-002', // Different ID
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
      );

      expect(booking1, equals(booking2));
      expect(booking1 == booking3, false);
      expect(booking1.hashCode == booking2.hashCode, true);
    });

    test('toString returns correct representation', () {
      final booking = Booking(
        id: 'booking-001',
        carId: 'car-001',
        pickupDate: pickupDate,
        returnDate: returnDate,
        pickupTime: pickupTime,
        returnTime: returnTime,
        totalCost: 300.0,
        status: BookingStatus.confirmed,
      );

      final string = booking.toString();
      expect(string, contains('booking-001'));
      expect(string, contains('car-001'));
      expect(string, contains('300.0'));
      expect(string, contains('Confirmed'));
    });
  });
}
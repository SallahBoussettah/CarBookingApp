import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/repositories/booking_repository.dart';

// Mock implementation of BookingRepository for testing
class MockBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [];
  
  @override
  Future<List<Booking>> getUserBookings() async {
    return List.from(_bookings);
  }
  
  @override
  Future<Booking?> getBookingById(String id) async {
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<String> createBooking(Booking booking) async {
    final String bookingId = booking.id.isEmpty ? 'test-booking-${_bookings.length + 1}' : booking.id;
    final newBooking = booking.copyWith(id: bookingId);
    
    if (!newBooking.isValid()) {
      throw Exception('Invalid booking: ${newBooking.getValidationErrors().join(', ')}');
    }
    
    _bookings.add(newBooking);
    return bookingId;
  }
  
  @override
  Future<bool> updateBooking(Booking booking) async {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index == -1) {
      return false;
    }
    
    _bookings[index] = booking;
    return true;
  }
  
  @override
  Future<bool> cancelBooking(String id) async {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) {
      return false;
    }
    
    _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
    return true;
  }
  
  // Helper method to add test bookings
  void addTestBookings(List<Booking> bookings) {
    _bookings.addAll(bookings);
  }
  
  // Helper method to clear all bookings
  void clear() {
    _bookings.clear();
  }
  
  // Helper method to get the current bookings
  List<Booking> getCurrentBookings() {
    return _bookings;
  }
}

void main() {
  group('BookingProvider Tests', () {
    late BookingProvider bookingProvider;
    late MockBookingRepository mockRepository;
    
    // Helper function to create a test booking
    Booking createTestBooking({
      required String id,
      required String carId,
      DateTime? pickupDate,
      DateTime? returnDate,
      TimeOfDay? pickupTime,
      TimeOfDay? returnTime,
      double? totalCost,
      BookingStatus? status,
    }) {
      return Booking(
        id: id,
        carId: carId,
        pickupDate: pickupDate ?? DateTime(2025, 7, 20),
        returnDate: returnDate ?? DateTime(2025, 7, 22),
        pickupTime: pickupTime ?? const TimeOfDay(hour: 10, minute: 0),
        returnTime: returnTime ?? const TimeOfDay(hour: 14, minute: 0),
        totalCost: totalCost ?? 100.0,
        status: status ?? BookingStatus.pending,
      );
    }

    setUp(() {
      mockRepository = MockBookingRepository();
      bookingProvider = BookingProvider(bookingRepository: mockRepository);
    });

    test('Initial state is correct', () {
      expect(bookingProvider.bookings, isEmpty);
      expect(bookingProvider.selectedBooking, isNull);
      expect(bookingProvider.bookingFormData, isEmpty);
      expect(bookingProvider.status, equals(BookingLoadingStatus.initial));
      expect(bookingProvider.errorMessage, isNull);
    });

    test('fetchUserBookings updates state correctly', () async {
      // Add test bookings to repository
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1'),
        createTestBooking(id: 'test-2', carId: 'car-2'),
      ]);
      
      // Initial state
      expect(bookingProvider.status, equals(BookingLoadingStatus.initial));
      
      // Fetch bookings
      await bookingProvider.fetchUserBookings();
      
      // Verify state after fetch
      expect(bookingProvider.status, equals(BookingLoadingStatus.loaded));
      expect(bookingProvider.bookings.length, equals(2));
      expect(bookingProvider.errorMessage, isNull);
    });

    test('fetchBookingById updates selectedBooking correctly', () async {
      // Add test booking to repository
      final testBooking = createTestBooking(id: 'test-1', carId: 'car-1');
      mockRepository.addTestBookings([testBooking]);
      
      // Fetch a specific booking
      await bookingProvider.fetchBookingById('test-1');
      
      // Verify state after fetch
      expect(bookingProvider.status, equals(BookingLoadingStatus.loaded));
      expect(bookingProvider.selectedBooking, isNotNull);
      expect(bookingProvider.selectedBooking?.id, equals('test-1'));
      expect(bookingProvider.errorMessage, isNull);
    });

    test('fetchBookingById handles non-existent booking', () async {
      // Fetch a non-existent booking
      await bookingProvider.fetchBookingById('non-existent');
      
      // Verify error state
      expect(bookingProvider.status, equals(BookingLoadingStatus.error));
      expect(bookingProvider.selectedBooking, isNull);
      expect(bookingProvider.errorMessage, equals('Booking not found'));
    });

    test('createBooking adds a new booking', () async {
      // Create a new booking with a non-empty ID
      final testBooking = createTestBooking(id: 'test-new', carId: 'car-1');
      
      // Create booking
      final bookingId = await bookingProvider.createBooking(testBooking);
      
      // Verify booking was created
      expect(bookingId, isNotNull);
      expect(bookingProvider.status, equals(BookingLoadingStatus.loaded));
      expect(bookingProvider.bookings.length, equals(1));
      expect(bookingProvider.selectedBooking, isNotNull);
      expect(bookingProvider.selectedBooking?.carId, equals('car-1'));
    });

    test('createBooking validates booking before creation', () async {
      // Create an invalid booking (empty car ID)
      final invalidBooking = createTestBooking(id: '', carId: '');
      final bookingId = await bookingProvider.createBooking(invalidBooking);
      
      // Verify booking was not created
      expect(bookingId, isNull);
      expect(bookingProvider.status, equals(BookingLoadingStatus.error));
      expect(bookingProvider.errorMessage, contains('Car ID cannot be empty'));
    });

    test('cancelBooking cancels an existing booking', () async {
      // Add test booking to repository
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1'),
      ]);
      
      // Fetch bookings to update provider state
      await bookingProvider.fetchUserBookings();
      expect(bookingProvider.bookings.length, equals(1));
      expect(bookingProvider.bookings.first.status, equals(BookingStatus.pending));
      
      // Cancel booking
      final success = await bookingProvider.cancelBooking('test-1');
      
      // Verify booking was cancelled
      expect(success, isTrue);
      expect(bookingProvider.bookings.first.status, equals(BookingStatus.cancelled));
    });

    test('selectBooking updates selectedBooking', () {
      // Create a test booking
      final testBooking = createTestBooking(id: 'test-1', carId: 'car-1');
      
      // Select booking
      bookingProvider.selectBooking(testBooking);
      
      // Verify state
      expect(bookingProvider.selectedBooking, equals(testBooking));
    });

    test('clearSelectedBooking clears the selected booking', () {
      // Setup - first select a booking
      final testBooking = createTestBooking(id: 'test-1', carId: 'car-1');
      bookingProvider.selectBooking(testBooking);
      expect(bookingProvider.selectedBooking, isNotNull);
      
      // Clear selected booking
      bookingProvider.clearSelectedBooking();
      
      // Verify state
      expect(bookingProvider.selectedBooking, isNull);
    });

    test('updateBookingFormData updates form data', () {
      // Update form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
      });
      
      // Verify state
      expect(bookingProvider.bookingFormData['carId'], equals('car-1'));
      expect(bookingProvider.bookingFormData['pickupDate'], equals(DateTime(2025, 7, 20)));
      
      // Update more form data
      bookingProvider.updateBookingFormData({
        'returnDate': DateTime(2025, 7, 22),
      });
      
      // Verify state is merged, not replaced
      expect(bookingProvider.bookingFormData['carId'], equals('car-1'));
      expect(bookingProvider.bookingFormData['pickupDate'], equals(DateTime(2025, 7, 20)));
      expect(bookingProvider.bookingFormData['returnDate'], equals(DateTime(2025, 7, 22)));
    });

    test('clearBookingFormData clears form data', () {
      // Setup - add form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
      });
      expect(bookingProvider.bookingFormData.isNotEmpty, isTrue);
      
      // Clear form data
      bookingProvider.clearBookingFormData();
      
      // Verify state
      expect(bookingProvider.bookingFormData, isEmpty);
    });

    test('calculateBookingCost calculates correct cost', () {
      // Setup - add form data
      bookingProvider.updateBookingFormData({
        'pickupDate': DateTime(2025, 7, 20),
        'returnDate': DateTime(2025, 7, 22),
        'pickupTime': const TimeOfDay(hour: 10, minute: 0),
        'returnTime': const TimeOfDay(hour: 14, minute: 0),
      });
      
      // Calculate cost
      final cost = bookingProvider.calculateBookingCost(50.0);
      
      // Verify cost (2 days * $50)
      expect(cost, equals(100.0));
    });

    test('validateBookingFormData validates form data correctly', () {
      // Empty form data
      expect(bookingProvider.validateBookingFormData().isNotEmpty, isTrue);
      
      // Partial form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
      });
      expect(bookingProvider.validateBookingFormData().isNotEmpty, isTrue);
      
      // Complete but invalid form data (return date before pickup date)
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
        'returnDate': DateTime(2025, 7, 19),
        'pickupTime': const TimeOfDay(hour: 10, minute: 0),
        'returnTime': const TimeOfDay(hour: 14, minute: 0),
      });
      final errors = bookingProvider.validateBookingFormData();
      expect(errors.isNotEmpty, isTrue);
      expect(errors.first, contains('Return date cannot be before pickup date'));
      
      // Complete and valid form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
        'returnDate': DateTime(2025, 7, 22),
        'pickupTime': const TimeOfDay(hour: 10, minute: 0),
        'returnTime': const TimeOfDay(hour: 14, minute: 0),
      });
      expect(bookingProvider.validateBookingFormData(), isEmpty);
    });

    test('createBookingFromFormData creates booking from form data', () async {
      // Setup - add valid form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
        'returnDate': DateTime(2025, 7, 22),
        'pickupTime': const TimeOfDay(hour: 10, minute: 0),
        'returnTime': const TimeOfDay(hour: 14, minute: 0),
      });
      
      // Create booking from form data
      final bookingId = await bookingProvider.createBookingFromFormData(50.0);
      
      // Verify booking was created
      expect(bookingId, isNotNull);
      expect(bookingProvider.bookings.length, equals(1));
      expect(bookingProvider.bookings.first.carId, equals('car-1'));
      expect(bookingProvider.bookings.first.totalCost, equals(100.0));
    });

    test('createBookingFromFormData validates form data before creation', () async {
      // Setup - add invalid form data
      bookingProvider.updateBookingFormData({
        'carId': 'car-1',
        'pickupDate': DateTime(2025, 7, 20),
        'returnDate': DateTime(2025, 7, 19), // Invalid: return date before pickup date
        'pickupTime': const TimeOfDay(hour: 10, minute: 0),
        'returnTime': const TimeOfDay(hour: 14, minute: 0),
      });
      
      // Try to create booking from invalid form data
      final bookingId = await bookingProvider.createBookingFromFormData(50.0);
      
      // Verify booking was not created
      expect(bookingId, isNull);
      expect(bookingProvider.status, equals(BookingLoadingStatus.error));
      expect(bookingProvider.errorMessage, contains('Return date cannot be before pickup date'));
    });

    test('reset resets the entire provider state', () async {
      // Setup - load data and set form data
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1'),
      ]);
      await bookingProvider.fetchUserBookings();
      bookingProvider.updateBookingFormData({'carId': 'car-1'});
      
      // Reset provider
      bookingProvider.reset();
      
      // Verify state
      expect(bookingProvider.bookings, isEmpty);
      expect(bookingProvider.selectedBooking, isNull);
      expect(bookingProvider.bookingFormData, isEmpty);
      expect(bookingProvider.status, equals(BookingLoadingStatus.initial));
      expect(bookingProvider.errorMessage, isNull);
    });

    test('activeBookings returns only active bookings', () async {
      // Add test bookings with different statuses
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1', status: BookingStatus.pending),
        createTestBooking(id: 'test-2', carId: 'car-2', status: BookingStatus.confirmed),
        createTestBooking(id: 'test-3', carId: 'car-3', status: BookingStatus.active),
        createTestBooking(id: 'test-4', carId: 'car-4', status: BookingStatus.completed),
        createTestBooking(id: 'test-5', carId: 'car-5', status: BookingStatus.cancelled),
      ]);
      
      // Fetch bookings
      await bookingProvider.fetchUserBookings();
      
      // Verify active bookings
      expect(bookingProvider.activeBookings.length, equals(3));
      expect(bookingProvider.activeBookings.map((b) => b.id).toList(), 
          containsAll(['test-1', 'test-2', 'test-3']));
    });

    test('completedBookings returns only completed bookings', () async {
      // Add test bookings with different statuses
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1', status: BookingStatus.pending),
        createTestBooking(id: 'test-2', carId: 'car-2', status: BookingStatus.completed),
        createTestBooking(id: 'test-3', carId: 'car-3', status: BookingStatus.cancelled),
      ]);
      
      // Fetch bookings
      await bookingProvider.fetchUserBookings();
      
      // Verify completed bookings
      expect(bookingProvider.completedBookings.length, equals(1));
      expect(bookingProvider.completedBookings.first.id, equals('test-2'));
    });

    test('cancelledBookings returns only cancelled bookings', () async {
      // Add test bookings with different statuses
      mockRepository.addTestBookings([
        createTestBooking(id: 'test-1', carId: 'car-1', status: BookingStatus.pending),
        createTestBooking(id: 'test-2', carId: 'car-2', status: BookingStatus.completed),
        createTestBooking(id: 'test-3', carId: 'car-3', status: BookingStatus.cancelled),
      ]);
      
      // Fetch bookings
      await bookingProvider.fetchUserBookings();
      
      // Verify cancelled bookings
      expect(bookingProvider.cancelledBookings.length, equals(1));
      expect(bookingProvider.cancelledBookings.first.id, equals('test-3'));
    });
  });
}
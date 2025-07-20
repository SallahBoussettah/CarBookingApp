import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/repositories/booking_repository.dart';
import 'package:car_booking_app/repositories/mockup_booking_repository.dart';

/// Enum representing the loading state of booking data
enum BookingLoadingStatus {
  /// Initial state, no data has been loaded yet
  initial,
  
  /// Data is currently being loaded
  loading,
  
  /// Data has been successfully loaded
  loaded,
  
  /// An error occurred while loading data
  error
}

/// Provider for managing booking data and operations
class BookingProvider with ChangeNotifier {
  /// The booking repository used to fetch and store booking data
  final BookingRepository _bookingRepository;
  
  /// List of user bookings
  List<Booking> _bookings = [];
  
  /// Currently selected booking
  Booking? _selectedBooking;
  
  /// Current booking form data
  Map<String, dynamic> _bookingFormData = {};
  
  /// Current loading status
  BookingLoadingStatus _status = BookingLoadingStatus.initial;
  
  /// Error message if loading fails
  String? _errorMessage;
  
  /// Constructor with optional repository parameter
  BookingProvider({BookingRepository? bookingRepository}) 
      : _bookingRepository = bookingRepository ?? MockupBookingRepository();
  
  /// Get all user bookings
  List<Booking> get bookings => _bookings;
  
  /// Get active bookings (not cancelled or completed)
  List<Booking> get activeBookings => 
      _bookings.where((booking) => booking.status.isActive).toList();
  
  /// Get completed bookings
  List<Booking> get completedBookings => 
      _bookings.where((booking) => booking.status == BookingStatus.completed).toList();
  
  /// Get cancelled bookings
  List<Booking> get cancelledBookings => 
      _bookings.where((booking) => booking.status == BookingStatus.cancelled).toList();
  
  /// Get the currently selected booking
  Booking? get selectedBooking => _selectedBooking;
  
  /// Get the current booking form data
  Map<String, dynamic> get bookingFormData => _bookingFormData;
  
  /// Get the current loading status
  BookingLoadingStatus get status => _status;
  
  /// Get the current error message
  String? get errorMessage => _errorMessage;
  
  /// Fetch all user bookings from the repository
  Future<void> fetchUserBookings() async {
    try {
      _status = BookingLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      final bookings = await _bookingRepository.getUserBookings();
      _bookings = bookings;
      _status = BookingLoadingStatus.loaded;
    } catch (e) {
      _status = BookingLoadingStatus.error;
      _errorMessage = 'Failed to load bookings: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }
  
  /// Fetch a specific booking by ID
  Future<void> fetchBookingById(String id) async {
    try {
      _status = BookingLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      final booking = await _bookingRepository.getBookingById(id);
      if (booking != null) {
        _selectedBooking = booking;
        _status = BookingLoadingStatus.loaded;
      } else {
        _status = BookingLoadingStatus.error;
        _errorMessage = 'Booking not found';
      }
    } catch (e) {
      _status = BookingLoadingStatus.error;
      _errorMessage = 'Failed to load booking details: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }
  
  /// Create a new booking
  Future<String?> createBooking(Booking booking) async {
    try {
      _status = BookingLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      // Validate booking
      if (!booking.isValid()) {
        _status = BookingLoadingStatus.error;
        _errorMessage = 'Invalid booking: ${booking.getValidationErrors().join(', ')}';
        notifyListeners();
        return null;
      }
      
      // Create booking
      final bookingId = await _bookingRepository.createBooking(booking);
      
      // Update local state
      _bookings = await _bookingRepository.getUserBookings();
      _selectedBooking = await _bookingRepository.getBookingById(bookingId);
      _status = BookingLoadingStatus.loaded;
      notifyListeners();
      
      return bookingId;
    } catch (e) {
      _status = BookingLoadingStatus.error;
      _errorMessage = 'Failed to create booking: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
  
  /// Cancel a booking
  Future<bool> cancelBooking(String id) async {
    try {
      _status = BookingLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      // Cancel booking
      final success = await _bookingRepository.cancelBooking(id);
      
      if (success) {
        // Refresh bookings list
        await fetchUserBookings();
        
        // Update selected booking if it's the one that was cancelled
        if (_selectedBooking != null && _selectedBooking!.id == id) {
          await fetchBookingById(id);
        }
      } else {
        _status = BookingLoadingStatus.error;
        _errorMessage = 'Failed to cancel booking';
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _status = BookingLoadingStatus.error;
      _errorMessage = 'Failed to cancel booking: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// Set the selected booking
  void selectBooking(Booking booking) {
    _selectedBooking = booking;
    notifyListeners();
  }
  
  /// Clear the selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }
  
  /// Update booking form data
  void updateBookingFormData(Map<String, dynamic> formData) {
    _bookingFormData = {..._bookingFormData, ...formData};
    notifyListeners();
  }
  
  /// Clear booking form data
  void clearBookingFormData() {
    _bookingFormData = {};
    notifyListeners();
  }
  
  /// Calculate booking cost based on form data
  double calculateBookingCost(double pricePerDay) {
    if (_bookingFormData.containsKey('pickupDate') && 
        _bookingFormData.containsKey('returnDate') &&
        _bookingFormData.containsKey('pickupTime') &&
        _bookingFormData.containsKey('returnTime')) {
      
      return Booking.calculateCost(
        pickupDate: _bookingFormData['pickupDate'] as DateTime,
        returnDate: _bookingFormData['returnDate'] as DateTime,
        pickupTime: _bookingFormData['pickupTime'] as TimeOfDay,
        returnTime: _bookingFormData['returnTime'] as TimeOfDay,
        pricePerDay: pricePerDay,
      );
    }
    
    return 0.0;
  }
  
  /// Validate booking form data
  List<String> validateBookingFormData() {
    List<String> errors = [];
    
    // Check if required fields are present
    if (!_bookingFormData.containsKey('carId') || _bookingFormData['carId'] == null) {
      errors.add('Car must be selected');
    }
    
    if (!_bookingFormData.containsKey('pickupDate') || _bookingFormData['pickupDate'] == null) {
      errors.add('Pickup date must be selected');
    }
    
    if (!_bookingFormData.containsKey('returnDate') || _bookingFormData['returnDate'] == null) {
      errors.add('Return date must be selected');
    }
    
    if (!_bookingFormData.containsKey('pickupTime') || _bookingFormData['pickupTime'] == null) {
      errors.add('Pickup time must be selected');
    }
    
    if (!_bookingFormData.containsKey('returnTime') || _bookingFormData['returnTime'] == null) {
      errors.add('Return time must be selected');
    }
    
    // If all required fields are present, validate date/time combinations
    if (errors.isEmpty) {
      final pickupDate = _bookingFormData['pickupDate'] as DateTime;
      final returnDate = _bookingFormData['returnDate'] as DateTime;
      final pickupTime = _bookingFormData['pickupTime'] as TimeOfDay;
      final returnTime = _bookingFormData['returnTime'] as TimeOfDay;
      
      // Check if return date is before pickup date
      if (returnDate.isBefore(pickupDate)) {
        errors.add('Return date cannot be before pickup date');
      }
      
      // Check if dates are the same but return time is before pickup time
      if (Booking.isSameDay(pickupDate, returnDate) && 
          Booking.isTimeBefore(returnTime, pickupTime)) {
        errors.add('Return time cannot be before pickup time on the same day');
      }
    }
    
    return errors;
  }
  
  /// Create a booking from form data
  Future<String?> createBookingFromFormData(double pricePerDay) async {
    // Validate form data
    final errors = validateBookingFormData();
    if (errors.isNotEmpty) {
      _status = BookingLoadingStatus.error;
      _errorMessage = errors.join(', ');
      notifyListeners();
      return null;
    }
    
    // Calculate total cost
    final totalCost = calculateBookingCost(pricePerDay);
    
    // Create booking object with a temporary ID for testing
    // In a real app, we would let the repository generate the ID
    final booking = Booking(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      carId: _bookingFormData['carId'] as String,
      pickupDate: _bookingFormData['pickupDate'] as DateTime,
      returnDate: _bookingFormData['returnDate'] as DateTime,
      pickupTime: _bookingFormData['pickupTime'] as TimeOfDay,
      returnTime: _bookingFormData['returnTime'] as TimeOfDay,
      totalCost: totalCost,
      status: BookingStatus.pending,
    );
    
    // Create booking
    return createBooking(booking);
  }
  
  /// Reset the provider state
  void reset() {
    _bookings = [];
    _selectedBooking = null;
    _bookingFormData = {};
    _status = BookingLoadingStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
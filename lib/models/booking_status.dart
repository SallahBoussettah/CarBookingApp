/// Represents the status of a car booking
enum BookingStatus {
  /// Booking has been created but not confirmed
  pending,
  
  /// Booking has been confirmed
  confirmed,
  
  /// Car has been picked up
  active,
  
  /// Booking has been completed
  completed,
  
  /// Booking has been cancelled
  cancelled
}

/// Extension methods for BookingStatus
extension BookingStatusExtension on BookingStatus {
  /// Returns a user-friendly string representation of the booking status
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  /// Returns true if the booking is considered active (not cancelled or completed)
  bool get isActive {
    return this == BookingStatus.pending || 
           this == BookingStatus.confirmed || 
           this == BookingStatus.active;
  }
}
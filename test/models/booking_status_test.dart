import 'package:car_booking_app/models/booking_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingStatus', () {
    test('should have correct display names', () {
      expect(BookingStatus.pending.displayName, 'Pending');
      expect(BookingStatus.confirmed.displayName, 'Confirmed');
      expect(BookingStatus.active.displayName, 'Active');
      expect(BookingStatus.completed.displayName, 'Completed');
      expect(BookingStatus.cancelled.displayName, 'Cancelled');
    });

    test('should correctly identify active statuses', () {
      expect(BookingStatus.pending.isActive, true);
      expect(BookingStatus.confirmed.isActive, true);
      expect(BookingStatus.active.isActive, true);
      expect(BookingStatus.completed.isActive, false);
      expect(BookingStatus.cancelled.isActive, false);
    });
  });
}
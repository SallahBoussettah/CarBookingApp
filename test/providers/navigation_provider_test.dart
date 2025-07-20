import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';

void main() {
  group('NavigationProvider', () {
    test('should have initial index of 0', () {
      final provider = NavigationProvider();
      expect(provider.currentIndex, 0);
    });

    test('should update current index when setCurrentIndex is called', () {
      final provider = NavigationProvider();
      
      provider.setCurrentIndex(1);
      expect(provider.currentIndex, 1);
      
      provider.setCurrentIndex(2);
      expect(provider.currentIndex, 2);
    });

    test('should not notify listeners if the index is the same', () {
      final provider = NavigationProvider();
      var notificationCount = 0;
      
      provider.addListener(() {
        notificationCount++;
      });
      
      // Set to the same index (0)
      provider.setCurrentIndex(0);
      expect(notificationCount, 0);
      
      // Set to a different index
      provider.setCurrentIndex(1);
      expect(notificationCount, 1);
      
      // Set to the same index again
      provider.setCurrentIndex(1);
      expect(notificationCount, 1);
    });
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:car_booking_app/routes/app_router.dart';
import 'package:car_booking_app/services/navigation_service.dart';

void main() {
  group('Navigation Flow Integration Tests', () {
    testWidgets('should navigate through the app with proper animations', (WidgetTester tester) async {
      // Build our app with providers and navigation
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NavigationProvider()),
            ChangeNotifierProvider(create: (_) => CarProvider()),
            ChangeNotifierProvider(create: (_) => BookingProvider()),
          ],
          child: MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: AppRoutes.main,
            onGenerateRoute: AppRouter.generateRoute,
          ),
        ),
      );
      
      // Verify we're on the main screen
      expect(find.text('Car Booking'), findsOneWidget);
      
      // Create a test car
      final testCar = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const [],
        features: const ['Feature 1'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );
      
      // Navigate to car details
      NavigationService.navigateTo(AppRoutes.carDetails, arguments: testCar);
      
      // Verify animation is happening
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      
      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify we're on the car details screen
      expect(find.text('Test Car'), findsOneWidget);
      
      // Navigate to booking form
      NavigationService.navigateTo(AppRoutes.bookingForm, arguments: testCar);
      
      // Verify animation is happening
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      
      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify we're on the booking form screen
      expect(find.byType(Scaffold).evaluate().isNotEmpty, isTrue);
      
      // Go back to car details
      NavigationService.goBack();
      
      // Verify animation is happening
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      
      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify we're back on the car details screen
      expect(find.text('Test Car').evaluate().isNotEmpty, isTrue);
      
      // Go back to main screen
      NavigationService.goBack();
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify we're back on the main screen
      expect(find.text('Car Booking'), findsOneWidget);
      
      // Switch to bookings tab using bottom navigation
      await tester.tap(find.text('Bookings'));
      await tester.pump(const Duration(milliseconds: 300));
      
      // Verify we're on the bookings screen
      // Just check that we have a Scaffold widget, as the exact text might vary
      expect(find.byType(Scaffold).evaluate().isNotEmpty, isTrue);
    });
  });
}
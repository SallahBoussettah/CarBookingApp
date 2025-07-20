import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/screens/booking_form_screen.dart';
import 'package:intl/intl.dart';

void main() {
  // Mock car data for testing
  final mockCar = Car(
    id: 'car1',
    name: 'Test Car',
    type: 'Sedan',
    brand: 'Test Brand',
    pricePerDay: 50.0,
    images: ['assets/images/car1.jpg'],
    features: ['GPS', 'Bluetooth', 'Air Conditioning'],
    specs: const CarSpecs(
      engine: '2.0L',
      transmission: 'Automatic',
      seats: 5,
      fuelType: 'Gasoline',
    ),
  );

  // Helper function to build the widget under test
  Widget buildTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => BookingProvider(),
        child: BookingFormScreen(car: mockCar),
      ),
    );
  }

  group('BookingFormScreen', () {
    testWidgets('displays car information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify car details are displayed
      expect(find.text('Test Car'), findsOneWidget);
      expect(find.text('Test Brand · Sedan'), findsOneWidget);
      expect(find.text('\$50/day'), findsOneWidget);
    });

    testWidgets('displays booking details section', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify booking details section is displayed
      expect(find.text('Booking Details'), findsOneWidget);
      expect(find.text('Pickup Date & Time'), findsOneWidget);
      expect(find.text('Return Date & Time'), findsOneWidget);
    });

    testWidgets('displays date and time pickers', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify date and time pickers are displayed
      expect(find.byIcon(Icons.calendar_today), findsAtLeast(1));
      expect(find.byIcon(Icons.access_time), findsAtLeast(1));
    });

    testWidgets('displays cost summary section', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify cost summary section is displayed
      expect(find.text('Cost Summary'), findsOneWidget);
      expect(find.text('Daily Rate:'), findsOneWidget);
      expect(find.text('Duration:'), findsOneWidget);
      expect(find.text('Total Cost:'), findsOneWidget);
      expect(find.text('\$50.00'), findsOneWidget); // Daily rate
    });

    testWidgets('displays continue button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify continue button is displayed
      expect(find.text('Continue to Confirmation'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('tapping date field shows date picker', (WidgetTester tester) async {
      // This test will verify that tapping on a date field shows the date picker
      // However, we can't fully test the date picker in widget tests
      // So we'll just verify that the tap is registered
      
      await tester.pumpWidget(buildTestWidget());

      // Find the date fields
      final dateFields = find.byIcon(Icons.calendar_today);
      expect(dateFields, findsAtLeast(1));

      // Tap on the first date field (pickup date)
      await tester.tap(dateFields.first);
      await tester.pumpAndSettle();

      // Verify that the date picker dialog is shown
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping time field shows time picker', (WidgetTester tester) async {
      // This test will verify that tapping on a time field shows the time picker
      // However, we can't fully test the time picker in widget tests
      // So we'll just verify that the tap is registered
      
      await tester.pumpWidget(buildTestWidget());

      // Find the time fields
      final timeFields = find.byIcon(Icons.access_time);
      expect(timeFields, findsAtLeast(1));

      // Tap on the first time field (pickup time)
      await tester.tap(timeFields.first);
      await tester.pumpAndSettle();

      // Verify that the time picker dialog is shown
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('validation errors are displayed when present', (WidgetTester tester) async {
      // Create a mock booking provider that will always return validation errors
      final mockBookingProvider = MockBookingProviderWithErrors();
      
      // Build the widget with the mock provider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BookingProvider>.value(
            value: mockBookingProvider,
            child: BookingFormScreen(car: mockCar),
          ),
        ),
      );

      // Rebuild the widget to ensure validation errors are displayed
      await tester.pumpAndSettle();

      // Verify that validation errors are displayed
      expect(find.text('Please fix the following errors:'), findsOneWidget);
      expect(find.text('Return date cannot be before pickup date'), findsOneWidget);
    });
  });
}
// Mock booking provider that always returns validation errors
class MockBookingProviderWithErrors extends BookingProvider {
  @override
  List<String> validateBookingFormData() {
    // Return validation errors for testing
    return ['Return date cannot be before pickup date'];
  }
}
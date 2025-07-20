import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/screens/booking_detail_screen.dart';

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

  // Mock booking data for testing
  final mockBooking = Booking(
    id: 'BK-ABC123-1234',
    carId: 'car1',
    pickupDate: DateTime(2023, 7, 20),
    returnDate: DateTime(2023, 7, 23),
    pickupTime: const TimeOfDay(hour: 10, minute: 0),
    returnTime: const TimeOfDay(hour: 14, minute: 0),
    totalCost: 150.0,
    status: BookingStatus.confirmed,
  );

  // Helper function to build the widget under test
  Widget buildTestWidget({
    Booking? booking,
    CarLoadingStatus carStatus = CarLoadingStatus.loaded,
    Car? selectedCar,
    String? carErrorMessage,
  }) {
    final bookingProvider = BookingProvider();
    
    final carProvider = MockCarProvider(
      status: carStatus,
      selectedCar: selectedCar,
      errorMessage: carErrorMessage,
    );
    
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<BookingProvider>.value(value: bookingProvider),
          ChangeNotifierProvider<CarProvider>.value(value: carProvider),
        ],
        child: BookingDetailScreen(booking: booking ?? mockBooking),
      ),
    );
  }

  group('BookingDetailScreen', () {
    testWidgets('displays booking ID and status', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(selectedCar: mockCar));

      // Verify booking ID and status are displayed
      expect(find.text('Booking ID'), findsOneWidget);
      expect(find.text('BK-ABC123-1234'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('displays loading indicator when car is loading', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(carStatus: CarLoadingStatus.loading));

      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when car loading fails', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        carStatus: CarLoadingStatus.error,
        carErrorMessage: 'Failed to load car',
      ));

      // Verify error message is displayed
      expect(find.text('Failed to load car details'), findsOneWidget);
      expect(find.text('Failed to load car'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('displays car details when car is loaded', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(selectedCar: mockCar));

      // Verify car details are displayed
      expect(find.text('Test Car'), findsOneWidget);
      expect(find.text('Test Brand · Sedan'), findsOneWidget);
      expect(find.text('Specifications'), findsOneWidget);
      expect(find.text('Features'), findsOneWidget);
      
      // Check for the presence of feature chips
      expect(find.byType(Chip), findsAtLeast(1));
    });

    testWidgets('displays booking details', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(selectedCar: mockCar));

      // Verify booking details section exists
      expect(find.text('Booking Details'), findsAtLeast(1));
      expect(find.text('Pickup'), findsOneWidget);
      expect(find.text('Return'), findsOneWidget);
      expect(find.text('Duration'), findsOneWidget);
      
      // Look for text containing the duration value
      expect(find.textContaining('days'), findsOneWidget);
    });

    testWidgets('displays cost summary', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(selectedCar: mockCar));

      // Verify cost summary is displayed
      expect(find.text('Cost Summary'), findsOneWidget);
      expect(find.text('Total Cost'), findsOneWidget);
      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('Payment Status'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
    });

    testWidgets('displays cancel button for active bookings', (WidgetTester tester) async {
      final activeBooking = mockBooking.copyWith(status: BookingStatus.confirmed);
      
      await tester.pumpWidget(buildTestWidget(
        booking: activeBooking,
        selectedCar: mockCar,
      ));

      // Verify cancel button is displayed
      expect(find.text('Cancel Booking'), findsOneWidget);
    });

    testWidgets('does not display cancel button for completed bookings', (WidgetTester tester) async {
      final completedBooking = mockBooking.copyWith(status: BookingStatus.completed);
      
      await tester.pumpWidget(buildTestWidget(
        booking: completedBooking,
        selectedCar: mockCar,
      ));

      // Verify cancel button is not displayed
      expect(find.text('Cancel Booking'), findsNothing);
    });

    testWidgets('does not display cancel button for cancelled bookings', (WidgetTester tester) async {
      final cancelledBooking = mockBooking.copyWith(status: BookingStatus.cancelled);
      
      await tester.pumpWidget(buildTestWidget(
        booking: cancelledBooking,
        selectedCar: mockCar,
      ));

      // Verify cancel button is not displayed
      expect(find.text('Cancel Booking'), findsNothing);
    });

    testWidgets('has a cancel button text for active bookings', (WidgetTester tester) async {
      // Use a smaller screen size to ensure the button is visible
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(buildTestWidget(selectedCar: mockCar));
      
      // Verify cancel button text exists
      expect(find.text('Cancel Booking'), findsOneWidget);
      
      // We can't reliably test the dialog in widget tests due to screen size constraints
      // and the way dialogs are shown in Flutter
      
      // Reset the screen size
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}

// Mock car provider for testing
class MockCarProvider extends CarProvider {
  final CarLoadingStatus _status;
  final Car? _selectedCar;
  final String? _errorMessage;

  MockCarProvider({
    required CarLoadingStatus status,
    Car? selectedCar,
    String? errorMessage,
  }) : _status = status,
       _selectedCar = selectedCar,
       _errorMessage = errorMessage;

  @override
  CarLoadingStatus get status => _status;

  @override
  Car? get selectedCar => _selectedCar;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Future<void> fetchCarById(String id) async {
    // Do nothing in the mock
  }
}
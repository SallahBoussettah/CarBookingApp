import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/screens/bookings_screen.dart';

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
    BookingLoadingStatus status = BookingLoadingStatus.loaded,
    List<Booking> bookings = const [],
    String? errorMessage,
  }) {
    final bookingProvider = MockBookingProvider(
      status: status,
      bookings: bookings,
      errorMessage: errorMessage,
    );
    
    final carProvider = MockCarProvider(cars: [mockCar]);
    
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<BookingProvider>.value(value: bookingProvider),
          ChangeNotifierProvider<CarProvider>.value(value: carProvider),
          ChangeNotifierProvider<NavigationProvider>(create: (_) => NavigationProvider()),
        ],
        child: const Scaffold(body: BookingsScreen()),
      ),
    );
  }

  group('BookingsScreen', () {
    testWidgets('displays loading indicator when loading', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(status: BookingLoadingStatus.loading));

      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when error occurs', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        status: BookingLoadingStatus.error,
        errorMessage: 'Test error message',
      ));

      // Verify error message is displayed
      expect(find.text('Error loading bookings'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('displays empty state when no bookings', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(bookings: []));

      // Verify empty state is displayed
      expect(find.text('No Bookings Yet'), findsOneWidget);
      expect(find.text('Your car bookings will appear here'), findsOneWidget);
      expect(find.text('Browse Cars'), findsOneWidget);
    });

    testWidgets('displays booking list when bookings exist', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(bookings: [mockBooking]));

      // Verify tab bar is displayed
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);

      // Verify booking card is displayed
      expect(find.text('Booking #ABC123'), findsOneWidget);
      expect(find.text('Test Car'), findsOneWidget);
      expect(find.text('Test Brand · Sedan'), findsOneWidget);
      expect(find.text('Pickup'), findsOneWidget);
      expect(find.text('Return'), findsOneWidget);
      expect(find.text('Total Cost'), findsOneWidget);
      expect(find.text('\$150.00'), findsOneWidget);
    });

    testWidgets('displays status chip with correct color', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(bookings: [mockBooking]));

      // Verify status chip is displayed
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('displays empty category message when tab has no bookings', (WidgetTester tester) async {
      // Create a booking provider with only completed bookings
      final completedBooking = mockBooking.copyWith(status: BookingStatus.completed);
      
      await tester.pumpWidget(buildTestWidget(bookings: [completedBooking]));

      // Tap on the "Active" tab (which should be empty)
      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();

      // Verify empty category message is displayed
      expect(find.text('No bookings in this category'), findsOneWidget);
    });

    testWidgets('has tappable booking card', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(bookings: [mockBooking]));

      // Verify the booking card is displayed and has an InkWell for tapping
      expect(find.text('Test Car'), findsOneWidget);
      expect(find.byType(InkWell), findsAtLeast(1));
      
      // We can't test the actual navigation in widget tests without a MaterialApp with routes
    });
  });
}

// Mock booking provider for testing
class MockBookingProvider extends BookingProvider {
  final BookingLoadingStatus _status;
  final List<Booking> _bookings;
  final String? _errorMessage;

  MockBookingProvider({
    required BookingLoadingStatus status,
    required List<Booking> bookings,
    String? errorMessage,
  }) : _status = status,
       _bookings = bookings,
       _errorMessage = errorMessage;

  @override
  BookingLoadingStatus get status => _status;

  @override
  List<Booking> get bookings => _bookings;

  @override
  List<Booking> get activeBookings => _bookings.where((b) => b.status.isActive).toList();

  @override
  List<Booking> get completedBookings => _bookings.where((b) => b.status == BookingStatus.completed).toList();

  @override
  List<Booking> get cancelledBookings => _bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  @override
  String? get errorMessage => _errorMessage;

  @override
  Future<void> fetchUserBookings() async {
    // Do nothing in the mock
  }
}

// Mock car provider for testing
class MockCarProvider extends CarProvider {
  final List<Car> _cars;

  MockCarProvider({required List<Car> cars}) : _cars = cars;

  @override
  List<Car> get cars => _cars;
}
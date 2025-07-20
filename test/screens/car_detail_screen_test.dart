import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/screens/car_detail_screen.dart';
import 'package:car_booking_app/widgets/car_image_carousel.dart';
import 'package:car_booking_app/widgets/car_specifications.dart';
import 'package:car_booking_app/widgets/car_features_list.dart';

void main() {
  // Mock car data for testing
  final mockCar = Car(
    id: 'car1',
    name: 'Test Car',
    type: 'Sedan',
    brand: 'Test Brand',
    pricePerDay: 50.0,
    images: ['assets/images/car1.jpg', 'assets/images/car2.jpg'],
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
        create: (_) => CarProvider(),
        child: CarDetailScreen(car: mockCar),
      ),
    );
  }

  group('CarDetailScreen', () {
    testWidgets('displays car name and brand', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Test Car'), findsOneWidget);
      expect(find.text('Test Brand'), findsOneWidget);
      expect(find.text('Sedan'), findsOneWidget);
    });

    testWidgets('displays price information', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Price per day'), findsOneWidget);
      expect(find.text('\$50'), findsOneWidget);
    });

    testWidgets('displays car specifications section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Specifications'), findsOneWidget);
      expect(find.byType(CarSpecifications), findsOneWidget);
    });

    testWidgets('displays car features section', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Features'), findsOneWidget);
      expect(find.byType(CarFeaturesList), findsOneWidget);
    });

    testWidgets('displays image carousel', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CarImageCarousel), findsOneWidget);
    });

    testWidgets('displays Book Now button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Book Now'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('Book Now button exists and is properly styled', (
      WidgetTester tester,
    ) async {
      // This test will verify the Book Now button exists and has proper styling
      await tester.pumpWidget(buildTestWidget());

      // Find the Book Now button
      final bookNowButton = find.text('Book Now');
      expect(bookNowButton, findsOneWidget);

      // Find the button widget
      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Verify button styling
      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.style, isNotNull);

      // Verify button has calendar icon
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });
  });
}

// Mock classes for testing
class MockNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

class MockCarProvider extends CarProvider {
  final Function(Car) onSelectCar;

  MockCarProvider({required this.onSelectCar});

  @override
  void selectCar(Car car) {
    onSelectCar(car);
    super.selectCar(car);
  }
}

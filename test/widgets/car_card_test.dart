import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/widgets/car_card.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/routes/app_routes.dart';

void main() {
  group('CarCard Widget Tests', () {
    late Car testCar;

    setUp(() {
      testCar = const Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: ['assets/images/test_car.jpg'],
        features: ['GPS', 'AC'],
        specs: CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );
    });

    testWidgets('displays car information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(car: testCar),
          ),
        ),
      );

      // Verify car name is displayed
      expect(find.text('Test Car'), findsOneWidget);
      
      // Verify car type is displayed
      expect(find.text('Sedan'), findsOneWidget);
      
      // Verify price is displayed
      expect(find.text('\$50/day'), findsOneWidget);
      
      // Verify arrow icon is displayed
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('displays placeholder when image fails to load', (WidgetTester tester) async {
      final carWithoutImage = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const [], // Empty images list
        features: const ['GPS', 'AC'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(car: carWithoutImage),
          ),
        ),
      );

      // Verify placeholder is displayed
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      expect(find.text('No Image'), findsOneWidget);
    });

    testWidgets('navigates to car details when tapped', (WidgetTester tester) async {
      String? navigatedRoute;
      Car? passedArguments;

      // Create a car with no images to avoid asset loading issues
      final carWithoutImage = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const [], // Empty images list to avoid asset loading
        features: const ['GPS', 'AC'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(car: carWithoutImage),
          ),
          onGenerateRoute: (settings) {
            navigatedRoute = settings.name;
            passedArguments = settings.arguments as Car?;
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Text('Car Details'),
              ),
            );
          },
        ),
      );

      // Wait for widget to build
      await tester.pump();

      // Tap on the car card
      await tester.tap(find.byType(CarCard));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigatedRoute, equals(AppRoutes.carDetails));
      expect(passedArguments, equals(carWithoutImage));
    });

    testWidgets('handles long car names with ellipsis', (WidgetTester tester) async {
      final carWithLongName = Car(
        id: '1',
        name: 'This is a very long car name that should be truncated',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const ['assets/images/test_car.jpg'],
        features: const ['GPS', 'AC'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: CarCard(car: carWithLongName),
            ),
          ),
        ),
      );

      // Find the text widget and verify it has overflow handling
      final nameTextWidget = tester.widget<Text>(
        find.text('This is a very long car name that should be truncated'),
      );
      expect(nameTextWidget.overflow, equals(TextOverflow.ellipsis));
      expect(nameTextWidget.maxLines, equals(1));
    });

    testWidgets('displays correct price formatting', (WidgetTester tester) async {
      final carWithDecimalPrice = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 75.99,
        images: const ['assets/images/test_car.jpg'],
        features: const ['GPS', 'AC'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(car: carWithDecimalPrice),
          ),
        ),
      );

      // Verify price is formatted without decimals
      expect(find.text('\$76/day'), findsOneWidget);
    });
  });
}
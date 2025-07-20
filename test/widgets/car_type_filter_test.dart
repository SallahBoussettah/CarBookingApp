import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/widgets/car_type_filter.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';

void main() {
  group('CarTypeFilter Widget Tests', () {
    late CarProvider carProvider;
    late List<Car> testCars;

    setUp(() {
      carProvider = CarProvider();
      testCars = [
        const Car(
          id: '1',
          name: 'BMW 3 Series',
          type: 'Sedan',
          brand: 'BMW',
          pricePerDay: 80.0,
          images: ['assets/images/bmw.jpg'],
          features: ['GPS', 'AC'],
          specs: CarSpecs(
            engine: '2.0L',
            transmission: 'Automatic',
            seats: 5,
            fuelType: 'Gasoline',
          ),
        ),
        const Car(
          id: '2',
          name: 'Toyota RAV4',
          type: 'SUV',
          brand: 'Toyota',
          pricePerDay: 70.0,
          images: ['assets/images/toyota.jpg'],
          features: ['GPS', 'AC'],
          specs: CarSpecs(
            engine: '2.5L',
            transmission: 'Automatic',
            seats: 5,
            fuelType: 'Gasoline',
          ),
        ),
        const Car(
          id: '3',
          name: 'Honda Civic',
          type: 'Sedan',
          brand: 'Honda',
          pricePerDay: 60.0,
          images: ['assets/images/honda.jpg'],
          features: ['GPS', 'AC'],
          specs: CarSpecs(
            engine: '1.5L',
            transmission: 'Manual',
            seats: 5,
            fuelType: 'Gasoline',
          ),
        ),
      ];
    });

    testWidgets('shows nothing when no car types are available', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Verify no filter chips are displayed
      expect(find.byType(FilterChip), findsNothing);
    });

    testWidgets('displays all available car types as filter chips', (WidgetTester tester) async {
      // Simulate cars being loaded
      carProvider.cars.addAll(testCars);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Verify "All" chip is displayed
      expect(find.text('All'), findsOneWidget);
      
      // Verify type chips are displayed
      expect(find.text('Sedan'), findsOneWidget);
      expect(find.text('SUV'), findsOneWidget);
      
      // Verify total number of filter chips (All + 2 types)
      expect(find.byType(FilterChip), findsNWidgets(3));
    });

    testWidgets('selects "All" filter by default', (WidgetTester tester) async {
      // Simulate cars being loaded
      carProvider.cars.addAll(testCars);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Find the "All" filter chip
      final allChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'All'),
      );

      // Verify "All" is selected by default
      expect(allChip.selected, isTrue);
      expect(carProvider.selectedType, isNull);
    });

    testWidgets('updates selected type when type chip is tapped', (WidgetTester tester) async {
      // Simulate cars being loaded
      carProvider.cars.addAll(testCars);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Tap on "Sedan" filter chip
      await tester.tap(find.widgetWithText(FilterChip, 'Sedan'));
      await tester.pump();

      // Verify provider was updated
      expect(carProvider.selectedType, equals('Sedan'));
    });

    testWidgets('deselects type when same chip is tapped again', (WidgetTester tester) async {
      // Simulate cars being loaded and type selected
      carProvider.cars.addAll(testCars);
      carProvider.setTypeFilter('Sedan');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Tap on "Sedan" filter chip again
      await tester.tap(find.widgetWithText(FilterChip, 'Sedan'));
      await tester.pump();

      // Verify type filter was cleared
      expect(carProvider.selectedType, isNull);
    });

    testWidgets('selects "All" when All chip is tapped', (WidgetTester tester) async {
      // Simulate cars being loaded and type selected
      carProvider.cars.addAll(testCars);
      carProvider.setTypeFilter('Sedan');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Tap on "All" filter chip
      await tester.tap(find.widgetWithText(FilterChip, 'All'));
      await tester.pump();

      // Verify type filter was cleared
      expect(carProvider.selectedType, isNull);
    });

    testWidgets('displays correct visual state for selected chip', (WidgetTester tester) async {
      // Simulate cars being loaded and type selected
      carProvider.cars.addAll(testCars);
      carProvider.setTypeFilter('SUV');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Find the SUV filter chip
      final suvChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'SUV'),
      );

      // Verify SUV chip is selected
      expect(suvChip.selected, isTrue);

      // Find the All filter chip
      final allChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'All'),
      );

      // Verify All chip is not selected
      expect(allChip.selected, isFalse);
    });

    testWidgets('is scrollable horizontally', (WidgetTester tester) async {
      // Simulate cars being loaded
      carProvider.cars.addAll(testCars);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarTypeFilter(),
            ),
          ),
        ),
      );

      // Verify ListView is present and scrollable
      expect(find.byType(ListView), findsOneWidget);
      
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, equals(Axis.horizontal));
    });
  });
}
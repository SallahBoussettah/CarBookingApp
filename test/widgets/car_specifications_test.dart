import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/widgets/car_specifications.dart';

void main() {
  group('CarSpecifications', () {
    testWidgets('displays all car specifications correctly', (WidgetTester tester) async {
      // Mock car specs
      const mockSpecs = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: CarSpecifications(specs: mockSpecs),
            ),
          ),
        ),
      );

      // Verify all spec labels are displayed
      expect(find.text('Engine'), findsOneWidget);
      expect(find.text('Transmission'), findsOneWidget);
      expect(find.text('Seats'), findsOneWidget);
      expect(find.text('Fuel Type'), findsOneWidget);
      
      // Verify all spec values are displayed
      expect(find.text('2.0L Turbo'), findsOneWidget);
      expect(find.text('Automatic'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Gasoline'), findsOneWidget);
      
      // Verify icons are displayed
      expect(find.byIcon(Icons.settings), findsOneWidget); // Engine
      expect(find.byIcon(Icons.sync), findsOneWidget); // Transmission
      expect(find.byIcon(Icons.airline_seat_recline_normal), findsOneWidget); // Seats
      expect(find.byIcon(Icons.local_gas_station), findsOneWidget); // Fuel Type
    });

    testWidgets('has proper layout with two rows of two specs each', (WidgetTester tester) async {
      // Mock car specs
      const mockSpecs = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: CarSpecifications(specs: mockSpecs),
            ),
          ),
        ),
      );

      // Find all rows in the widget
      final rows = find.byType(Row);
      
      // We should have at least 2 rows (one for each pair of specs)
      expect(rows, findsAtLeast(2));
      
      // Verify the container has a border and rounded corners
      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration as BoxDecoration;
      
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.border, isNotNull);
    });
  });
}
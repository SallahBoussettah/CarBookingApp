import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/widgets/car_features_list.dart';

void main() {
  group('CarFeaturesList', () {
    testWidgets('displays all features correctly', (WidgetTester tester) async {
      // Mock features
      final mockFeatures = [
        'GPS Navigation',
        'Bluetooth',
        'Air Conditioning',
        'Leather Seats',
        'Backup Camera',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarFeaturesList(features: mockFeatures),
            ),
          ),
        ),
      );

      // Verify all features are displayed
      for (final feature in mockFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
      
      // Verify the grid view is used
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays icons for features', (WidgetTester tester) async {
      // Mock features
      final mockFeatures = [
        'GPS Navigation',
        'Bluetooth',
        'Air Conditioning',
        'Leather Seats',
        'Backup Camera',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarFeaturesList(features: mockFeatures),
            ),
          ),
        ),
      );

      // Verify that icons are displayed (at least one icon per feature)
      expect(find.byType(Icon), findsAtLeast(mockFeatures.length));
      
      // Verify all features are displayed
      for (final feature in mockFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
    });

    testWidgets('displays empty state message when no features', (WidgetTester tester) async {
      // Build the widget with empty features list
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: CarFeaturesList(features: []),
            ),
          ),
        ),
      );

      // Verify empty state message is displayed
      expect(find.text('No features available'), findsOneWidget);
    });

    testWidgets('has proper container styling', (WidgetTester tester) async {
      // Mock features
      final mockFeatures = [
        'GPS Navigation',
        'Bluetooth',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarFeaturesList(features: mockFeatures),
            ),
          ),
        ),
      );

      // Verify the container has a border and rounded corners
      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration as BoxDecoration;
      
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.border, isNotNull);
    });
  });
}
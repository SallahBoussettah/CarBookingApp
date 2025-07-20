import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/widgets/car_search_bar.dart';
import 'package:car_booking_app/providers/car_provider.dart';

void main() {
  group('CarSearchBar Widget Tests', () {
    late CarProvider carProvider;

    setUp(() {
      carProvider = CarProvider();
    });

    testWidgets('displays search hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Verify hint text is displayed
      expect(find.text('Search cars by name, brand, or type...'), findsOneWidget);
      
      // Verify search icon is displayed
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('updates search query when text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'BMW');
      await tester.pump();

      // Verify provider was updated
      expect(carProvider.searchQuery, equals('BMW'));
    });

    testWidgets('shows clear button when search query is not empty', (WidgetTester tester) async {
      // Set initial search query
      carProvider.setSearchQuery('BMW');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Verify clear button is displayed
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clears search query when clear button is tapped', (WidgetTester tester) async {
      // Set initial search query
      carProvider.setSearchQuery('BMW');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Verify search query was cleared
      expect(carProvider.searchQuery, equals(''));
      
      // Verify text field is cleared
      expect(find.text('BMW'), findsNothing);
    });

    testWidgets('does not show clear button when search query is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Verify clear button is not displayed
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('initializes with existing search query from provider', (WidgetTester tester) async {
      // Set search query before building widget
      carProvider.setSearchQuery('Tesla');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Wait for post frame callback
      await tester.pumpAndSettle();

      // Verify text field shows existing search query
      expect(find.text('Tesla'), findsOneWidget);
    });

    testWidgets('has correct styling and decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CarProvider>.value(
            value: carProvider,
            child: const Scaffold(
              body: CarSearchBar(),
            ),
          ),
        ),
      );

      // Find the TextField widget
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration!;

      // Verify decoration properties
      expect(decoration.hintText, equals('Search cars by name, brand, or type...'));
      expect(decoration.prefixIcon, isA<Icon>());
      expect(decoration.filled, isTrue);
      expect(decoration.border, isA<OutlineInputBorder>());
    });
  });
}
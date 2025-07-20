import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/screens/home_screen.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/widgets/car_search_bar.dart';
import 'package:car_booking_app/widgets/car_type_filter.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late CarProvider carProvider;

    setUp(() {
      carProvider = CarProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<CarProvider>.value(
          value: carProvider,
          child: const Material(
            child: Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );
    }

    testWidgets('displays search bar and type filter', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify search bar is displayed
      expect(find.byType(CarSearchBar), findsOneWidget);
      
      // Verify type filter is displayed
      expect(find.byType(CarTypeFilter), findsOneWidget);
    });

    testWidgets('has correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify main column structure
      expect(find.byType(Column), findsWidgets);
      
      // Verify expanded widget for content
      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
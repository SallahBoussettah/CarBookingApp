import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/screens/main_screen.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/booking_provider.dart';

void main() {
  group('MainScreen Tests', () {
    late NavigationProvider navigationProvider;

    setUp(() {
      navigationProvider = NavigationProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<NavigationProvider>.value(value: navigationProvider),
            ChangeNotifierProvider<CarProvider>(create: (_) => CarProvider()),
            ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
          ],
          child: const MainScreen(),
        ),
      );
    }

    testWidgets('Bottom navigation bar should have correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify that the bottom navigation bar has the correct icons
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      expect(find.byIcon(Icons.book_online), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
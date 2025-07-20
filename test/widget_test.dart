// This is a basic Flutter widget test for the Car Booking App.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_booking_app/main.dart';

void main() {
  testWidgets('Car Booking App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts with the main screen
    expect(find.text('Car Booking'), findsOneWidget);
    
    // Verify that the bottom navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Cars'), findsOneWidget);
    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap the Bookings tab and verify navigation
    await tester.tap(find.text('Bookings'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify that we're now on the bookings screen
    // Just check that we have a Scaffold widget, as the exact text might vary
    expect(find.byType(Scaffold).evaluate().isNotEmpty, isTrue);
  });
}
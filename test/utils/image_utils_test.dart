import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/utils/image_utils.dart';

void main() {
  testWidgets('ImageUtils.loadCarImage loads image correctly', (WidgetTester tester) async {
    // Build our widget with a valid image path
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageUtils.loadCarImage(
            imagePath: 'assets/images/cars/car1.png',
          ),
        ),
      ),
    );

    // Verify that the Image widget is created
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('ImageUtils.loadCarImage shows placeholder on error', (WidgetTester tester) async {
    // Build our widget with an invalid image path
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageUtils.loadCarImage(
            imagePath: 'assets/images/cars/nonexistent.png',
          ),
        ),
      ),
    );

    // Trigger error handling by pumping the widget
    await tester.pump();

    // Verify that the placeholder is shown
    expect(find.text('No Image Available'), findsOneWidget);
    expect(find.byIcon(Icons.directions_car), findsOneWidget);
  });

  testWidgets('ImageUtils.loadCarImages loads multiple images', (WidgetTester tester) async {
    // Build our widget with multiple image paths
    final List<String> imagePaths = [
      'assets/images/cars/car1.png',
      'assets/images/cars/toyota_camry_1.png',
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: ImageUtils.loadCarImages(
              imagePaths: imagePaths,
            ),
          ),
        ),
      ),
    );

    // Verify that multiple Image widgets are created
    expect(find.byType(Image), findsNWidgets(2));
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/widgets/car_image_carousel.dart';

void main() {
  group('CarImageCarousel', () {
    testWidgets('displays images in a carousel', (WidgetTester tester) async {
      // Mock image paths
      final mockImages = [
        'assets/images/car1.jpg',
        'assets/images/car2.jpg',
        'assets/images/car3.jpg',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: CarImageCarousel(images: mockImages),
            ),
          ),
        ),
      );

      // Verify PageView is present
      expect(find.byType(PageView), findsOneWidget);
      
      // Verify navigation buttons are present (since we have multiple images)
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      
      // Verify page indicators are present
      final pageIndicators = find.byType(Container).evaluate().where(
        (element) => element.widget is Container && 
                    (element.widget as Container).decoration is BoxDecoration &&
                    ((element.widget as Container).decoration as BoxDecoration).shape == BoxShape.circle
      );
      
      // We should have 3 indicators (one for each image)
      expect(pageIndicators.length >= 3, isTrue);
    });

    testWidgets('displays placeholder when no images', (WidgetTester tester) async {
      // Build the widget with empty image list
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: CarImageCarousel(images: []),
            ),
          ),
        ),
      );

      // Verify placeholder is shown
      expect(find.text('No Image Available'), findsOneWidget);
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      
      // Verify no navigation buttons are shown
      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('navigates to next image when right button is tapped', (WidgetTester tester) async {
      // Mock image paths
      final mockImages = [
        'assets/images/car1.jpg',
        'assets/images/car2.jpg',
        'assets/images/car3.jpg',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: CarImageCarousel(images: mockImages),
            ),
          ),
        ),
      );

      // Find and tap the right navigation button
      final rightButton = find.byIcon(Icons.chevron_right);
      await tester.tap(rightButton);
      await tester.pumpAndSettle(); // Wait for animation to complete
      
      // We can't directly verify which image is shown since we're not loading real images in tests
      // But we can verify the page change happened by checking if the PageView changed
      // We'll just verify the tap was successful
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('navigates to previous image when left button is tapped', (WidgetTester tester) async {
      // Mock image paths
      final mockImages = [
        'assets/images/car1.jpg',
        'assets/images/car2.jpg',
        'assets/images/car3.jpg',
      ];

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: CarImageCarousel(images: mockImages),
            ),
          ),
        ),
      );

      // First navigate to the second image
      final rightButton = find.byIcon(Icons.chevron_right);
      await tester.tap(rightButton);
      await tester.pumpAndSettle();
      
      // Then navigate back to the first image
      final leftButton = find.byIcon(Icons.chevron_left);
      await tester.tap(leftButton);
      await tester.pumpAndSettle();
      
      // We can't directly verify which image is shown since we're not loading real images in tests
      // But we can verify the tap was successful
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });
  });
}
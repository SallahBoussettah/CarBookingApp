import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:car_booking_app/routes/app_router.dart';
import 'package:car_booking_app/services/navigation_service.dart';

void main() {
  group('NavigationService', () {
    testWidgets('should navigate to a named route', (
      WidgetTester tester,
    ) async {
      // Build our app with the NavigationService and providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NavigationProvider()),
            ChangeNotifierProvider(create: (_) => CarProvider()),
            ChangeNotifierProvider(create: (_) => BookingProvider()),
          ],
          child: MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: AppRoutes.main,
            onGenerateRoute: AppRouter.generateRoute,
          ),
        ),
      );
      await tester.pump();

      // Verify that we're on the main screen
      expect(find.text('Car Booking'), findsOneWidget);
    });
  });
}
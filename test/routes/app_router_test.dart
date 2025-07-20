import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:car_booking_app/routes/app_router.dart';
import 'package:car_booking_app/screens/main_screen.dart';
import 'package:car_booking_app/screens/home_screen.dart';
import 'package:car_booking_app/screens/bookings_screen.dart';
import 'package:car_booking_app/screens/profile_screen.dart';
import 'package:car_booking_app/screens/car_detail_screen.dart';

void main() {
  group('AppRouter', () {
    Widget buildTestApp(Route<dynamic> route) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => CarProvider()),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
        ],
        child: MaterialApp(
          onGenerateRoute: (_) => route,
        ),
      );
    }
    
    testWidgets('should generate route for main screen', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.main),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route and providers
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the main screen
      expect(find.byType(MainScreen), findsOneWidget);
    });
    
    testWidgets('should generate route for home screen', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.home),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
    
    testWidgets('should generate route for bookings screen', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.bookingsList),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the bookings screen
      expect(find.byType(BookingsScreen), findsOneWidget);
    });
    
    testWidgets('should generate route for profile screen', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.profile),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
    
    testWidgets('should generate route for car details with car argument', (WidgetTester tester) async {
      final car = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const [],
        features: const ['Feature 1'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );
      
      final route = AppRouter.generateRoute(
        RouteSettings(name: AppRoutes.carDetails, arguments: car),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the car details screen
      expect(find.byType(CarDetailScreen), findsOneWidget);
      expect(find.text('Test Car'), findsOneWidget);
    });
    
    testWidgets('should generate error route for car details without car argument', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.carDetails),
      );
      
      expect(route, isA<MaterialPageRoute>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the error screen
      expect(find.text('Car data is required'), findsOneWidget);
    });
    
    testWidgets('should generate route for booking form with car argument', (WidgetTester tester) async {
      final car = Car(
        id: '1',
        name: 'Test Car',
        type: 'Sedan',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: const [],
        features: const ['Feature 1'],
        specs: const CarSpecs(
          engine: '2.0L',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      );
      
      final route = AppRouter.generateRoute(
        RouteSettings(name: AppRoutes.bookingForm, arguments: car),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the booking form screen
      expect(find.byType(Scaffold), findsOneWidget);
    });
    
    testWidgets('should generate route for booking details with booking argument', (WidgetTester tester) async {
      final booking = Booking(
        id: '1',
        carId: '1',
        pickupDate: DateTime.now(),
        returnDate: DateTime.now().add(const Duration(days: 2)),
        pickupTime: const TimeOfDay(hour: 10, minute: 0),
        returnTime: const TimeOfDay(hour: 10, minute: 0),
        totalCost: 100.0,
        status: BookingStatus.pending,
      );
      
      final route = AppRouter.generateRoute(
        RouteSettings(name: AppRoutes.bookingDetails, arguments: booking),
      );
      
      expect(route, isA<PageRouteBuilder>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the booking details screen
      expect(find.byType(Scaffold), findsOneWidget);
    });
    
    testWidgets('should generate error route for unknown route', (WidgetTester tester) async {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/unknown'),
      );
      
      expect(route, isA<MaterialPageRoute>());
      
      // Build the app with the route
      await tester.pumpWidget(buildTestApp(route));
      
      // Verify that we're on the error screen
      expect(find.text('Route not found'), findsOneWidget);
    });
  });
}
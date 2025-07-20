import 'package:flutter/material.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:car_booking_app/screens/main_screen.dart';
import 'package:car_booking_app/screens/home_screen.dart';
import 'package:car_booking_app/screens/bookings_screen.dart';
import 'package:car_booking_app/screens/profile_screen.dart';
import 'package:car_booking_app/screens/car_detail_screen.dart';
// Re-import the booking form screen to ensure it's properly loaded
import 'package:car_booking_app/screens/booking_form_screen.dart';
import 'package:car_booking_app/screens/booking_confirmation_screen.dart';
import 'package:car_booking_app/screens/booking_detail_screen.dart';

/// Class responsible for generating routes and handling navigation
class AppRouter {
  /// Private constructor to prevent instantiation
  AppRouter._();
  
  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.main:
        return _buildRoute(
          settings,
          const MainScreen(),
        );
        
      case AppRoutes.home:
        return _buildRoute(
          settings,
          const HomeScreen(),
        );
        
      case AppRoutes.bookingsList:
        return _buildRoute(
          settings,
          const BookingsScreen(),
        );
        
      case AppRoutes.profile:
        return _buildRoute(
          settings,
          const ProfileScreen(),
        );
        
      case AppRoutes.carDetails:
        final car = settings.arguments as Car?;
        if (car == null) {
          return _errorRoute('Car data is required');
        }
        return _buildRoute(
          settings,
          CarDetailScreen(car: car),
        );
        
      case AppRoutes.bookingForm:
        // Get the car argument
        final car = settings.arguments as Car?;
        
        // Check if car is null
        if (car == null) {
          return _errorRoute('Car data is required');
        }
        
        // Return the booking form screen with the car
        return _buildRoute(
          settings,
          BookingFormScreen(car: car),
        );
        
      case AppRoutes.bookingConfirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('car') || !args.containsKey('totalCost')) {
          return _errorRoute('Booking information is required');
        }
        return _buildRoute(
          settings,
          BookingConfirmationScreen(
            car: args['car'] as Car,
            totalCost: args['totalCost'] as double,
          ),
        );
        
      case AppRoutes.bookingDetails:
        final booking = settings.arguments as Booking?;
        if (booking == null) {
          return _errorRoute('Booking data is required');
        }
        return _buildRoute(
          settings,
          BookingDetailScreen(booking: booking),
        );
        
      default:
        return _errorRoute('Route not found');
    }
  }
  
  /// Build a route with a page transition animation
  static PageRouteBuilder<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder(
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  
  /// Build an error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
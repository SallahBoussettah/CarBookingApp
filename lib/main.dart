import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:car_booking_app/routes/app_router.dart';
import 'package:car_booking_app/services/navigation_service.dart';
// Force rebuild

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'Car Booking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
            secondary: Colors.orange,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: AppRoutes.main,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

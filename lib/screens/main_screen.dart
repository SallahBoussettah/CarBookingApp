import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/providers/navigation_provider.dart';
import 'package:car_booking_app/screens/home_screen.dart';
import 'package:car_booking_app/screens/bookings_screen.dart';
import 'package:car_booking_app/screens/profile_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  /// Constructor
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List of screens for each tab
  final List<Widget> _screens = const [
    HomeScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  // List of app bar titles for each tab
  final List<String> _titles = const [
    'Car Booking',
    'My Bookings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    // Get the current tab index from the navigation provider
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final currentIndex = navigationProvider.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => navigationProvider.setCurrentIndex(index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
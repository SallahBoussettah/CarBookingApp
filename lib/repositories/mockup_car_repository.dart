import 'dart:async';

import 'package:car_booking_app/data/mockup_car_data.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/repositories/car_repository.dart';

/// Implementation of CarRepository that uses mockup data
class MockupCarRepository implements CarRepository {
  // Singleton instance
  static final MockupCarRepository _instance = MockupCarRepository._internal();
  
  // Factory constructor to return the singleton instance
  factory MockupCarRepository() => _instance;
  
  // Private constructor
  MockupCarRepository._internal();
  
  // In-memory cache of cars
  final List<Car> _cars = MockupCarData.getAllCars();
  
  // Simulated network delay in milliseconds
  final int _simulatedDelay = 800;
  
  @override
  Future<List<Car>> getAllCars() async {
    // Simulate network delay, but skip in test environment
    if (!_isInTest()) {
      await Future.delayed(Duration(milliseconds: _simulatedDelay));
    }
    
    // Return a copy of the list to prevent modification
    return List.from(_cars);
  }
  
  // Helper method to detect if we're running in a test environment
  bool _isInTest() {
    return Zone.current[#test.declarer] != null;
  }
  
  @override
  Future<Car?> getCarById(String id) async {
    // Simulate network delay, but skip in test environment
    if (!_isInTest()) {
      await Future.delayed(Duration(milliseconds: _simulatedDelay));
    }
    
    // Find car by ID
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (e) {
      // Return null if car not found
      return null;
    }
  }
}
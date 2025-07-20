import 'package:car_booking_app/models/car.dart';

/// Interface for car data operations
abstract class CarRepository {
  /// Get all available cars
  /// 
  /// Returns a Future that completes with a list of all cars
  Future<List<Car>> getAllCars();
  
  /// Get a car by its ID
  /// 
  /// [id] The ID of the car to retrieve
  /// Returns a Future that completes with the car if found, or null if not found
  Future<Car?> getCarById(String id);
}
import 'package:car_booking_app/repositories/mockup_car_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockupCarRepository', () {
    late MockupCarRepository repository;
    
    setUp(() {
      repository = MockupCarRepository();
    });
    
    test('getAllCars should return all cars', () async {
      final cars = await repository.getAllCars();
      expect(cars.length, 15);
    });
    
    test('getAllCars should return valid cars', () async {
      final cars = await repository.getAllCars();
      for (final car in cars) {
        expect(car.isValid(), true);
      }
    });
    
    test('getCarById should return correct car', () async {
      // Get all cars first to have a valid ID
      final cars = await repository.getAllCars();
      final firstCar = cars.first;
      
      // Get car by ID
      final car = await repository.getCarById(firstCar.id);
      
      // Verify car is not null and has the correct ID
      expect(car, isNotNull);
      expect(car!.id, firstCar.id);
      expect(car, equals(firstCar));
    });
    
    test('getCarById should return null for invalid ID', () async {
      final car = await repository.getCarById('invalid-id');
      expect(car, isNull);
    });
    
    test('repository should be a singleton', () {
      final repository1 = MockupCarRepository();
      final repository2 = MockupCarRepository();
      
      expect(identical(repository1, repository2), true);
    });
    
    test('getAllCars should return a new list each time', () async {
      final cars1 = await repository.getAllCars();
      final cars2 = await repository.getAllCars();
      
      // Lists should not be identical (different instances)
      expect(identical(cars1, cars2), false);
      
      // But they should be equal (same content)
      expect(cars1.length, cars2.length);
      for (int i = 0; i < cars1.length; i++) {
        expect(cars1[i].id, cars2[i].id);
      }
    });
  });
}
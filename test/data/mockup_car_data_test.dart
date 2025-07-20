import 'package:car_booking_app/data/mockup_car_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockupCarData', () {
    test('getAllCars should return a list of 15 cars', () {
      final cars = MockupCarData.getAllCars();
      expect(cars.length, 15);
    });

    test('getAllCars should return cars with valid data', () {
      final cars = MockupCarData.getAllCars();
      for (final car in cars) {
        expect(car.isValid(), true, reason: 'Car ${car.id} is not valid: ${car.getValidationErrors()}');
      }
    });

    test('getAllCars should include different car types', () {
      final cars = MockupCarData.getAllCars();
      final types = cars.map((car) => car.type).toSet();
      
      expect(types.contains('Economy'), true);
      expect(types.contains('Compact'), true);
      expect(types.contains('Midsize'), true);
      expect(types.contains('SUV'), true);
      expect(types.contains('Luxury'), true);
      expect(types.length, greaterThanOrEqualTo(5), reason: 'Should have at least 5 different car types');
    });

    test('getAllCars should include different car brands', () {
      final cars = MockupCarData.getAllCars();
      final brands = cars.map((car) => car.brand).toSet();
      
      expect(brands.length, greaterThanOrEqualTo(5), reason: 'Should have at least 5 different car brands');
    });

    test('getAllCars should have cars with valid image paths', () {
      final cars = MockupCarData.getAllCars();
      for (final car in cars) {
        expect(car.images.isNotEmpty, true);
        for (final imagePath in car.images) {
          expect(imagePath.startsWith('assets/images/cars/'), true);
          expect(imagePath.endsWith('.png'), true);
        }
      }
    });

    test('getAllCars should have cars with valid features', () {
      final cars = MockupCarData.getAllCars();
      for (final car in cars) {
        expect(car.features.isNotEmpty, true);
      }
    });

    test('getAllCars should have cars with valid specifications', () {
      final cars = MockupCarData.getAllCars();
      for (final car in cars) {
        expect(car.specs.isValid(), true);
      }
    });
  });
}
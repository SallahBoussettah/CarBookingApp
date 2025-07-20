import 'package:car_booking_app/models/car_specs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarSpecs', () {
    test('should create a valid CarSpecs instance', () {
      final carSpecs = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      expect(carSpecs.engine, '2.0L Turbo');
      expect(carSpecs.transmission, 'Automatic');
      expect(carSpecs.seats, 5);
      expect(carSpecs.fuelType, 'Gasoline');
    });

    test('should convert to and from JSON correctly', () {
      final carSpecs = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      final json = carSpecs.toJson();
      final fromJson = CarSpecs.fromJson(json);

      expect(fromJson, equals(carSpecs));
    });

    group('validation', () {
      test('should be valid with correct values', () {
        final carSpecs = CarSpecs(
          engine: '2.0L Turbo',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        );

        expect(carSpecs.isValid(), true);
      });

      test('should be invalid with empty engine', () {
        final carSpecs = CarSpecs(
          engine: '',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        );

        expect(carSpecs.isValid(), false);
      });

      test('should be invalid with empty transmission', () {
        final carSpecs = CarSpecs(
          engine: '2.0L Turbo',
          transmission: '',
          seats: 5,
          fuelType: 'Gasoline',
        );

        expect(carSpecs.isValid(), false);
      });

      test('should be invalid with zero seats', () {
        final carSpecs = CarSpecs(
          engine: '2.0L Turbo',
          transmission: 'Automatic',
          seats: 0,
          fuelType: 'Gasoline',
        );

        expect(carSpecs.isValid(), false);
      });

      test('should be invalid with too many seats', () {
        final carSpecs = CarSpecs(
          engine: '2.0L Turbo',
          transmission: 'Automatic',
          seats: 13,
          fuelType: 'Gasoline',
        );

        expect(carSpecs.isValid(), false);
      });

      test('should be invalid with empty fuel type', () {
        final carSpecs = CarSpecs(
          engine: '2.0L Turbo',
          transmission: 'Automatic',
          seats: 5,
          fuelType: '',
        );

        expect(carSpecs.isValid(), false);
      });
    });

    test('equality works correctly', () {
      final carSpecs1 = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      final carSpecs2 = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      final carSpecs3 = CarSpecs(
        engine: '1.6L',
        transmission: 'Manual',
        seats: 4,
        fuelType: 'Diesel',
      );

      expect(carSpecs1 == carSpecs2, true);
      expect(carSpecs1 == carSpecs3, false);
      expect(carSpecs1.hashCode == carSpecs2.hashCode, true);
    });

    test('toString returns correct representation', () {
      final carSpecs = CarSpecs(
        engine: '2.0L Turbo',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      );

      expect(carSpecs.toString(), 'CarSpecs(engine: 2.0L Turbo, transmission: Automatic, seats: 5, fuelType: Gasoline)');
    });
  });
}
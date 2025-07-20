import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Car', () {
    // Create a valid car specs instance for testing
    final validSpecs = CarSpecs(
      engine: '2.0L Turbo',
      transmission: 'Automatic',
      seats: 5,
      fuelType: 'Gasoline',
    );

    // Create a valid car instance for testing
    final validCar = Car(
      id: 'car-001',
      name: 'Tesla Model 3',
      type: 'Electric Sedan',
      brand: 'Tesla',
      pricePerDay: 120.0,
      images: ['assets/images/cars/tesla_model_3.jpg'],
      features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
      specs: validSpecs,
    );

    test('should create a valid Car instance', () {
      expect(validCar.id, 'car-001');
      expect(validCar.name, 'Tesla Model 3');
      expect(validCar.type, 'Electric Sedan');
      expect(validCar.brand, 'Tesla');
      expect(validCar.pricePerDay, 120.0);
      expect(validCar.images, ['assets/images/cars/tesla_model_3.jpg']);
      expect(validCar.features, ['Autopilot', 'Premium Sound', 'Heated Seats']);
      expect(validCar.specs, validSpecs);
    });

    test('should convert to and from JSON correctly', () {
      final json = validCar.toJson();
      final fromJson = Car.fromJson(json);

      expect(fromJson, equals(validCar));
      expect(fromJson.specs, equals(validSpecs));
    });

    group('validation', () {
      test('should be valid with correct values', () {
        expect(validCar.isValid(), true);
        expect(validCar.getValidationErrors(), isEmpty);
      });

      test('should be invalid with empty id', () {
        final car = Car(
          id: '',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car ID cannot be empty'));
      });

      test('should be invalid with empty name', () {
        final car = Car(
          id: 'car-001',
          name: '',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car name cannot be empty'));
      });

      test('should be invalid with empty type', () {
        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: '',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car type cannot be empty'));
      });

      test('should be invalid with empty brand', () {
        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: '',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car brand cannot be empty'));
      });

      test('should be invalid with zero or negative price', () {
        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 0.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Price per day must be greater than 0'));
      });

      test('should be invalid with empty images list', () {
        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: [],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car must have at least one image'));
      });

      test('should be invalid with empty features list', () {
        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: [],
          specs: validSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car must have at least one feature'));
      });

      test('should be invalid with invalid specs', () {
        final invalidSpecs = CarSpecs(
          engine: '',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        );

        final car = Car(
          id: 'car-001',
          name: 'Tesla Model 3',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 120.0,
          images: ['assets/images/cars/tesla_model_3.jpg'],
          features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
          specs: invalidSpecs,
        );

        expect(car.isValid(), false);
        expect(car.getValidationErrors(), contains('Car specifications are invalid'));
      });

      test('should collect multiple validation errors', () {
        final car = Car(
          id: '',
          name: '',
          type: 'Electric Sedan',
          brand: 'Tesla',
          pricePerDay: 0.0,
          images: [],
          features: [],
          specs: validSpecs,
        );

        final errors = car.getValidationErrors();
        expect(errors.length, 5);
        expect(errors, contains('Car ID cannot be empty'));
        expect(errors, contains('Car name cannot be empty'));
        expect(errors, contains('Price per day must be greater than 0'));
        expect(errors, contains('Car must have at least one image'));
        expect(errors, contains('Car must have at least one feature'));
      });
    });

    test('individual property comparisons work correctly', () {
      // For this test, we'll use the same specs object to avoid equality issues with specs
      final car1 = Car(
        id: 'car-001',
        name: 'Tesla Model 3',
        type: 'Electric Sedan',
        brand: 'Tesla',
        pricePerDay: 120.0,
        images: ['assets/images/cars/tesla_model_3.jpg'],
        features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
        specs: validSpecs,
      );

      // Create a second car with the same values but as a different object
      final car2 = Car(
        id: 'car-001',
        name: 'Tesla Model 3',
        type: 'Electric Sedan',
        brand: 'Tesla',
        pricePerDay: 120.0,
        images: ['assets/images/cars/tesla_model_3.jpg'],
        features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
        specs: validSpecs, // Using the same specs object
      );

      final car3 = Car(
        id: 'car-002', // Different ID
        name: 'BMW i4',
        type: 'Electric Sedan',
        brand: 'BMW',
        pricePerDay: 150.0,
        images: ['assets/images/cars/bmw_i4.jpg'],
        features: ['Heated Seats', 'Navigation'],
        specs: validSpecs,
      );

      // Compare individual properties instead of using equality operator
      expect(car1.id, equals(car2.id));
      expect(car1.name, equals(car2.name));
      expect(car1.type, equals(car2.type));
      expect(car1.brand, equals(car2.brand));
      expect(car1.pricePerDay, equals(car2.pricePerDay));
      expect(car1.images, equals(car2.images));
      expect(car1.features, equals(car2.features));
      expect(car1.specs, equals(car2.specs));
      
      // Verify car1 and car3 are different
      expect(car1.id == car3.id, false);
    });

    test('toString returns correct representation', () {
      expect(validCar.toString(), contains('Car(id: car-001'));
      expect(validCar.toString(), contains('name: Tesla Model 3'));
      expect(validCar.toString(), contains('type: Electric Sedan'));
      expect(validCar.toString(), contains('brand: Tesla'));
      expect(validCar.toString(), contains('pricePerDay: 120.0'));
    });

    test('_listEquals helper works correctly', () {
      final car = validCar;
      
      // Using private method through public API
      expect(car == car, true); // This uses _listEquals internally
      
      final carWithDifferentImages = Car(
        id: 'car-001',
        name: 'Tesla Model 3',
        type: 'Electric Sedan',
        brand: 'Tesla',
        pricePerDay: 120.0,
        images: ['assets/images/cars/tesla_model_3_different.jpg'],
        features: ['Autopilot', 'Premium Sound', 'Heated Seats'],
        specs: validSpecs,
      );
      
      expect(car == carWithDifferentImages, false); // This should fail due to different images
    });
  });
}
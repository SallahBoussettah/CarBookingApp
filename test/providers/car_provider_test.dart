import 'package:flutter_test/flutter_test.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:car_booking_app/repositories/car_repository.dart';

// Mock implementation of CarRepository for testing
class MockCarRepository implements CarRepository {
  final List<Car> _cars = [
    Car(
      id: 'test-1',
      name: 'Test Car 1',
      type: 'Sedan',
      brand: 'TestBrand',
      pricePerDay: 50.0,
      images: ['test_image_1.png'],
      features: ['Feature 1', 'Feature 2'],
      specs: CarSpecs(
        engine: '2.0L',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      ),
    ),
    Car(
      id: 'test-2',
      name: 'Test Car 2',
      type: 'SUV',
      brand: 'TestBrand',
      pricePerDay: 70.0,
      images: ['test_image_2.png'],
      features: ['Feature 1', 'Feature 3'],
      specs: CarSpecs(
        engine: '3.0L',
        transmission: 'Automatic',
        seats: 7,
        fuelType: 'Gasoline',
      ),
    ),
    Car(
      id: 'test-3',
      name: 'Luxury Vehicle',
      type: 'Luxury',
      brand: 'PremiumBrand',
      pricePerDay: 120.0,
      images: ['test_image_3.png'],
      features: ['Feature 4', 'Feature 5'],
      specs: CarSpecs(
        engine: '4.0L',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Gasoline',
      ),
    ),
  ];

  @override
  Future<List<Car>> getAllCars() async {
    return List.from(_cars);
  }

  @override
  Future<Car?> getCarById(String id) async {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (e) {
      return null;
    }
  }
}

void main() {
  group('CarProvider Tests', () {
    late CarProvider carProvider;
    late MockCarRepository mockRepository;

    setUp(() {
      mockRepository = MockCarRepository();
      carProvider = CarProvider(carRepository: mockRepository);
    });

    test('Initial state is correct', () {
      expect(carProvider.cars, isEmpty);
      expect(carProvider.selectedCar, isNull);
      expect(carProvider.status, equals(CarLoadingStatus.initial));
      expect(carProvider.errorMessage, isNull);
      expect(carProvider.searchQuery, isEmpty);
      expect(carProvider.selectedType, isNull);
    });

    test('fetchCars updates state correctly', () async {
      // Initial state
      expect(carProvider.status, equals(CarLoadingStatus.initial));
      
      // Fetch cars
      await carProvider.fetchCars();
      
      // Verify state after fetch
      expect(carProvider.status, equals(CarLoadingStatus.loaded));
      expect(carProvider.cars.length, equals(3));
      expect(carProvider.errorMessage, isNull);
    });

    test('fetchCarById updates selectedCar correctly', () async {
      // Fetch a specific car
      await carProvider.fetchCarById('test-2');
      
      // Verify state after fetch
      expect(carProvider.status, equals(CarLoadingStatus.loaded));
      expect(carProvider.selectedCar, isNotNull);
      expect(carProvider.selectedCar?.id, equals('test-2'));
      expect(carProvider.selectedCar?.name, equals('Test Car 2'));
      expect(carProvider.errorMessage, isNull);
    });

    test('fetchCarById handles non-existent car', () async {
      // Fetch a non-existent car
      await carProvider.fetchCarById('non-existent');
      
      // Verify error state
      expect(carProvider.status, equals(CarLoadingStatus.error));
      expect(carProvider.selectedCar, isNull);
      expect(carProvider.errorMessage, equals('Car not found'));
    });

    test('selectCar updates selectedCar', () {
      // Setup
      final testCar = Car(
        id: 'test-id',
        name: 'Test Car',
        type: 'Test Type',
        brand: 'Test Brand',
        pricePerDay: 50.0,
        images: ['test.png'],
        features: ['Feature 1'],
        specs: CarSpecs(
          engine: 'Test Engine',
          transmission: 'Test Transmission',
          seats: 4,
          fuelType: 'Test Fuel',
        ),
      );
      
      // Select car
      carProvider.selectCar(testCar);
      
      // Verify state
      expect(carProvider.selectedCar, equals(testCar));
    });

    test('clearSelectedCar clears the selected car', () async {
      // Setup - first select a car
      await carProvider.fetchCarById('test-1');
      expect(carProvider.selectedCar, isNotNull);
      
      // Clear selected car
      carProvider.clearSelectedCar();
      
      // Verify state
      expect(carProvider.selectedCar, isNull);
    });

    test('setSearchQuery updates search query', () {
      // Set search query
      carProvider.setSearchQuery('luxury');
      
      // Verify state
      expect(carProvider.searchQuery, equals('luxury'));
    });

    test('setTypeFilter updates type filter', () {
      // Set type filter
      carProvider.setTypeFilter('SUV');
      
      // Verify state
      expect(carProvider.selectedType, equals('SUV'));
    });

    test('clearFilters resets filters', () {
      // Setup - set filters
      carProvider.setSearchQuery('test');
      carProvider.setTypeFilter('SUV');
      
      // Clear filters
      carProvider.clearFilters();
      
      // Verify state
      expect(carProvider.searchQuery, isEmpty);
      expect(carProvider.selectedType, isNull);
    });

    test('reset resets the entire provider state', () async {
      // Setup - load data and set filters
      await carProvider.fetchCars();
      carProvider.setSearchQuery('test');
      carProvider.setTypeFilter('SUV');
      
      // Reset provider
      carProvider.reset();
      
      // Verify state
      expect(carProvider.cars, isEmpty);
      expect(carProvider.selectedCar, isNull);
      expect(carProvider.status, equals(CarLoadingStatus.initial));
      expect(carProvider.errorMessage, isNull);
      expect(carProvider.searchQuery, isEmpty);
      expect(carProvider.selectedType, isNull);
    });

    group('Filtering Tests', () {
      setUp(() async {
        // Load cars before each test
        await carProvider.fetchCars();
      });

      test('filteredCars returns all cars when no filters applied', () {
        expect(carProvider.filteredCars.length, equals(3));
      });

      test('filteredCars filters by search query', () {
        // Filter by name
        carProvider.setSearchQuery('luxury');
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.name, equals('Luxury Vehicle'));
        
        // Filter by brand
        carProvider.setSearchQuery('premium');
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.brand, equals('PremiumBrand'));
        
        // Filter by type
        carProvider.setSearchQuery('suv');
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.type, equals('SUV'));
        
        // No matches
        carProvider.setSearchQuery('nonexistent');
        expect(carProvider.filteredCars, isEmpty);
      });

      test('filteredCars filters by type', () {
        // Filter by type
        carProvider.setTypeFilter('Sedan');
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.type, equals('Sedan'));
        
        carProvider.setTypeFilter('SUV');
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.type, equals('SUV'));
        
        // No matches
        carProvider.setTypeFilter('Convertible');
        expect(carProvider.filteredCars, isEmpty);
      });

      test('filteredCars combines search query and type filters', () {
        // Set both filters
        carProvider.setSearchQuery('test');
        carProvider.setTypeFilter('SUV');
        
        // Should match only Test Car 2
        expect(carProvider.filteredCars.length, equals(1));
        expect(carProvider.filteredCars.first.id, equals('test-2'));
        expect(carProvider.filteredCars.first.type, equals('SUV'));
      });

      test('availableTypes returns unique car types', () {
        // Get available types
        final types = carProvider.availableTypes;
        
        // Verify types
        expect(types.length, equals(3));
        expect(types, contains('Sedan'));
        expect(types, contains('SUV'));
        expect(types, contains('Luxury'));
        
        // Verify sorting
        expect(types, equals(['Luxury', 'SUV', 'Sedan']..sort()));
      });
    });
  });
}
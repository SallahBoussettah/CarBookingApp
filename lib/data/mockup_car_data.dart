import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/models/car_specs.dart';

/// Mockup car data for the application
/// Contains a list of 15 cars across different categories
class MockupCarData {
  /// Get a list of all cars
  static List<Car> getAllCars() {
    return [
      // Economy Cars
      Car(
        id: 'eco-001',
        name: 'Toyota Yaris',
        type: 'Economy',
        brand: 'Toyota',
        pricePerDay: 35.0,
        images: [
          'assets/images/cars/toyota_yaris_1.png',
          'assets/images/cars/toyota_yaris_2.png',
          'assets/images/cars/toyota_yaris_3.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'USB Port',
          'Fuel Efficient',
        ],
        specs: CarSpecs(
          engine: '1.5L 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'eco-002',
        name: 'Honda Fit',
        type: 'Economy',
        brand: 'Honda',
        pricePerDay: 38.0,
        images: [
          'assets/images/cars/honda_fit_1.png',
          'assets/images/cars/honda_fit_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Cruise Control',
          'Fuel Efficient',
        ],
        specs: CarSpecs(
          engine: '1.5L 4-Cylinder',
          transmission: 'CVT',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'eco-003',
        name: 'Nissan Versa',
        type: 'Economy',
        brand: 'Nissan',
        pricePerDay: 32.0,
        images: [
          'assets/images/cars/nissan_versa_1.png',
          'assets/images/cars/nissan_versa_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'USB Port',
          'Keyless Entry',
        ],
        specs: CarSpecs(
          engine: '1.6L 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),

      // Compact Cars
      Car(
        id: 'com-001',
        name: 'Honda Civic',
        type: 'Compact',
        brand: 'Honda',
        pricePerDay: 45.0,
        images: [
          'assets/images/cars/honda_civic_1.png',
          'assets/images/cars/honda_civic_2.png',
          'assets/images/cars/honda_civic_3.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Cruise Control',
        ],
        specs: CarSpecs(
          engine: '2.0L 4-Cylinder',
          transmission: 'CVT',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'com-002',
        name: 'Toyota Corolla',
        type: 'Compact',
        brand: 'Toyota',
        pricePerDay: 42.0,
        images: [
          'assets/images/cars/toyota_corolla_1.png',
          'assets/images/cars/toyota_corolla_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Lane Departure Warning',
          'Adaptive Cruise Control',
        ],
        specs: CarSpecs(
          engine: '1.8L 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),

      // Midsize Cars
      Car(
        id: 'mid-001',
        name: 'Toyota Camry',
        type: 'Midsize',
        brand: 'Toyota',
        pricePerDay: 55.0,
        images: [
          'assets/images/cars/toyota_camry_1.png',
          'assets/images/cars/toyota_camry_2.png',
          'assets/images/cars/toyota_camry_3.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Leather Seats',
          'Sunroof',
        ],
        specs: CarSpecs(
          engine: '2.5L 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'mid-002',
        name: 'Honda Accord',
        type: 'Midsize',
        brand: 'Honda',
        pricePerDay: 58.0,
        images: [
          'assets/images/cars/honda_accord_1.png',
          'assets/images/cars/honda_accord_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Heated Seats',
          'Lane Keeping Assist',
        ],
        specs: CarSpecs(
          engine: '1.5L Turbo 4-Cylinder',
          transmission: 'CVT',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),

      // SUVs
      Car(
        id: 'suv-001',
        name: 'Toyota RAV4',
        type: 'SUV',
        brand: 'Toyota',
        pricePerDay: 65.0,
        images: [
          'assets/images/cars/toyota_rav4_1.png',
          'assets/images/cars/toyota_rav4_2.png',
          'assets/images/cars/toyota_rav4_3.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'All-Wheel Drive',
          'Roof Rack',
        ],
        specs: CarSpecs(
          engine: '2.5L 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'suv-002',
        name: 'Honda CR-V',
        type: 'SUV',
        brand: 'Honda',
        pricePerDay: 68.0,
        images: [
          'assets/images/cars/honda_crv_1.png',
          'assets/images/cars/honda_crv_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'All-Wheel Drive',
          'Heated Seats',
        ],
        specs: CarSpecs(
          engine: '1.5L Turbo 4-Cylinder',
          transmission: 'CVT',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'suv-003',
        name: 'Ford Explorer',
        type: 'SUV',
        brand: 'Ford',
        pricePerDay: 85.0,
        images: [
          'assets/images/cars/ford_explorer_1.png',
          'assets/images/cars/ford_explorer_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Third Row Seating',
          'All-Wheel Drive',
        ],
        specs: CarSpecs(
          engine: '2.3L EcoBoost',
          transmission: 'Automatic',
          seats: 7,
          fuelType: 'Gasoline',
        ),
      ),

      // Luxury Cars
      Car(
        id: 'lux-001',
        name: 'BMW 3 Series',
        type: 'Luxury',
        brand: 'BMW',
        pricePerDay: 95.0,
        images: [
          'assets/images/cars/bmw_3series_1.png',
          'assets/images/cars/bmw_3series_2.png',
          'assets/images/cars/bmw_3series_3.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Leather Seats',
          'Sunroof',
          'Premium Sound System',
          'Navigation',
        ],
        specs: CarSpecs(
          engine: '2.0L Turbo 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),
      Car(
        id: 'lux-002',
        name: 'Mercedes-Benz C-Class',
        type: 'Luxury',
        brand: 'Mercedes-Benz',
        pricePerDay: 98.0,
        images: [
          'assets/images/cars/mercedes_cclass_1.png',
          'assets/images/cars/mercedes_cclass_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Leather Seats',
          'Sunroof',
          'Premium Sound System',
          'Navigation',
          'Heated Seats',
        ],
        specs: CarSpecs(
          engine: '2.0L Turbo 4-Cylinder',
          transmission: 'Automatic',
          seats: 5,
          fuelType: 'Gasoline',
        ),
      ),

      // Electric Cars
      Car(
        id: 'elec-001',
        name: 'Tesla Model 3',
        type: 'Electric',
        brand: 'Tesla',
        pricePerDay: 110.0,
        images: [
          'assets/images/cars/tesla_model3_1.png',
          'assets/images/cars/tesla_model3_2.png',
          'assets/images/cars/tesla_model3_3.png',
        ],
        features: [
          'Autopilot',
          'Air Conditioning',
          'Backup Camera',
          'Premium Sound System',
          'Navigation',
          'Heated Seats',
          'Glass Roof',
          'Supercharger Access',
        ],
        specs: CarSpecs(
          engine: 'Electric Motor',
          transmission: 'Single-Speed',
          seats: 5,
          fuelType: 'Electric',
        ),
      ),
      Car(
        id: 'elec-002',
        name: 'Nissan Leaf',
        type: 'Electric',
        brand: 'Nissan',
        pricePerDay: 75.0,
        images: [
          'assets/images/cars/nissan_leaf_1.png',
          'assets/images/cars/nissan_leaf_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'ProPILOT Assist',
          'Quick Charge Port',
        ],
        specs: CarSpecs(
          engine: 'Electric Motor',
          transmission: 'Single-Speed',
          seats: 5,
          fuelType: 'Electric',
        ),
      ),

      // Hybrid Cars
      Car(
        id: 'hyb-001',
        name: 'Toyota Prius',
        type: 'Hybrid',
        brand: 'Toyota',
        pricePerDay: 60.0,
        images: [
          'assets/images/cars/toyota_prius_1.png',
          'assets/images/cars/toyota_prius_2.png',
        ],
        features: [
          'Bluetooth',
          'Air Conditioning',
          'Backup Camera',
          'Apple CarPlay',
          'Android Auto',
          'Lane Departure Warning',
          'Adaptive Cruise Control',
          'Fuel Efficient',
        ],
        specs: CarSpecs(
          engine: '1.8L 4-Cylinder Hybrid',
          transmission: 'CVT',
          seats: 5,
          fuelType: 'Hybrid',
        ),
      ),
    ];
  }
}
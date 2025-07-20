import 'car_specs.dart';

class Car {
  final String id;
  final String name;
  final String type;
  final String brand;
  final double pricePerDay;
  final List<String> images;
  final List<String> features;
  final CarSpecs specs;

  const Car({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.pricePerDay,
    required this.images,
    required this.features,
    required this.specs,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'brand': brand,
      'pricePerDay': pricePerDay,
      'images': images,
      'features': features,
      'specs': specs.toJson(),
    };
  }

  // JSON deserialization
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      features: List<String>.from(json['features'] as List),
      specs: CarSpecs.fromJson(json['specs'] as Map<String, dynamic>),
    );
  }

  // Validation
  bool isValid() {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        type.isNotEmpty &&
        brand.isNotEmpty &&
        pricePerDay > 0 &&
        images.isNotEmpty &&
        features.isNotEmpty &&
        specs.isValid();
  }

  // Validation with detailed error messages
  List<String> getValidationErrors() {
    List<String> errors = [];
    
    if (id.isEmpty) errors.add('Car ID cannot be empty');
    if (name.isEmpty) errors.add('Car name cannot be empty');
    if (type.isEmpty) errors.add('Car type cannot be empty');
    if (brand.isEmpty) errors.add('Car brand cannot be empty');
    if (pricePerDay <= 0) errors.add('Price per day must be greater than 0');
    if (images.isEmpty) errors.add('Car must have at least one image');
    if (features.isEmpty) errors.add('Car must have at least one feature');
    if (!specs.isValid()) errors.add('Car specifications are invalid');
    
    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Car) return false;
    
    // Check if lists are equal using a more robust approach
    bool imagesEqual = images.length == other.images.length && 
        images.every((item) => other.images.contains(item));
    
    bool featuresEqual = features.length == other.features.length && 
        features.every((item) => other.features.contains(item));
    
    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.brand == brand &&
        other.pricePerDay == pricePerDay &&
        imagesEqual &&
        featuresEqual &&
        other.specs == specs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        brand.hashCode ^
        pricePerDay.hashCode ^
        images.hashCode ^
        features.hashCode ^
        specs.hashCode;
  }

  @override
  String toString() {
    return 'Car(id: $id, name: $name, type: $type, brand: $brand, pricePerDay: $pricePerDay, images: $images, features: $features, specs: $specs)';
  }

  // Helper method for list comparison
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
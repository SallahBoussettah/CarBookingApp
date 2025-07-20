class CarSpecs {
  final String engine;
  final String transmission;
  final int seats;
  final String fuelType;

  const CarSpecs({
    required this.engine,
    required this.transmission,
    required this.seats,
    required this.fuelType,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'engine': engine,
      'transmission': transmission,
      'seats': seats,
      'fuelType': fuelType,
    };
  }

  // JSON deserialization
  factory CarSpecs.fromJson(Map<String, dynamic> json) {
    return CarSpecs(
      engine: json['engine'] as String,
      transmission: json['transmission'] as String,
      seats: json['seats'] as int,
      fuelType: json['fuelType'] as String,
    );
  }

  // Validation
  bool isValid() {
    return engine.isNotEmpty &&
        transmission.isNotEmpty &&
        seats > 0 &&
        seats <= 12 && // Reasonable max seats
        fuelType.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CarSpecs &&
        other.engine == engine &&
        other.transmission == transmission &&
        other.seats == seats &&
        other.fuelType == fuelType;
  }

  @override
  int get hashCode {
    return engine.hashCode ^
        transmission.hashCode ^
        seats.hashCode ^
        fuelType.hashCode;
  }

  @override
  String toString() {
    return 'CarSpecs(engine: $engine, transmission: $transmission, seats: $seats, fuelType: $fuelType)';
  }
}
import 'package:flutter/foundation.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/repositories/car_repository.dart';
import 'package:car_booking_app/repositories/mockup_car_repository.dart';

/// Enum representing the loading state of car data
enum CarLoadingStatus {
  /// Initial state, no data has been loaded yet
  initial,
  
  /// Data is currently being loaded
  loading,
  
  /// Data has been successfully loaded
  loaded,
  
  /// An error occurred while loading data
  error
}

/// Provider for managing car data and state
class CarProvider with ChangeNotifier {
  /// The car repository used to fetch car data
  final CarRepository _carRepository;
  
  /// List of all cars
  List<Car> _cars = [];
  
  /// Currently selected car
  Car? _selectedCar;
  
  /// Current loading status
  CarLoadingStatus _status = CarLoadingStatus.initial;
  
  /// Error message if loading fails
  String? _errorMessage;
  
  /// Search query for filtering cars
  String _searchQuery = '';
  
  /// Selected car type filter
  String? _selectedType;
  
  /// Constructor with optional repository parameter
  CarProvider({CarRepository? carRepository}) 
      : _carRepository = carRepository ?? MockupCarRepository();
  
  /// Get all cars
  List<Car> get cars => _cars;
  
  /// Get filtered cars based on search query and type filter
  List<Car> get filteredCars {
    return _cars.where((car) {
      // Apply search query filter
      final matchesSearch = _searchQuery.isEmpty || 
          car.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          car.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          car.type.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply type filter
      final matchesType = _selectedType == null || car.type == _selectedType;
      
      return matchesSearch && matchesType;
    }).toList();
  }
  
  /// Get the currently selected car
  Car? get selectedCar => _selectedCar;
  
  /// Get the current loading status
  CarLoadingStatus get status => _status;
  
  /// Get the current error message
  String? get errorMessage => _errorMessage;
  
  /// Get the current search query
  String get searchQuery => _searchQuery;
  
  /// Get the current selected type filter
  String? get selectedType => _selectedType;
  
  /// Get a list of all available car types
  List<String> get availableTypes {
    final types = _cars.map((car) => car.type).toSet().toList();
    types.sort(); // Sort alphabetically
    return types;
  }
  
  /// Fetch all cars from the repository
  Future<void> fetchCars() async {
    try {
      _status = CarLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      final cars = await _carRepository.getAllCars();
      _cars = cars;
      _status = CarLoadingStatus.loaded;
    } catch (e) {
      _status = CarLoadingStatus.error;
      _errorMessage = 'Failed to load cars: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }
  
  /// Fetch a specific car by ID
  Future<void> fetchCarById(String id) async {
    try {
      _status = CarLoadingStatus.loading;
      _errorMessage = null;
      notifyListeners();
      
      final car = await _carRepository.getCarById(id);
      if (car != null) {
        _selectedCar = car;
        _status = CarLoadingStatus.loaded;
      } else {
        _status = CarLoadingStatus.error;
        _errorMessage = 'Car not found';
      }
    } catch (e) {
      _status = CarLoadingStatus.error;
      _errorMessage = 'Failed to load car details: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }
  
  /// Set the selected car
  void selectCar(Car car) {
    _selectedCar = car;
    notifyListeners();
  }
  
  /// Clear the selected car
  void clearSelectedCar() {
    _selectedCar = null;
    notifyListeners();
  }
  
  /// Set the search query for filtering cars
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  /// Set the car type filter
  void setTypeFilter(String? type) {
    _selectedType = type;
    notifyListeners();
  }
  
  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedType = null;
    notifyListeners();
  }
  
  /// Reset the provider state
  void reset() {
    _cars = [];
    _selectedCar = null;
    _status = CarLoadingStatus.initial;
    _errorMessage = null;
    _searchQuery = '';
    _selectedType = null;
    notifyListeners();
  }
}
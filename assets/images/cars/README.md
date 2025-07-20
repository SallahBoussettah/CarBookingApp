# Car Images

This directory contains all the car images used in the Car Booking App.

## Image Naming Convention

Images follow the naming convention: `{brand}_{model}_{index}.png`

For example:
- `toyota_camry_1.png` - First image of Toyota Camry
- `toyota_camry_2.png` - Second image of Toyota Camry
- `honda_civic_1.png` - First image of Honda Civic

## Available Car Images

The following car images are available:

### Economy Cars
- Honda Civic
- Toyota Corolla
- Toyota Yaris
- Nissan Versa
- Honda Fit

### Mid-size Cars
- Toyota Camry
- Honda Accord

### SUVs
- Toyota RAV4
- Honda CR-V
- Ford Explorer

### Luxury Cars
- BMW 3 Series
- Mercedes C-Class

### Electric Cars
- Tesla Model 3
- Nissan Leaf

## Usage

To use these images in your code, use the `ImageUtils` class:

```dart
import 'package:car_booking_app/utils/image_utils.dart';

// Single image
ImageUtils.loadCarImage(
  imagePath: 'assets/images/cars/toyota_camry_1.png',
  width: 300,
  height: 200,
);

// Multiple images
List<String> imagePaths = [
  'assets/images/cars/toyota_camry_1.png',
  'assets/images/cars/toyota_camry_2.png',
];

ImageUtils.loadCarImages(
  imagePaths: imagePaths,
);
```

The `ImageUtils` class handles error states automatically and will display a placeholder if an image fails to load.
import 'package:flutter/material.dart';

/// A widget that displays a placeholder for car images
/// This can be used during development before actual car images are available
class CarImagePlaceholder extends StatelessWidget {
  final String carName;
  final String carBrand;
  
  const CarImagePlaceholder({
    Key? key,
    required this.carName,
    required this.carBrand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 48, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              carBrand,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              carName,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
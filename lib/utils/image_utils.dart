import 'package:flutter/material.dart';

/// Utility class for handling image loading and error states
class ImageUtils {
  /// Load an asset image with error handling
  static Widget loadCarImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder(width: width, height: height);
      },
    );
  }

  /// Load multiple car images with error handling
  static List<Widget> loadCarImages({
    required List<String> imagePaths,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return imagePaths.map((path) => loadCarImage(
      imagePath: path,
      width: width,
      height: height,
      fit: fit,
    )).toList();
  }

  /// Build placeholder for when image fails to load
  static Widget _buildPlaceholder({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Image Available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
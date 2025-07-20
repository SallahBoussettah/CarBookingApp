import 'package:flutter/material.dart';

/// Widget that displays a list of car features
class CarFeaturesList extends StatelessWidget {
  /// List of features to display
  final List<String> features;

  /// Constructor
  const CarFeaturesList({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Text(
            'No features available',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Features grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _buildFeatureItem(features[index]);
            },
          ),
        ],
      ),
    );
  }

  /// Build individual feature item
  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Icon(
          _getFeatureIcon(feature),
          size: 16,
          color: Colors.green[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            feature,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Get appropriate icon for feature
  IconData _getFeatureIcon(String feature) {
    final featureLower = feature.toLowerCase();
    
    if (featureLower.contains('gps') || featureLower.contains('navigation')) {
      return Icons.navigation;
    } else if (featureLower.contains('ac') || featureLower.contains('air')) {
      return Icons.ac_unit;
    } else if (featureLower.contains('bluetooth')) {
      return Icons.bluetooth;
    } else if (featureLower.contains('usb')) {
      return Icons.usb;
    } else if (featureLower.contains('camera') || featureLower.contains('backup')) {
      return Icons.camera_alt;
    } else if (featureLower.contains('seat') || featureLower.contains('leather')) {
      return Icons.airline_seat_recline_normal;
    } else if (featureLower.contains('audio') || featureLower.contains('sound')) {
      return Icons.volume_up;
    } else if (featureLower.contains('cruise')) {
      return Icons.speed;
    } else if (featureLower.contains('keyless')) {
      return Icons.key;
    } else if (featureLower.contains('sunroof')) {
      return Icons.wb_sunny;
    } else if (featureLower.contains('parking')) {
      return Icons.local_parking;
    } else if (featureLower.contains('heated')) {
      return Icons.whatshot;
    } else {
      return Icons.check_circle;
    }
  }
}
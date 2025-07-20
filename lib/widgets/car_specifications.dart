import 'package:flutter/material.dart';
import 'package:car_booking_app/models/car_specs.dart';

/// Widget that displays car specifications in a grid layout
class CarSpecifications extends StatelessWidget {
  /// The car specifications to display
  final CarSpecs specs;

  /// Constructor
  const CarSpecifications({
    super.key,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSpecItem(
                  icon: Icons.settings,
                  label: 'Engine',
                  value: specs.engine,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSpecItem(
                  icon: Icons.sync,
                  label: 'Transmission',
                  value: specs.transmission,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSpecItem(
                  icon: Icons.airline_seat_recline_normal,
                  label: 'Seats',
                  value: '${specs.seats}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSpecItem(
                  icon: Icons.local_gas_station,
                  label: 'Fuel Type',
                  value: specs.fuelType,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual specification item
  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
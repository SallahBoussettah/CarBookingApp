import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';

/// Widget that provides type filtering functionality for cars
class CarTypeFilter extends StatelessWidget {
  /// Constructor
  const CarTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) {
        final availableTypes = carProvider.availableTypes;
        
        if (availableTypes.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // "All" filter chip
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: carProvider.selectedType == null,
                    onSelected: (selected) {
                      if (selected) {
                        carProvider.setTypeFilter(null);
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: carProvider.selectedType == null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                ),
                
                // Type filter chips
                ...availableTypes.map((type) {
                  final isSelected = carProvider.selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        carProvider.setTypeFilter(selected ? type : null);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
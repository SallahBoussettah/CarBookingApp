import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';

/// Widget that provides search functionality for cars
class CarSearchBar extends StatefulWidget {
  /// Constructor
  const CarSearchBar({super.key});

  @override
  State<CarSearchBar> createState() => _CarSearchBarState();
}

class _CarSearchBarState extends State<CarSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    
    // Set initial value from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      _controller.text = carProvider.searchQuery;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) {
        return Material(
          color: Colors.transparent,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search cars by name, brand, or type...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: carProvider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        carProvider.setSearchQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              carProvider.setSearchQuery(value);
            },
            textInputAction: TextInputAction.search,
          ),
        );
      },
    );
  }
}
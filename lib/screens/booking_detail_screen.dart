import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/booking_status.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/providers/car_provider.dart';
import 'package:intl/intl.dart';

/// Screen for displaying detailed booking information
class BookingDetailScreen extends StatefulWidget {
  /// The booking to display
  final Booking booking;

  /// Constructor
  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  // Date formatter
  final _dateFormat = DateFormat('MMM dd, yyyy');

  // Time formatter
  final _timeFormat = DateFormat('h:mm a');

  // Loading state for cancel button
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();

    // Fetch car details when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCarDetails();
    });
  }

  /// Fetch car details for this booking
  Future<void> _fetchCarDetails() async {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    await carProvider.fetchCarById(widget.booking.carId);
  }

  /// Cancel the booking
  Future<void> _cancelBooking() async {
    setState(() {
      _isCancelling = true;
    });

    try {
      final bookingProvider = Provider.of<BookingProvider>(
        context,
        listen: false,
      );
      final success = await bookingProvider.cancelBooking(widget.booking.id);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to bookings list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bookingProvider.errorMessage ?? 'Failed to cancel booking',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  /// Show cancel confirmation dialog
  Future<void> _showCancelConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel Booking'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _cancelBooking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking ID and status
              _buildBookingHeader(),

              const SizedBox(height: 24),

              // Car details
              _buildCarDetails(),

              const SizedBox(height: 24),

              // Booking details
              _buildBookingDetails(),

              const SizedBox(height: 24),

              // Cost summary
              _buildCostSummary(),

              const SizedBox(height: 32),

              // Cancel button (only for active bookings)
              if (widget.booking.status.isActive) _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build booking header with ID and status
  Widget _buildBookingHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking ID',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  widget.booking.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(height: 24),

            // Booking status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                _buildStatusChip(widget.booking.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build car details section
  Widget _buildCarDetails() {
    return Consumer<CarProvider>(
      builder: (context, carProvider, child) {
        // Check if car is loaded
        final car = carProvider.selectedCar;
        final isLoading = carProvider.status == CarLoadingStatus.loading;
        final hasError = carProvider.status == CarLoadingStatus.error;

        if (isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (hasError || car == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load car details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    carProvider.errorMessage ?? 'Unknown error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchCarDetails,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildCarDetailsCard(car);
      },
    );
  }

  /// Build car details card
  Widget _buildCarDetailsCard(Car car) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              car.images.first,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.directions_car,
                    size: 64,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          // Car details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${car.brand} · ${car.type}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Car specifications
                const Text(
                  'Specifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSpecRow('Engine', car.specs.engine),
                _buildSpecRow('Transmission', car.specs.transmission),
                _buildSpecRow('Seats', car.specs.seats.toString()),
                _buildSpecRow('Fuel Type', car.specs.fuelType),

                const SizedBox(height: 16),

                // Car features
                const Text(
                  'Features',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: car.features.map((feature) {
                    return Chip(
                      label: Text(feature),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build specification row
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  /// Build booking details section
  Widget _buildBookingDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Pickup details
            _buildDateTimeRow(
              title: 'Pickup',
              date: widget.booking.pickupDate,
              time: widget.booking.pickupTime,
              icon: Icons.departure_board,
            ),

            const SizedBox(height: 16),

            // Return details
            _buildDateTimeRow(
              title: 'Return',
              date: widget.booking.returnDate,
              time: widget.booking.returnTime,
              icon: Icons.event_available,
            ),

            const SizedBox(height: 16),

            // Duration
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.timelapse,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.booking.durationInDays.toStringAsFixed(1)} days',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build date and time row
  Widget _buildDateTimeRow({
    required String title,
    required DateTime date,
    required TimeOfDay time,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _dateFormat.format(date),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimeOfDay(time),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build cost summary section
  Widget _buildCostSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cost Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Total cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Cost',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${widget.booking.totalCost.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Payment status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Status',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'Paid',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build cancel button
  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isCancelling ? null : _showCancelConfirmation,
        icon: _isCancelling
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.cancel),
        label: Text(_isCancelling ? 'Cancelling...' : 'Cancel Booking'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip(BookingStatus status) {
    // Define color based on status
    Color chipColor;
    if (status == BookingStatus.pending) {
      chipColor = Colors.orange;
    } else if (status == BookingStatus.confirmed) {
      chipColor = Colors.blue;
    } else if (status == BookingStatus.active) {
      chipColor = Colors.green;
    } else if (status == BookingStatus.completed) {
      chipColor = Colors.purple;
    } else if (status == BookingStatus.cancelled) {
      chipColor = Colors.red;
    } else {
      chipColor = Colors.grey; // Default color
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return _timeFormat.format(dateTime);
  }
}

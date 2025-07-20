import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/models/car.dart';
import 'package:car_booking_app/providers/booking_provider.dart';
import 'package:car_booking_app/routes/app_routes.dart';
import 'package:intl/intl.dart';

/// Screen for creating a new car booking with date and time selection
class BookingFormScreen extends StatefulWidget {
  /// The car being booked
  final Car car;

  /// Constructor
  const BookingFormScreen({
    super.key,
    required this.car,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Date formatter
  final _dateFormat = DateFormat('MMM dd, yyyy');
  
  // Time formatter
  final _timeFormat = DateFormat('h:mm a');
  
  // Current date for validation
  final _currentDate = DateTime.now();
  
  // Form data
  DateTime? _pickupDate;
  DateTime? _returnDate;
  TimeOfDay? _pickupTime;
  TimeOfDay? _returnTime;
  
  // Validation errors
  List<String> _validationErrors = [];
  
  // Calculated cost
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Initialize with default values
    _pickupDate = _currentDate;
    _returnDate = _currentDate.add(const Duration(days: 1));
    _pickupTime = TimeOfDay(hour: 10, minute: 0);
    _returnTime = TimeOfDay(hour: 10, minute: 0);
    
    // Update form data in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
      _calculateCost();
    });
  }

  /// Update form data in the booking provider
  void _updateFormData() {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    bookingProvider.updateBookingFormData({
      'carId': widget.car.id,
      'pickupDate': _pickupDate,
      'returnDate': _returnDate,
      'pickupTime': _pickupTime,
      'returnTime': _returnTime,
    });
    
    // Validate and update errors
    setState(() {
      _validationErrors = bookingProvider.validateBookingFormData();
    });
  }

  /// Calculate the total cost of the booking
  void _calculateCost() {
    if (_pickupDate != null && _returnDate != null && 
        _pickupTime != null && _returnTime != null) {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      
      setState(() {
        _totalCost = bookingProvider.calculateBookingCost(widget.car.pricePerDay);
      });
    }
  }

  /// Show date picker and update selected date
  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isPickup ? _pickupDate ?? _currentDate : _returnDate ?? _currentDate.add(const Duration(days: 1)),
      firstDate: isPickup ? _currentDate : (_pickupDate ?? _currentDate),
      lastDate: _currentDate.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = pickedDate;
          
          // If return date is before pickup date, update it
          if (_returnDate != null && _returnDate!.isBefore(_pickupDate!)) {
            _returnDate = _pickupDate;
          }
        } else {
          _returnDate = pickedDate;
        }
      });
      
      _updateFormData();
      _calculateCost();
    }
  }

  /// Show time picker and update selected time
  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isPickup ? _pickupTime ?? TimeOfDay.now() : _returnTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = pickedTime;
        } else {
          _returnTime = pickedTime;
        }
      });
      
      _updateFormData();
      _calculateCost();
    }
  }

  /// Submit the booking form
  void _submitForm() {
    if (_formKey.currentState!.validate() && _validationErrors.isEmpty) {
      // Navigate to booking confirmation screen
      Navigator.pushNamed(
        context,
        AppRoutes.bookingConfirmation,
        arguments: {
          'car': widget.car,
          'totalCost': _totalCost,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Car'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car information card
                _buildCarInfoCard(),
                
                const SizedBox(height: 24),
                
                // Date and time selection
                _buildDateTimeSection(),
                
                const SizedBox(height: 24),
                
                // Validation errors
                if (_validationErrors.isNotEmpty)
                  _buildValidationErrors(),
                
                const SizedBox(height: 24),
                
                // Cost summary
                _buildCostSummary(),
                
                const SizedBox(height: 32),
                
                // Continue button
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the car information card
  Widget _buildCarInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Car image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.car.images.isNotEmpty ? widget.car.images.first : 'assets/images/car_placeholder.jpg',
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Car details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.car.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.car.brand} · ${widget.car.type}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.car.pricePerDay.toStringAsFixed(0)}/day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the date and time selection section
  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Pickup date and time
        _buildDateTimeRow(
          title: 'Pickup Date & Time',
          date: _pickupDate,
          time: _pickupTime,
          onDateTap: () => _selectDate(context, true),
          onTimeTap: () => _selectTime(context, true),
        ),
        
        const SizedBox(height: 16),
        
        // Return date and time
        _buildDateTimeRow(
          title: 'Return Date & Time',
          date: _returnDate,
          time: _returnTime,
          onDateTap: () => _selectDate(context, false),
          onTimeTap: () => _selectTime(context, false),
        ),
      ],
    );
  }

  /// Build a date and time selection row
  Widget _buildDateTimeRow({
    required String title,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            // Date selection
            Expanded(
              child: InkWell(
                onTap: onDateTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date != null
                            ? _dateFormat.format(date)
                            : 'Select Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: date != null ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Time selection
            Expanded(
              child: InkWell(
                onTap: onTimeTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time != null
                            ? _formatTimeOfDay(time)
                            : 'Select Time',
                        style: TextStyle(
                          fontSize: 14,
                          color: time != null ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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

  /// Build validation errors display
  Widget _buildValidationErrors() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Please fix the following errors:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(
            _validationErrors.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: Colors.red),
                  ),
                  Expanded(
                    child: Text(
                      _validationErrors[index],
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build cost summary section
  Widget _buildCostSummary() {
    // Calculate duration in days
    int days = 1;
    if (_pickupDate != null && _returnDate != null) {
      days = _returnDate!.difference(_pickupDate!).inDays;
      if (days == 0) days = 1; // Minimum 1 day
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(76),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cost Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Daily rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Rate:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '\$${widget.car.pricePerDay.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duration:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$days day${days > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const Divider(height: 24),
          
          // Total cost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${_totalCost.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build continue button
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _validationErrors.isEmpty ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: const Text(
          'Continue to Confirmation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
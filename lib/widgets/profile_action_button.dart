import 'package:flutter/material.dart';

/// Widget for displaying an action button in the profile screen
class ProfileActionButton extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Text to display
  final String text;

  /// Color of the icon
  final Color iconColor;

  /// Background color of the icon container
  final Color iconBackgroundColor;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Constructor
  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
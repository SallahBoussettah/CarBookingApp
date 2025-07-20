import 'package:flutter/material.dart';

/// Widget for displaying a card with profile information
class ProfileInfoCard extends StatelessWidget {
  /// Title of the card
  final String title;

  /// List of information items to display
  final List<ProfileInfoItem> items;

  /// Action button text
  final String? actionButtonText;

  /// Callback when the action button is pressed
  final VoidCallback? onActionPressed;

  /// Constructor
  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.items,
    this.actionButtonText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header with title and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (actionButtonText != null && onActionPressed != null)
                  TextButton(
                    onPressed: onActionPressed,
                    child: Text(actionButtonText!),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Information items
            ...items.map((item) => _buildInfoItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  /// Build an individual information item
  Widget _buildInfoItem(ProfileInfoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            item.label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),

          // Value
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Add divider except for the last item
          if (items.last != item)
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Divider(height: 1),
            ),
        ],
      ),
    );
  }
}

/// Class representing an information item in the profile card
class ProfileInfoItem {
  /// Label for the information item
  final String label;

  /// Value of the information item
  final String value;

  /// Constructor
  const ProfileInfoItem({
    required this.label,
    required this.value,
  });
}
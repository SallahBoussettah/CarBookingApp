import 'package:flutter/material.dart';
import 'dart:io';

/// Widget for displaying a profile picture with optional edit functionality
class ProfilePicture extends StatelessWidget {
  /// URL or path to the profile picture
  final String? imagePath;

  /// Size of the profile picture
  final double size;

  /// Whether to show the edit button
  final bool showEditButton;

  /// Callback when the edit button is pressed
  final VoidCallback? onEditPressed;

  /// Constructor
  const ProfilePicture({
    super.key,
    this.imagePath,
    this.size = 100,
    this.showEditButton = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Profile picture
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: _buildProfileImage(),
          ),
        ),

        // Edit button
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                width: size / 3,
                height: size / 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build the profile image based on the image path
  Widget _buildProfileImage() {
    // If no image path is provided, show a placeholder
    if (imagePath == null || imagePath!.isEmpty) {
      return const Icon(
        Icons.person,
        color: Colors.grey,
        size: 50,
      );
    }

    // If the image path is a network URL
    if (imagePath!.startsWith('http')) {
      return Image.network(
        imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.person,
            color: Colors.grey,
            size: 50,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    // If the image path is a file path
    if (imagePath!.startsWith('/')) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.person,
            color: Colors.grey,
            size: 50,
          );
        },
      );
    }

    // Otherwise, assume it's an asset path
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.person,
          color: Colors.grey,
          size: 50,
        );
      },
    );
  }
}
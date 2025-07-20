import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:car_booking_app/models/user.dart';
import 'package:car_booking_app/providers/user_provider.dart';
import 'package:car_booking_app/screens/edit_profile_screen.dart';
import 'package:car_booking_app/widgets/profile_picture.dart';
import 'package:car_booking_app/widgets/profile_info_card.dart';
import 'package:car_booking_app/widgets/profile_action_button.dart';

/// Profile screen showing user information
class ProfileScreen extends StatelessWidget {
  /// Constructor
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show loading indicator if user data is loading
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show error message if there's an error
        if (userProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${userProvider.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Reload user data
                    userProvider.updateProfile();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show user profile if user data is available
        final user = userProvider.currentUser;
        if (user != null) {
          return _buildUserProfile(context, user);
        }

        // Show sign in button if user is not logged in
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'You are not signed in',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to sign in screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build the user profile UI
  Widget _buildUserProfile(BuildContext context, User user) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header with profile picture and name
            _buildUserHeader(context, user),

            const SizedBox(height: 24),

            // Personal information card
            ProfileInfoCard(
              title: 'Personal Information',
              items: [
                ProfileInfoItem(
                  label: 'Email',
                  value: user.email,
                ),
                ProfileInfoItem(
                  label: 'Phone',
                  value: user.phoneNumber,
                ),
                ProfileInfoItem(
                  label: 'Address',
                  value: user.address,
                ),
              ],
              actionButtonText: 'Edit',
              onActionPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Driver's license information card
            ProfileInfoCard(
              title: 'Driver\'s License',
              items: [
                ProfileInfoItem(
                  label: 'License Number',
                  value: user.driverLicenseNumber,
                ),
                ProfileInfoItem(
                  label: 'Issue Date',
                  value: dateFormat.format(user.driverLicenseIssueDate),
                ),
                ProfileInfoItem(
                  label: 'Expiry Date',
                  value: dateFormat.format(user.driverLicenseExpiryDate),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Payment information card
            ProfileInfoCard(
              title: 'Payment Information',
              items: [
                ProfileInfoItem(
                  label: 'Preferred Payment Method',
                  value: user.preferredPaymentMethod,
                ),
              ],
              actionButtonText: 'Manage',
              onActionPressed: () {
                // TODO: Navigate to payment management screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment management not implemented yet'),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Action buttons
            _buildActionButtons(context),

            const SizedBox(height: 16),

            // Sign out button
            _buildSignOutButton(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build user header with profile picture and name
  Widget _buildUserHeader(BuildContext context, User user) {
    return Center(
      child: Column(
        children: [
          // Profile picture
          ProfilePicture(
            imagePath: user.profilePicture,
            size: 120,
            showEditButton: true,
            onEditPressed: () {
              // TODO: Implement profile picture update
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile picture update not implemented yet'),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // User name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Member since
          Text(
            'Member since ${DateFormat('MMMM yyyy').format(user.joinedDate)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 8),

          // Verification badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email verification badge
              _buildVerificationBadge(
                context,
                isVerified: user.isEmailVerified,
                text: 'Email Verified',
                icon: Icons.email,
              ),

              const SizedBox(width: 8),

              // Phone verification badge
              _buildVerificationBadge(
                context,
                isVerified: user.isPhoneVerified,
                text: 'Phone Verified',
                icon: Icons.phone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build verification badge
  Widget _buildVerificationBadge(
    BuildContext context, {
    required bool isVerified,
    required String text,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withAlpha(26)
            : Colors.grey.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerified
              ? Colors.green.withAlpha(128)
              : Colors.grey.withAlpha(128),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.check_circle : icon,
            size: 14,
            color: isVerified ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isVerified ? text : 'Verify $text',
            style: TextStyle(
              fontSize: 12,
              color: isVerified ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Help & Support button
        ProfileActionButton(
          icon: Icons.help_outline,
          text: 'Help & Support',
          iconColor: Colors.blue,
          iconBackgroundColor: Colors.blue.withAlpha(26),
          onPressed: () {
            // TODO: Navigate to help & support screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Help & Support not implemented yet'),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Privacy & Security button
        ProfileActionButton(
          icon: Icons.security,
          text: 'Privacy & Security',
          iconColor: Colors.green,
          iconBackgroundColor: Colors.green.withAlpha(26),
          onPressed: () {
            // TODO: Navigate to privacy & security screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Privacy & Security not implemented yet'),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // About button
        ProfileActionButton(
          icon: Icons.info_outline,
          text: 'About',
          iconColor: Colors.purple,
          iconBackgroundColor: Colors.purple.withAlpha(26),
          onPressed: () {
            // TODO: Navigate to about screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('About screen not implemented yet'),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build sign out button
  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sign Out'),
              content: const Text(
                'Are you sure you want to sign out?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Sign out
                    Provider.of<UserProvider>(context, listen: false).signOut();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout),
        label: const Text('Sign Out'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
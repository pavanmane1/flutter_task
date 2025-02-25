import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;
    final todayDate = DateTime.now();
    final formattedDate = DateFormat("d MMM y").format(todayDate);
    final formattedFullName = capitalizeEachWord(userData!.fullName);
    return AppBar(
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
      automaticallyImplyLeading: false, // Remove default back button
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Circular Avatar & Name
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue[100],
                child: isImageAvailable(userData.customerProfileImage)
                    ? (userData.customerProfileImage.startsWith('http') ||
                            userData.customerProfileImage.startsWith('https'))
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(userData.customerProfileImage, fit: BoxFit.cover),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.file(File(userData.customerProfileImage), fit: BoxFit.cover),
                          )
                    : Text(
                        userData.fullName.isNotEmpty == true
                            ? userData.fullName[0].toUpperCase()
                            : '?', // Fallback if name is also missing
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedFullName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),

          // Right Side: Help Text & Notification Icon
          Row(
            children: [
              const Text(
                "HELP?",
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 10), // Space before line

              Container(
                width: 1.5,
                height: 20,
                color: AppColors.textPrimary, // Line color
              ),

              const SizedBox(width: 10), // Space after line
              Stack(
                children: [
                  const Icon(Icons.notifications_none, size: 35, color: AppColors.textPrimary),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String capitalizeEachWord(String name) {
    return name.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
  }

  bool isImageAvailable(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return true; // Assume network images are available
    }

    return File(imagePath).existsSync(); // Check if the local file exists
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}

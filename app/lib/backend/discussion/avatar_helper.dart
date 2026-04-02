import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

Widget buildAvatar(BuildContext context, String? avatarUrl, String name, {double radius = 20}) {
  // Check if it's an anonymous post
  final isAnonymous = name == 'Anonymous';
  
  if (isAnonymous) {
    // Anonymous avatar - use a silhouette or anonymous icon
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.buttonBorder,
      child: Icon(
        Icons.person_outline, // Or Icons.visibility_off, or Icons.incognito
        size: radius * 0.8,
        color: context.colors.textSecondary,
      ),
    );
  }
  
  // Regular user with avatar
  if (avatarUrl != null && avatarUrl.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(avatarUrl),
      onBackgroundImageError: (_, _) {
        // Fallback to person icon if image fails to load
      },
      child: null,
    );
  } else {
    // Default person icon for regular users without avatar
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.buttonBorder,
      child: Icon(
        Icons.person,
        size: radius * 0.8,
        color: context.colors.textSecondary,
      ),
    );
  }
}
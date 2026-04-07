import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildAvatar(BuildContext context, String? avatarUrl, String name, {double radius = 20}) {
  // Check if it's an anonymous post
  final isAnonymous = name == 'Anonymous';
  
  if (isAnonymous) {
    // Anonymous avatar - match welcome header style (blue background, white icon)
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.mainColor,
      child: Icon(
        Icons.person_outline,
        size: radius * 0.8,
        color: context.colors.whiteBackground,
      ),
    );
  }
  
  // Regular user with avatar - use CachedNetworkImage like UserAvatar
  if (avatarUrl != null && avatarUrl.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: radius,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: context.colors.mainColor,
        child: SizedBox(
          width: radius * 0.8,
          height: radius * 0.8,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: context.colors.mainColor,
        child: Icon(
          Icons.person,
          size: radius * 0.8,
          color: context.colors.whiteBackground,
        ),
      ),
    );
  } else {
    // Default person icon for regular users without avatar - match welcome header
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.mainColor,
      child: Icon(
        Icons.person,
        size: radius * 0.8,
        color: context.colors.whiteBackground,
      ),
    );
  }
}
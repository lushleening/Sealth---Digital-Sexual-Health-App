import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailSupportBtn extends ConsumerWidget {
  const EmailSupportBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(context.colors.mainColor),
        overlayColor: WidgetStatePropertyAll(context.colors.mainColoredBox),
      ),
      onPressed: () async {
        final uri = Uri.parse('mailto:$supportEmail');
        if (await canLaunchUrl(uri)) await launchUrl(uri);
        if (context.mounted) context.pop();
      },
      child: Text(
        "Email Us",
        style: TextStyle(
          color: context.colors.mainColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

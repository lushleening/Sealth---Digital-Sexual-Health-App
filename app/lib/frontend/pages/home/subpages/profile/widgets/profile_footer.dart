import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

class ProfileFooter extends ConsumerWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appMetadataProvider);
    return AsyncPage(
      state: state,
      pageContent: (m) => ProfileFooterContent(metadata: m),
      logTextOnError: (e, _) =>
          "An error occured while loading app metadata: $e",
    );
  }
}

class ProfileFooterContent extends StatelessWidget {
  final AppMetadata metadata;
  const ProfileFooterContent({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Profile footer generated.");
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: baseLength),
      child: Column(
        children: [
          Text(
            metadata.versionText,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          Text(
            metadata.legalLese,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

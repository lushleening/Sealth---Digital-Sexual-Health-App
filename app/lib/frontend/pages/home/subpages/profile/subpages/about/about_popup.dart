import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class AboutPopup extends ConsumerWidget {
  const AboutPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appMetadataProvider);
    return AsyncPage(
      state: state,
      pageContent: (m) => AboutPopupContent(metadata: m),
      logTextOnError: (e, _) =>
          "An error occured while loading app metadata: $e",
    );
  }
}

class AboutPopupContent extends StatelessWidget {
  final AppMetadata metadata;
  const AboutPopupContent({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("About popup generated.");
    return Dialog(
      backgroundColor: context.colors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Info Icon
            Image.asset(logoImage, width: imageLarge, height: imageLarge),
            const SizedBox(height: 8),

            // App name
            Text(
              metadata.appName,
              style: TextStyle(
                fontSize: 20,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            // App version
            const SizedBox(height: 4),
            Text(
              metadata.versionText,
              style: TextStyle(
                fontSize: 14,
                color: context.colors.textSecondary,
              ),
            ),

            // App legal text
            const SizedBox(height: 16),
            Text(
              "${metadata.legalLese1}\n${metadata.legalLese2}",
              style: TextStyle(
                fontSize: 14,
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Authors
            const SizedBox(height: 32),
            Text(
              "Developers",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 80),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: metadata.authors
                      .map(
                        (author) => Text(
                          author,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    context.colors.mainColor,
                  ),
                  overlayColor: WidgetStatePropertyAll(
                    context.colors.mainColor.withValues(
                      alpha: buttonOverlayAlpha,
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(key: KBtn.closePopup.key, 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref;
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPopup extends ConsumerWidget {
  const AboutPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appMetadataProvider);
    return AsyncPage(
      state: state,
      pageContent: (m) => _AboutPopupContent(metadata: m),
      logTextOnError: (e, _) =>
          "An error occured while loading app metadata: $e",
    );
  }
}

class _AboutPopupContent extends StatelessWidget {
  final AppMetadata metadata;
  const _AboutPopupContent({required this.metadata});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("About popup generated.");
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

            // Developers
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
            const SizedBox(height: 8),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  context.colors.mainColor,
                ),
                overlayColor: WidgetStatePropertyAll(
                  context.colors.mainColoredBox,
                ),
              ),
              onPressed: () {
                                  onTap: () {
                    if (isVerified) {
                      context.push(AppRoute.articleUpload);
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Verification Required"),
                          content: const Text(
                            "Only verified medical professionals can upload articles.\n\n"
                            "To request verification, please email us and we will review your application.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final userContext = ref.read(
                                  userContextProvider,
                                );
                                final remoteId =
                                    userContext
                                        .whenData((u) => u.user.remoteId)
                                        .value ??
                                    'Not a registered user';
                                final uri = Uri.parse(
                                  'mailto:$supportEmail?subject=$subject&body=$body',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                                if (ctx.mounted) Navigator.of(ctx).pop();
                              },
                              child: Text(
                                "Email Us",
                                style: TextStyle(
                                  color: context.colors.mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
              }, // TODO @abdul send email to the email
              child: Text("Email us"),
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
                child: Text(key: KBtn.navClosePopup.key, 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

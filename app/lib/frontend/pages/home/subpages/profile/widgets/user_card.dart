import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/login_choice_popup.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

// Display user's data
class UserCard extends ConsumerWidget {
  const UserCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userContextProvider);

    return AsyncPage(
      state: state,
      pageContent: (up) => up.isRegisteredUser
          ? RegisteredUserCard(profile: up.profile!)
          : const GuestUserCard(),
      logTextOnError: (e, _) => "User card display error: $e",
    );
  }
}

class GuestUserCard extends StatelessWidget {
  const GuestUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Guest User Card generated.");
    return Row(
      spacing: baseLength,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(baseLength / 2),
          child: CircleAvatar(
            radius: iconSizeLarge,
            backgroundColor: context.colors.mainColor,
            child: Icon(
              Icons.person,
              color: context.colors.whiteBackground,
              size: iconSizeLarge,
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.directional(end: baseLength * 2),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const LoginChoicePopup(),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(36),
                    side: BorderSide(width: 2, color: context.colors.mainColor),
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(double.infinity, iconSizeLarge * 2),
                ),
                overlayColor: WidgetStatePropertyAll(
                  context.colors.mainColor.withValues(
                    alpha: buttonOverlayAlpha,
                  ),
                ),
              ),
              child: Text(
                "Sign In",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: context.colors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisteredUserCard extends StatelessWidget {
  final AppRegisteredProfile profile;
  const RegisteredUserCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    uiLogger.fine("Registered User Card generated.");
    return Row(
      spacing: baseLength,
      children: [
        CircleAvatar(
          radius: iconSizeLarge,
          backgroundColor: context.colors.mainColor,
          child: Text(
            profile.avatarUrl ?? "A", // TODO get profile pic
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.directional(start: baseLength / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.username,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),

              Consumer(
                builder: (context, ref, _) {
                  final email = ref.read(supabaseAuthProvider).email;
                  return email == null
                      ? SizedBox.shrink()
                      : Text(
                          email,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(color: context.colors.textSecondary),
                        );
                },
              ),
              const SizedBox(height: 4),

              if (profile.verified) ...[
                Container(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: baseLength / 4,
                    horizontal: baseLength / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.mainColoredBox,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Verified Account",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: context.colors.mainColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/about/about_popup.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/privacy_policy/privacy_policy_popup.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/logout_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/remove_guest_data_button.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/profile_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/profile_footer.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/user_card.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      userContextProvider.select(
        (s) => s.whenData((cb) => cb.isRegisteredUser),
      ),
    );
    return AsyncPage(
      state: state,
      pageContent: (data) => _ProfilePageContent(isRegisteredUser: data),
      logTextOnError: (e, _) =>
          "An error occured while loading user information: $e",
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  final bool isRegisteredUser;
  const _ProfilePageContent({required this.isRegisteredUser});

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Profile Page generated.");
    final pBtns = [
      ProfileBtnData(
        kBtn: KBtn.navPersonalInfoBtn,
        icon: Icons.person,
        title: "Personal Information",
        description: "View and edit your profile details",
        linkToPage: AppRoutes.personalInfoP,
        displayCondition: isRegisteredUser,
      ),

      ProfileBtnData(
        kBtn: KBtn.navSettingsBtn,
        icon: Icons.settings,
        title: "Settings",
        description: "Control your app",
        linkToPage: AppRoutes.settingsP,
      ),

      ProfileBtnData(
        kBtn: KBtn.navAboutBtn,
        icon: Icons.info,
        title: "About",
        description: "About this app",
        popup: () => showDialog(
          context: context,
          builder: (_) => AboutPopup(key: KPage.about.key),
        ),
      ),

      ProfileBtnData(
        kBtn: KBtn.navPrivacyPolicyBtn,
        icon: Icons.help,
        title: "Privacy Policy",
        description: "Understand your rights",
        popup: () => showDialog(
          context: context,
          builder: (_) => PrivacyPolicyPopup(key: KPage.privacyPolicy.key), // Convert to gorouter
        ),
      ),
    ];
    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Profile",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.all(baseLength),
          child: SingleChildScrollView(
            child: Column(
              spacing: baseLength,
              children: [
                const UserCard(),
                Column(
                  children: pBtns
                      .map((pBtn) => ProfileBtn(data: pBtn))
                      .toList(),
                ),
                const SizedBox(height: baseLength / 4),
                if (isRegisteredUser)
                  LogoutBtn(key: KBtn.logout.key)
                else
                  RemoveGuestDataButton(key: KBtn.removeGuestData.key),
                const ProfileFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

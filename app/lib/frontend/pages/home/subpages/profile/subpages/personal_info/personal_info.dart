import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/personal_info/personal_info/personal_info_data.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/frontend/common_widgets/user_avatar.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/change_password_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/delete_local_cache_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/edit_fields_btn.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/info_card.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/subpages/personal_info/widgets/username_edit_field.dart';

// Able to edit user's personal information
class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalInfoProvider);
    return AsyncPage(
      state: state,
      pageContent: (data) => _PersonalInfoContent(data: data),
      logTextOnError: (e, _) => 'Could not generate personal info page: $e',
    );
  }
}

class _PersonalInfoContent extends ConsumerWidget {
  final PersonalInfoData data;
  const _PersonalInfoContent({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uiLogger.finer("Personal Info Page generated.");
    final profile = data.profile;

    // Expected behaviour from delete local cache and sign out
    if (profile == null) return SizedBox.shrink();

    final remoteId = data.user.remoteId;
    if (remoteId == null) {
      uiLogger.severe(
        // Should not happen
        "Could not find remote id for user in personal info page.",
      );
      return SizedBox.shrink();
    }

    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Personal Information",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(baseLength),
          child: Column(
            children: [
              const SizedBox(height: baseLength),
              GestureDetector(
                key: KBtn.piChangeAvatar.key,
                onTap: () async {
                  await ref
                      .read(editDetailsFormProvider.notifier)
                      .pickAvatar(remoteId, profile);
                },
                child: UserAvatar(
                  iconRadius: iconSizeExtraLarge,
                  defaultIcon: Icons.add,
                  isHighlighted: ref
                      .watch(editDetailsFormProvider)
                      .isHighlighted,
                ),
              ),

              const SizedBox(height: baseLength * 2),
              EditUsername(data: data),

              InfoCard(data: data),

              const SizedBox(height: baseLength),
              EditFieldsBtn(),

              const SizedBox(height: baseLength),
              ChangePasswordBtn(remoteId: remoteId),

              const SizedBox(height: baseLength),
              DeleteLocalCacheBtn(remoteId: remoteId),
            ],
          ),
        ),
      ),
    );
  }
}

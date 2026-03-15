import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';

class UserAvatar extends ConsumerWidget {
  final double iconRadius;
  final IconData defaultIcon;
  const UserAvatar({
    super.key,
    required this.iconRadius,
    this.defaultIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      appRegisteredProfileProvider.select(
        (p) => p.whenData((cb) => cb?.avatarUrl),
      ),
    );

    return AsyncPage(
      state: state,
      pageContent: (avatarUrl) => _UserAvatarContent(
        iconRadius: iconRadius,
        defaultIcon: defaultIcon,
        avatarUrl: avatarUrl,
      ),
      logTextOnError: (e, _) => "Failed to get avatar url",
    );
  }
}

class _UserAvatarContent extends StatelessWidget {
  final double iconRadius;
  final IconData? defaultIcon;
  final String? avatarUrl;
  const _UserAvatarContent({
    required this.iconRadius,
    this.defaultIcon,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null;
    return CircleAvatar(
      backgroundColor: context.colors.mainColor,
      radius: iconRadius,
      backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
      child: hasAvatar
          ? null
          : Icon(
              defaultIcon ?? Icons.add,
              size: iconRadius,
              color: context.colors.whiteBackground,
            ),
    );
  }
}

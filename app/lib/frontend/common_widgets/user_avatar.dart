import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';

class UserAvatar extends ConsumerWidget {
  final double iconRadius;
  final IconData defaultIcon;
  final bool isHighlighted;
  const UserAvatar({
    super.key,
    required this.iconRadius,
    this.defaultIcon = Icons.person,
    this.isHighlighted = false,
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
        defaultIconData: defaultIcon,
        avatarUrl: avatarUrl,
        isHighlighted: isHighlighted,
      ),
      logTextOnError: (e, _) => "Failed to get avatar url",
    );
  }
}

class _UserAvatarContent extends StatelessWidget {
  final double iconRadius;
  final IconData? defaultIconData;
  final String? avatarUrl;
  final bool isHighlighted;
  const _UserAvatarContent({
    required this.iconRadius,
    this.defaultIconData,
    this.avatarUrl,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isHighlighted ? context.colors.mainColor : Colors.transparent,
          width: 3,
        ),
      ),
      child: avatarUrl == null
          ? CircleAvatar(
              backgroundColor: context.colors.mainColor,
              radius: iconRadius,
              child: DefaultAvatarIcon(
                iconRadius: iconRadius,
                defaultIconData: defaultIconData,
              ),
            )
          // Image are cached for offline usage
          : CachedNetworkImage(
              imageUrl: avatarUrl!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: iconRadius,
              ),
              placeholder: (context, url) => LoadingCircleMainColor(),
              errorWidget: (context, url, error) => DefaultAvatarIcon(
                iconRadius: iconRadius,
                defaultIconData: defaultIconData,
              ),
            ),
    );
  }
}

class DefaultAvatarIcon extends StatelessWidget {
  final double iconRadius;
  final IconData? defaultIconData;
  const DefaultAvatarIcon({
    super.key,
    required this.iconRadius,
    this.defaultIconData,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      defaultIconData ?? Icons.add,
      size: iconRadius,
      color: context.colors.whiteBackground,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
part 'colors.tailor.dart';

// Helper method, allows code format of "context.color.*"
extension AppTheme on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

// Format is "#009689" => 0xFF009689 where
// 0x: hex
// FF: 100% opacity
// 009688: hex value (and btw its teal)

// Light mode colors
const lightAppColors = AppColors(
  mainColor: Color(0xFF009688),
  mainColoredBox: Color(0xFFE9F6FF),
  whiteBackground: Color(0xFFFFFFFF),
  grayBackground: Color(0xFFF3F7FF),

  alert: Color(0xFFE7000B),

  textWhite: Color(0xFFFFFFFF),
  textPrimary: Color(0xFF000000),
  textSecondary: Color(0xFF686868),

  buttonBorder: Color(0xFFF3F4F6),
  boxShadowGray: Color(0xFFCAC4D0),

  textBoxFill: Color(0xFFf3f3f5),
  textBoxUnderline: Color(0xFFe1e1e3),
  textBoxIcon: Color(0xFF6A7282),

  switchThumb: Color(0xFFFFFFFF),
  switchInactiveTrack: Color(0xFF717182),
  switchActiveTrack: Color(0xFF009688),

  articlehashtagBlueText: Color(0xFF1976D2),
  articlehashtagBlueBorder: Color(0xFFE3F2FD),
);

// Dark mode colors
const darkAppColors = AppColors(
  mainColor: Color(0xFF00BFA5),
  mainColoredBox: Color(0xFF1E2A2F),

  whiteBackground: Color(0xFF121212),
  grayBackground: Color(0xFF1E1E1E),

  alert: Color(0xFFFF5252),

  textWhite: Color(0xFFFFFFFF),
  textPrimary: Color(0xFFE0E0E0),
  textSecondary: Color(0xFF9E9E9E),

  buttonBorder: Color(0xFF2C2C2C),
  boxShadowGray: Color(0xFF000000),

  textBoxFill: Color(0xFF1F1F1F),
  textBoxUnderline: Color(0xFF333333),
  textBoxIcon: Color(0xFFB0BEC5),

  switchThumb: Color(0xFFFFFFFF),
  switchInactiveTrack: Color(0xFF424242),
  switchActiveTrack: Color(0xFF00BFA5),

  articlehashtagBlueText: Color(0xFF64B5F6),
  articlehashtagBlueBorder: Color(0xFF1E3A5F),
);

// Codegen, removes manual repititive input for copyWith and lerp function
@TailorMixin()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  @override
  final Color mainColor;
  @override
  final Color mainColoredBox;
  @override
  final Color whiteBackground;
  @override
  final Color grayBackground;

  @override
  final Color alert;

  @override
  final Color textWhite;
  @override
  final Color textPrimary;
  @override
  final Color textSecondary;

  @override
  final Color buttonBorder;
  @override
  final Color boxShadowGray;

  @override
  final Color textBoxFill;
  @override
  final Color textBoxUnderline;
  @override
  final Color textBoxIcon;

  @override
  final Color switchThumb;
  @override
  final Color switchInactiveTrack;
  @override
  final Color switchActiveTrack;

  @override
  final Color articlehashtagBlueText;
  @override
  final Color articlehashtagBlueBorder;

  const AppColors({
    required this.mainColor,
    required this.mainColoredBox,
    required this.whiteBackground,
    required this.grayBackground,

    required this.alert,

    required this.textWhite,
    required this.textPrimary,
    required this.textSecondary,

    required this.buttonBorder,
    required this.boxShadowGray,

    required this.textBoxFill,
    required this.textBoxUnderline,
    required this.textBoxIcon,

    required this.switchThumb,
    required this.switchInactiveTrack,
    required this.switchActiveTrack,

    required this.articlehashtagBlueText,
    required this.articlehashtagBlueBorder,
  });
}

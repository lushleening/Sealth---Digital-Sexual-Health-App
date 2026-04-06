import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/snackbar/snackbar_message.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

Future<File?> pickImage({
  required ImagePicker picker,
  required int maxSize,
  required VoidCallback onError,
}) async {
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final fileSize = await picked.length();

  uiLogger.info("File size: $fileSize");
  if (fileSize > maxSize) {
    onError.call();
    return null;
  }
  return File(picked.path);
}

Future<File?> pickAvatarImage() => pickImage(
  picker: ImagePicker(),
  maxSize: maxAvatarSize,
  onError: () => showSnackbarMessage("Image must be less than $avatarMB MB."),
);

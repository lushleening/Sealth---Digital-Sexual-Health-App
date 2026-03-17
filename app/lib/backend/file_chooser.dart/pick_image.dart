import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';

Future<File?> pickImage(int maxSize) async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final file = File(picked.path);
  final fileSize = await file.length();
  
  if (fileSize > maxSize) {
    showSnackbarMessage("Image must be less than 2 MB.");
    return null;
  }
  return file;
}
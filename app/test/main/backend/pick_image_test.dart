import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sddp_dsh/backend/constants/storage.dart';
import 'package:sddp_dsh/backend/file_chooser/pick_image.dart';

import '../../helper/mock_objects.dart';

void main() {
  test("pickImage returns null on no picking image", () async {
    final mockPicker = MockImagePicker();
    when(
      () => mockPicker.pickImage(source: ImageSource.gallery),
    ).thenAnswer((_) async => null);

    final result = await pickImage(
      picker: mockPicker,
      maxSize: maxAvatarSize,
      onError: () {},
    );
    expect(result, isNull);
  });

  test("pickImage returns null on exceeding file size", () async {
    final maxSize = maxAvatarSize;
    final largeFile = MockXFile();
    when(() => largeFile.path).thenReturn('');
    when(() => largeFile.length()).thenAnswer((_) => Future.value(maxSize * 2));

    final mockPicker = MockImagePicker();
    when(
      () => mockPicker.pickImage(source: ImageSource.gallery),
    ).thenAnswer((_) => Future.value(largeFile));

    final result = await pickImage(
      picker: mockPicker,
      maxSize: maxSize,
      onError: () {},
    );
    expect(result, isNull);
  });

  test("pickImage returns file on valid file", () async {
    final validFile = MockXFile();
    when(() => validFile.path).thenReturn('');
    when(() => validFile.length()).thenAnswer((_) => Future.value(1));

    final mockPicker = MockImagePicker();
    when(
      () => mockPicker.pickImage(source: ImageSource.gallery),
    ).thenAnswer((_) => Future.value(validFile));

    final result = await pickImage(
      picker: mockPicker,
      maxSize: maxAvatarSize,
      onError: () {},
    );
    expect(result, isNotNull);
  });
}

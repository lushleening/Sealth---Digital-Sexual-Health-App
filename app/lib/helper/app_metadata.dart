import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_metadata.freezed.dart';
part 'app_metadata.g.dart';

// Long form: Sealth - Your Sexual Health Assistant
@freezed
abstract class AppMetadata with _$AppMetadata {
  const factory AppMetadata({
    required String appName,
    required String version,
    required String buildNumber,
  }) = _AppMetadata;

  const AppMetadata._();
  String get versionText => "Version $version+$buildNumber";
  String get legalLese1 => "© 2026 $appName.";
  String get legalLese2 => "All rights reserved";
  String get legalLese => "$legalLese1 $legalLese2";
  List<String> get authors => const [
    "Mah Han Cheng",
    "Abdul Hadi Ghani",
    "Lushantha Lee Ning",
    "Stanly Teh Whye Bin",
  ];
}

@Riverpod(keepAlive: true)
class AppMetadataNotifier extends _$AppMetadataNotifier {
  @override
  Future<AppMetadata> build() async {
    final info = await PackageInfo.fromPlatform();
    return AppMetadata(
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}

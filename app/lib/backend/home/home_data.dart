// This provides data for welcome headers
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/appointments/appointment.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/metadata/app_metadata.dart';
import 'package:sddp_dsh/backend/user/user_context/user_context.dart';

part 'home_data.freezed.dart';
part 'home_data.g.dart';

@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required String appName,
    required UserContext userContext,
    required List<Appointment> appointments,
    required List<Article> articles,
  }) = _HomeData;
}

// Since the scope for this provider is only on one page, we can do
// remove keepAlive to save resources and prevent useless listening
@riverpod
class HomeDataNotifier extends _$HomeDataNotifier {
  @override
  Future<HomeData> build() async => HomeData(
    // Only uses appName so just selectAsync
    appName: await ref.watch(appMetadataProvider.selectAsync((m) => m.appName)),

    // May use other userContext variables in the future thus get the full context instead
    userContext: await ref.watch(userContextProvider.future),

    // User feed
    appointments: await ref.watch(userAppointmentsProvider.future),
    articles: ref.watch(articlesProvider).map((data) => data["article"] as Article).toList(),
  );
}

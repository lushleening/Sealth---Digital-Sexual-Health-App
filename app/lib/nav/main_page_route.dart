// CODEGEN RELATED: "dart run build_runner watch"
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/nav/app_navigation_lock.dart';
import 'package:sddp_dsh/testing/key_enum.dart';

part 'main_page_route.g.dart';

// For navigation use this line to change pages:
// ref.read(pageIndexProvider.notifier).setPage()
// for subpages check navPush and navPop instead
enum MainPageRoute {
  home(from: KBtn.homeBottomNav, to: KPage.home),
  discussion(from: KBtn.discussionBottomNav, to: KPage.discussion),
  appointment(from: KBtn.appointmentBottomNav, to: KPage.appointment),
  article(from: KBtn.articleBottomNav, to: KPage.article);

  const MainPageRoute({required this.from, required this.to});
  final KBtn from;
  final KPage to;
}

// Is independent from subpages since uses Indexed Stack under the hood
// Entrypoint for altering the Indexed Stack to change between main pages
// Used to ensure fast main page navigation since all pages are rendered beforehand
@Riverpod(keepAlive: true)
class MainPageRouteNotifier extends _$MainPageRouteNotifier {
  @override
  MainPageRoute build() => MainPageRoute.home;
  void setPage(MainPageRoute i) {
    if (ref.read(appNavigationLockProvider)) return;
    final lock = ref.read(appNavigationLockProvider.notifier);
    lock.lock();
    state = i;
    lock.unlock();
  }
}

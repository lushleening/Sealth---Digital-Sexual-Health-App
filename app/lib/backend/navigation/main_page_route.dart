import 'package:sddp_dsh/backend/testing/key_enum.dart';

enum MainPageRoute {
  home(from: KBtn.homeBottomNav, to: KPage.home),
  discussion(from: KBtn.discussionBottomNav, to: KPage.discussion),
  appointment(from: KBtn.appointmentBottomNav, to: KPage.appointment),
  article(from: KBtn.articleBottomNav, to: KPage.article);

  const MainPageRoute({required this.from, required this.to});
  final KBtn from;
  final KPage to;
}

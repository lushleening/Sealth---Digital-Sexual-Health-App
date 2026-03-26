import 'package:sddp_dsh/backend/testing/key_enum.dart';

class AppRoute {
  // *R are for navRouter use, apparently they don't take in
  // absolute paths which requires us to copy the path twice
  static const notificationsR = 'notifications';

  static const profileR = 'profile';
  static const aboutR = 'about';
  static const privacyR = 'privacy';
  static const settingsR = 'settings';
  static const personalInfoR = 'personalInfo';

  static const loginR = 'login';
  static const registerR = 'register';
  static const forgotPasswordR = 'forgotPassword';

  // TODO I only added the paths to supress the warnings in test/*, you'd need to add the go_routes yourselves
  static const addEventR = 'addEvent';
  static const editEventsR = 'editEvents';
  static const nearbyServicesR = 'nearbyServices';

  static const uploadArticlesR = 'uploadArticles';

  // These are for normal use
  static const root = '/';
  static const resetPassword = '/resetPassword';

  static const home = '/home';
  static const notifications = '$home/$notificationsR';
  static const profile = '$home/$profileR';

  static const about = '$profile/$aboutR';
  static const privacy = '$profile/$privacyR';
  static const settings = '$profile/$settingsR';
  static const personalInfo = '$profile/$personalInfoR';

  static const login = '$profile/$loginR';
  static const register = '$login/$registerR';
  static const forgotPassword = '$login/$forgotPasswordR';

  static const discussion = '/discussion';

  static const appointments = '/appointments';
  static const addEvent = '$appointments/$addEventR';
  static const editEvents = '$appointments/$editEventsR';
  static const nearbyServices = '$appointments/$nearbyServicesR';

  static const articles = '/articles';
  static const uploadArticles = '$appointments/$uploadArticlesR';

  static const mainPages = {
    home: KBtn.homeBottomNav,
    discussion: KBtn.discussionBottomNav,
    appointments: KBtn.appointmentBottomNav,
    articles: KBtn.articleBottomNav,
  };

  const AppRoute._(); // This class has no constructors
}

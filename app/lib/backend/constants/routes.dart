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
  static const changePasswordR = 'changePassword';

  static const loginR = 'login';
  static const registerR = 'register';
  static const forgotPasswordR = 'forgotPassword';

  static const addEventR = 'addEvent';
  static const editEventsR = 'editEvents';
  static const nearbyServicesR = 'nearbyServices';

  static const uploadArticlesR = 'uploadArticles';

  // Article sub-routes (relative)
  static const articleViewR = 'view';
  static const articleUploadR = 'upload';
  static const articleEditR = 'edit';
  static const articleBookmarksR = 'bookmarks';

  // These are for normal use
  static const root = '/';

  static const home = '/home';
  static const notifications = '$home/$notificationsR';
  static const profile = '$home/$profileR';

  static const settings = '$profile/$settingsR';

  static const personalInfo = '$profile/$personalInfoR';
  static const changePassword = '$personalInfo/$changePasswordR';

  static const login = '$profile/$loginR';
  static const register = '$login/$registerR';
  static const forgotPassword = '$login/$forgotPasswordR';
  static const resetPassword = '/resetPassword';
  static const resetLogin = '/resetLogin';

  static const discussion = '/discussion';

  static const appointments = '/appointments';
  static const addEvent = '$appointments/$addEventR';
  static const editEvents = '$appointments/$editEventsR';
  static const nearbyServices = '$appointments/$nearbyServicesR';

  static const articles = '/articles';
  static const uploadArticles = '$appointments/$uploadArticlesR';

  // Article full paths
  static const articleView = '$articles/$articleViewR';
  static const articleUpload = '$articles/$articleUploadR';
  static const articleEdit = '$articles/$articleEditR';
  static const articleBookmarks = '$articles/$articleBookmarksR';

  static const mainPages = {
    home: KBtn.navHomeBottom,
    discussion: KBtn.navDiscussionBottom,
    appointments: KBtn.navAppointmentBottom,
    articles: KBtn.navArticleBottom,
  };

  const AppRoute._(); // This class has no constructors
}

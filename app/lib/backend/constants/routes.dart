class AppRoutes {
  static const root = '/';
  
  static const home = '/home';
  static const notifications = 'notifications';
  static const profile = 'profile';
  static const settings = 'settings';
  static const personalInfo = 'personal-info';
  static const login = 'login';
  static const forgotPassword = 'forgot-password';
  static const register = 'register';
  

  static const notificationsP = '$home/notifications';
  static const profileP = '$home/profile';
  static const settingsP = '$profileP/settings';
  static const personalInfoP = '$profileP/personal-info';
  static const loginP = '$profileP/login';
  static const forgotPasswordP = '$loginP/forgot-password';
  static const registerP = '$loginP/register';


  // Articles
  static const articles = '/articles';
  static const articleView = 'view';
  static const articleUpload = 'upload';
  static const articleEdit = 'edit';
  static const articleBookmarks = 'bookmarks';
 
  static const articleViewP = '$articles/$articleView';
  static const articleUploadP = '$articles/$articleUpload';
  static const articleEditP = '$articles/$articleEdit';
  static const articleBookmarksP = '$articles/$articleBookmarks';
}


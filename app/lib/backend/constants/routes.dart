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
}


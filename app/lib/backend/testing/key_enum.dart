import 'package:flutter/material.dart';

// Used for testing

// Scoped keys, test per page basis
// The * in *_ENUM is used to remove key duplicates so don't repeat it
// Each key should only have one widget using it in normal circustances

// Pages in app
enum KPage {
  home,
  discussion,
  appointment,
  article,

  addEvents,

  notification,

  profile,
  settings,
  personalInfo,
  about,
  privacyPolicy,

  login,
  register,
  forgotPassword,

  logoutDialog,

  uploadArticle,
  bookmarks,
}

extension KPageX on KPage {
  Key get key => Key('page_$name');
}

// Buttons that can be pressed to test the app
enum KBtn {
  homeBottomNav,
  discussionBottomNav,
  appointmentBottomNav,
  articleBottomNav,

  backButton,
  closePopup,

  pendingAppointment,
  continueReadingArticle,
  newArticle,

  navNotificationBell,
  navSettingsBtn,
  navProfileAvatar,
  navPersonalInfoBtn,
  navRegisterLink,
  navForgotPasswordLink,
  navAboutBtn,
  navPrivacyPolicyBtn,

  settingsDarkMode,
  settingsReceiveNotifications,
  settingsAutoUpdate,

  logoutBtn,

  choiceDialogNo,
  choiceDialogYes,

  uploadArticleBtn,
  uploadPdfBtn,
  uploadImageBtn,
  navBookmarkBtn,
  articleCard,

  reminderBanner,
  filterDropdown,
  appointmentCard,
  addEvent,
  nearbyServices,
  eventaddbutton,
  cancelbutton,
  deletebutton,
  savebutton,
  scheduleAppointment,
}

extension KBtnX on KBtn {
  Key get key => Key('btn_$name');
}

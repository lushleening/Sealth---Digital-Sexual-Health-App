import 'package:flutter/material.dart';

// Used for testing

// Scoped keys, test per page basis
// The * in *_ENUM is used to remove key duplicates so don't repeat it
// Each key should only have one widget using it in normal circustances

// TODO Im trying to remove KPage enum, so try to remove your stuffs here and use
// TODO expectObj(SomeDialogClass) for popups, expectPath(AppRoute.*) for navigation path widgets / pages
// Pages in app
enum KPage {
  discussion,
  appointment,
  article,

  addEvents,

  uploadArticle,
  bookmarks,
}

extension KPageX on KPage {
  Key get key => Key('page_$name');
}

// Buttons that can be pressed to test the app
enum KBtn {
  // Misc
  choiceDialogNo,
  choiceDialogYes,
  navBackButton,
  navClosePopup,

  // Bottom Navigation Bar
  navHomeBottom,
  navDiscussionBottom,
  navAppointmentBottom,
  navArticleBottom,

  // Home Page
  navPendingAppointment,
  navContinueReadingArticle,
  navNewArticles,
  navNotificationBell,
  navProfile,

  // Profile Page
  navSettings,
  navPersonalInfo, // Registered
  navAbout,
  navPrivacyPolicy,
  navSignIn,
  authRemoveGuestData, // Guest
  authSignOut, // Registered

  // Settings Page
  settingsDarkMode,
  settingsReceiveNotifications,
  settingsBiometricConfirmation,

  // Personal Info (pi) Page (Registered)
  piChangeAvatar,
  piChangeUsername,
  piSaveUsername,
  piChangePassword,
  piToggleEditable,
  piDeleteLocalCache,

  // Login Page / Subpages
  navSignInEmail,
  navSignInGoogle,
  navSignInApple,
  navRegister,
  navForgotPassword,

  emailSignIn,
  passwordSignIn,
  submitSignIn,

  emailRegister,
  passwordRegister,
  confirmPasswordRegister,
  submitRegister,

  emailForgotPassword,
  submitForgotPassword,

  // TODO categorize your stuff

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

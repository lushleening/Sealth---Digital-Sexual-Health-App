import 'package:flutter/material.dart';

// Used for testing

// Scoped keys, test per page basis
// The * in *_ENUM is used to remove key duplicates so don't repeat it
// Each key should only have one widget using it in normal circustances

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
  navNewArticles,
  navNotificationBell,
  navProfile,

  // Notification page
  removeNotification,

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

  // Sign in
  emailSignIn,
  passwordSignIn,
  submitSignIn,

  // Register
  emailRegister,
  passwordRegister,
  confirmPasswordRegister,
  submitRegister,

  // Forgot password
  emailForgotPassword,
  submitForgotPassword,

  navUploadArticles,
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
  bookmark,
  back, 
  clinicDropdown, 
  serviceDropdown, 
  datePicker, 
  timePicker, 
  notesField,
}

extension KBtnX on KBtn {
  Key get key => Key('btn_$name');
}

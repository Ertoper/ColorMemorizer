import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @kazakh.
  ///
  /// In en, this message translates to:
  /// **'Kazakh'**
  String get kazakh;

  /// No description provided for @playButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButton;

  /// No description provided for @leaderboardButton.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardButton;

  /// No description provided for @levelSelectionPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Level Selection'**
  String get levelSelectionPageTitle;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutPageTitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Color Memorizer Game\n'**
  String get appDescription;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'This mobile game challenges players to memorize a sequence of colors and reproduce it correctly across different levels.\n\nDeveloped by Tungatar Ersayyn and Roman Bushnyak in the scope of the course \'Crossplatform Development\' at Astana IT University.\nMentor (Teacher): Assistant Professor Abzal Kyzyrkanov'**
  String get credits;

  /// No description provided for @leaderboardPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardPageTitle;

  /// No description provided for @yourRank.
  ///
  /// In en, this message translates to:
  /// **'Your Rank'**
  String get yourRank;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get accountTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @registerInstead.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get registerInstead;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @loginInstead.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login instead'**
  String get loginInstead;

  /// No description provided for @watchSequence.
  ///
  /// In en, this message translates to:
  /// **'Watch the sequence'**
  String get watchSequence;

  /// No description provided for @yourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get yourTurn;

  /// No description provided for @correctNextRound.
  ///
  /// In en, this message translates to:
  /// **'Correct! Get ready for the next round!'**
  String get correctNextRound;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over! Try again.'**
  String get gameOver;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You won!'**
  String get victory;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use by another account.'**
  String get emailAlreadyInUse;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get passwordTooWeak;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed. Please contact support.'**
  String get operationNotAllowed;

  /// No description provided for @anUnexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get anUnexpectedErrorOccurred;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @loginToAccessFeature.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access this feature.'**
  String get loginToAccessFeature;

  /// No description provided for @loginFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials and try again.'**
  String get loginFailedGeneric;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrongPassword;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user has been disabled.'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get tooManyRequests;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @onlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Back Online!'**
  String get onlineStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline.'**
  String get offlineStatus;

  /// No description provided for @failedToLoadLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to load leaderboard. Showing local data.'**
  String get failedToLoadLeaderboard;

  /// No description provided for @noLocalData.
  ///
  /// In en, this message translates to:
  /// **'No local data available. Connect to internet to sync.'**
  String get noLocalData;

  /// No description provided for @noLeaderboardData.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data available yet. Play a game to submit your score!'**
  String get noLeaderboardData;

  /// No description provided for @syncButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncButtonTooltip;

  /// No description provided for @notInTop.
  ///
  /// In en, this message translates to:
  /// **'Not in Top'**
  String get notInTop;

  /// No description provided for @levelSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Level'**
  String get levelSelectionTitle;

  /// No description provided for @simulateGameEnd.
  ///
  /// In en, this message translates to:
  /// **'Simulate Game End and Submit Score:'**
  String get simulateGameEnd;

  /// No description provided for @yourScoreHint.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScoreHint;

  /// No description provided for @submitScoreButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Score'**
  String get submitScoreButton;

  /// No description provided for @loginToSubmitScore.
  ///
  /// In en, this message translates to:
  /// **'Please log in to submit a score.'**
  String get loginToSubmitScore;

  /// No description provided for @scoreSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Score submitted successfully!'**
  String get scoreSubmittedSuccessfully;

  /// No description provided for @failedToSubmitScore.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit score.'**
  String get failedToSubmitScore;

  /// No description provided for @startGamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Starting game...'**
  String get startGamePlaceholder;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a simple color memorizer game designed to challenge your memory and concentration. Improve your cognitive skills by remembering color patterns and replaying them accurately.'**
  String get aboutAppDescription;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternetConnection;

  /// No description provided for @internalError.
  ///
  /// In en, this message translates to:
  /// **'Internal error occurred. Please try again.'**
  String get internalError;

  /// No description provided for @firebaseError.
  ///
  /// In en, this message translates to:
  /// **'Firebase error'**
  String get firebaseError;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetMessage;

  /// No description provided for @endlessButton.
  ///
  /// In en, this message translates to:
  /// **'Endless Game'**
  String get endlessButton;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @correctNextLevel.
  ///
  /// In en, this message translates to:
  /// **'Correct! Next level'**
  String get correctNextLevel;

  /// Message shown when the game ends, including the user's level.
  ///
  /// In en, this message translates to:
  /// **'Game over. Your level: {level}'**
  String gameOverLevel(Object level);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'kk': return AppLocalizationsKk();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

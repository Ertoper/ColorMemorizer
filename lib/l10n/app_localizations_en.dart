// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get kazakh => 'Kazakh';

  @override
  String get playButton => 'Play';

  @override
  String get leaderboardButton => 'Leaderboard';

  @override
  String get levelSelectionPageTitle => 'Level Selection';

  @override
  String get aboutPageTitle => 'About';

  @override
  String get appDescription => 'Color Memorizer Game\n';

  @override
  String get credits => 'This mobile game challenges players to memorize a sequence of colors and reproduce it correctly across different levels.\n\nDeveloped by Tungatar Ersayyn and Roman Bushnyak in the scope of the course \'Crossplatform Development\' at Astana IT University.\nMentor (Teacher): Assistant Professor Abzal Kyzyrkanov';

  @override
  String get leaderboardPageTitle => 'Leaderboard';

  @override
  String get yourRank => 'Your Rank';

  @override
  String get yourScore => 'Your Score';

  @override
  String get logoutButton => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get accountTitle => 'Your Account';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get registerInstead => 'Don\'t have an account? Register';

  @override
  String get registerTitle => 'Register';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDontMatch => 'Passwords do not match';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get registerButton => 'Register';

  @override
  String get loginInstead => 'Already have an account? Login instead';

  @override
  String get watchSequence => 'Watch the sequence';

  @override
  String get yourTurn => 'Your turn';

  @override
  String get correctNextRound => 'Correct! Get ready for the next round!';

  @override
  String get gameOver => 'Game Over! Try again.';

  @override
  String get level => 'Level';

  @override
  String get victory => 'Congratulations! You won!';

  @override
  String get emailAlreadyInUse => 'The email address is already in use by another account.';

  @override
  String get passwordTooWeak => 'The password provided is too weak.';

  @override
  String get operationNotAllowed => 'Operation not allowed. Please contact support.';

  @override
  String get anUnexpectedErrorOccurred => 'An unexpected error occurred. Please try again.';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get home => 'Home';

  @override
  String get loginToAccessFeature => 'Please log in to access this feature.';

  @override
  String get loginFailedGeneric => 'Login failed. Please check your credentials and try again.';

  @override
  String get userNotFound => 'No user found for that email.';

  @override
  String get wrongPassword => 'Wrong password provided for that user.';

  @override
  String get userDisabled => 'This user has been disabled.';

  @override
  String get tooManyRequests => 'Too many requests. Please try again later.';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get onlineStatus => 'Back Online!';

  @override
  String get offlineStatus => 'You are currently offline.';

  @override
  String get failedToLoadLeaderboard => 'Failed to load leaderboard. Showing local data.';

  @override
  String get noLocalData => 'No local data available. Connect to internet to sync.';

  @override
  String get noLeaderboardData => 'No leaderboard data available yet. Play a game to submit your score!';

  @override
  String get syncButtonTooltip => 'Sync Data';

  @override
  String get notInTop => 'Not in Top';

  @override
  String get levelSelectionTitle => 'Select Level';

  @override
  String get simulateGameEnd => 'Simulate Game End and Submit Score:';

  @override
  String get yourScoreHint => 'Your Score';

  @override
  String get submitScoreButton => 'Submit Score';

  @override
  String get loginToSubmitScore => 'Please log in to submit a score.';

  @override
  String get scoreSubmittedSuccessfully => 'Score submitted successfully!';

  @override
  String get failedToSubmitScore => 'Failed to submit score.';

  @override
  String get startGamePlaceholder => 'Starting game...';

  @override
  String get play => 'Play';

  @override
  String get aboutAppDescription => 'This is a simple color memorizer game designed to challenge your memory and concentration. Improve your cognitive skills by remembering color patterns and replaying them accurately.';

  @override
  String get noInternetConnection => 'No internet connection.';

  @override
  String get internalError => 'Internal error occurred. Please try again.';

  @override
  String get firebaseError => 'Firebase error';

  @override
  String get noInternetMessage => 'No internet connection';

  @override
  String get endlessButton => 'Endless Game';

  @override
  String get record => 'Record';

  @override
  String get correctNextLevel => 'Correct! Next level';

  @override
  String gameOverLevel(Object level) {
    return 'Game over. Your level: $level';
  }
}

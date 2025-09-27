import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ur'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih'**
  String get appTitle;

  /// The application subtitle
  ///
  /// In en, this message translates to:
  /// **'Islamic Prayer Counter'**
  String get appSubtitle;

  /// Label for the current count
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Title for reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset Counter'**
  String get resetConfirmTitle;

  /// Message for reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset the counter to zero?'**
  String get resetConfirmMessage;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Button text to select dhikr type
  ///
  /// In en, this message translates to:
  /// **'Select Dhikr'**
  String get selectDhikr;

  /// Button text to change dhikr type
  ///
  /// In en, this message translates to:
  /// **'Change Dhikr Type'**
  String get changeDhikrType;

  /// Label for target count
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// Message when target is reached
  ///
  /// In en, this message translates to:
  /// **'✓ Target Completed'**
  String get targetReached;

  /// Classical Tasbih category title
  ///
  /// In en, this message translates to:
  /// **'Classical Tasbih'**
  String get classicalTasbih;

  /// Classical Tasbih category description
  ///
  /// In en, this message translates to:
  /// **'Traditional tasbih after prayers'**
  String get classicalTasbihDesc;

  /// Morning Adhkar category title
  ///
  /// In en, this message translates to:
  /// **'Morning Adhkar'**
  String get morningAdhkar;

  /// Morning Adhkar category description
  ///
  /// In en, this message translates to:
  /// **'Recommended morning remembrances'**
  String get morningAdhkarDesc;

  /// Evening Adhkar category title
  ///
  /// In en, this message translates to:
  /// **'Evening Adhkar'**
  String get eveningAdhkar;

  /// Evening Adhkar category description
  ///
  /// In en, this message translates to:
  /// **'Recommended evening remembrances'**
  String get eveningAdhkarDesc;

  /// General Dhikr category title
  ///
  /// In en, this message translates to:
  /// **'General Dhikr'**
  String get generalDhikr;

  /// General Dhikr category description
  ///
  /// In en, this message translates to:
  /// **'Remembrances for any time'**
  String get generalDhikrDesc;

  /// After Prayer Adhkar category title
  ///
  /// In en, this message translates to:
  /// **'After Prayer Adhkar'**
  String get afterPrayerAdhkar;

  /// After Prayer Adhkar category description
  ///
  /// In en, this message translates to:
  /// **'Recommended remembrances after finishing prayer'**
  String get afterPrayerAdhkarDesc;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Vibration setting label
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Font size setting label
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Small size option
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// Medium size option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Large size option
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// Extra large size option
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLarge;

  /// Statistics screen title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Custom dhikr creation
  ///
  /// In en, this message translates to:
  /// **'Custom Dhikr'**
  String get customDhikr;

  /// Advanced features screen title
  ///
  /// In en, this message translates to:
  /// **'Advanced Features'**
  String get advancedFeatures;

  /// Goals and achievements
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// Achievements section title
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Backup and restore
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Restore data
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Share progress socially
  ///
  /// In en, this message translates to:
  /// **'Social Sharing'**
  String get socialSharing;

  /// Share dhikr progress
  ///
  /// In en, this message translates to:
  /// **'Share Progress'**
  String get shareProgress;

  /// Export user data
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// AI-powered recommendations
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestions;

  /// Enhanced visual feedback
  ///
  /// In en, this message translates to:
  /// **'Progress Animations'**
  String get progressAnimations;

  /// User motivation setting
  ///
  /// In en, this message translates to:
  /// **'Motivation Level'**
  String get motivationLevel;

  /// Achievement message
  ///
  /// In en, this message translates to:
  /// **'Target Completed!'**
  String get targetCompleted;

  /// Completion congratulations
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have reached your dhikr target.'**
  String get congratulations;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Begin new dhikr session
  ///
  /// In en, this message translates to:
  /// **'Start New Session'**
  String get startNewSession;

  /// Completion rate section title
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// Number of dhikr sessions
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// Current week stats
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Current month stats
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Create data backup
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// Insights section title
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// Weekly progress report
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih Counter'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Keep track of your dhikr and prayers with our beautiful digital counter'**
  String get onboardingDesc1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Customizable Experience'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Choose from various dhikr types, set targets, and personalize your spiritual journey'**
  String get onboardingDesc2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'View detailed statistics, achieve goals, and maintain consistency in your worship'**
  String get onboardingDesc3;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// App shortcut for SubhanAllah dhikr
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get shortcutSubhanAllah;

  /// App shortcut for Alhamdulillah dhikr
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get shortcutAlhamdulillah;

  /// App shortcut for Allahu Akbar dhikr
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get shortcutAllahuAkbar;

  /// App shortcut for La ilaha illallah dhikr
  ///
  /// In en, this message translates to:
  /// **'La ilaha illallah'**
  String get shortcutLaIlahaIllallah;

  /// Quick increment button
  ///
  /// In en, this message translates to:
  /// **'Quick Count'**
  String get quickIncrement;

  /// Quick settings panel title
  ///
  /// In en, this message translates to:
  /// **'Quick Settings'**
  String get quickSettings;

  /// Quick counter notification toggle
  ///
  /// In en, this message translates to:
  /// **'Quick Counter'**
  String get quickCounter;

  /// Enable quick counter in notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notification Counter'**
  String get enableQuickCounter;

  /// Description for quick counter feature
  ///
  /// In en, this message translates to:
  /// **'Show a persistent notification with counter buttons'**
  String get quickCounterDescription;

  /// Today's dhikr progress section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// Overall statistics section title
  ///
  /// In en, this message translates to:
  /// **'Overall Statistics'**
  String get overallStatistics;

  /// Dhikr breakdown section title
  ///
  /// In en, this message translates to:
  /// **'Dhikr Breakdown'**
  String get dhikrBreakdown;

  /// Recent sessions section title
  ///
  /// In en, this message translates to:
  /// **'Recent Sessions'**
  String get recentSessions;

  /// Sessions label
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Completed sessions label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Total count label
  ///
  /// In en, this message translates to:
  /// **'Total Count'**
  String get totalCount;

  /// Total time spent label
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// Average session duration
  ///
  /// In en, this message translates to:
  /// **'Average Session'**
  String get averageSession;

  /// Longest consecutive days streak
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// Current consecutive days streak
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// Day with most dhikr activity
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// Export data button
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Share statistics button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Daily filter option
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly filter option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly filter option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Yearly filter option
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// Message when no statistics data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Encouragement message for new users
  ///
  /// In en, this message translates to:
  /// **'Start practicing dhikr to see your statistics here'**
  String get startPracticingMessage;

  /// Days unit label
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Hours unit label
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// Minutes unit label
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Last 7 days filter
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// Last 30 days filter
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// Consistency score metric
  ///
  /// In en, this message translates to:
  /// **'Consistency Score'**
  String get consistencyScore;

  /// Average sessions per day
  ///
  /// In en, this message translates to:
  /// **'Average per Day'**
  String get averagePerDay;

  /// Hour of day with most activity
  ///
  /// In en, this message translates to:
  /// **'Most Active Hour'**
  String get mostActiveHour;

  /// Most used dhikr category
  ///
  /// In en, this message translates to:
  /// **'Favorite Category'**
  String get favoriteCategory;

  /// Progress trend over time
  ///
  /// In en, this message translates to:
  /// **'Progress Trend'**
  String get progressTrend;

  /// Improving trend
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get improving;

  /// Declining trend
  ///
  /// In en, this message translates to:
  /// **'Declining'**
  String get declining;

  /// Stable trend
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SkyPop Weather'**
  String get appTitle;

  /// No description provided for @loadingForecast.
  ///
  /// In en, this message translates to:
  /// **'Mixing the forecast colors...'**
  String get loadingForecast;

  /// No description provided for @loadingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding your current sky...'**
  String get loadingLocation;

  /// No description provided for @errorForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Forecast hiccup'**
  String get errorForecastTitle;

  /// No description provided for @errorLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location needed'**
  String get errorLocationTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @nextHours.
  ///
  /// In en, this message translates to:
  /// **'Next hours'**
  String get nextHours;

  /// No description provided for @todayDetails.
  ///
  /// In en, this message translates to:
  /// **'Today details'**
  String get todayDetails;

  /// No description provided for @sevenDayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-day candy forecast'**
  String get sevenDayForecast;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}° · H {high}°  L {low}°'**
  String feelsLike(Object temp, Object high, Object low);

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'{value}% humidity'**
  String humidity(Object value);

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidityLabel;

  /// No description provided for @breeze.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h breeze'**
  String breeze(Object value);

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'{value}% rain'**
  String rain(Object value);

  /// No description provided for @savedCities.
  ///
  /// In en, this message translates to:
  /// **'Saved cities'**
  String get savedCities;

  /// No description provided for @savedCitiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save the cities you love and bounce between forecasts in one tap.'**
  String get savedCitiesEmpty;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @windValue.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String windValue(Object value);

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @pressureValue.
  ///
  /// In en, this message translates to:
  /// **'{value} hPa'**
  String pressureValue(Object value);

  /// No description provided for @clouds.
  ///
  /// In en, this message translates to:
  /// **'Clouds'**
  String get clouds;

  /// No description provided for @cloudsValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String cloudsValue(Object value);

  /// No description provided for @precip.
  ///
  /// In en, this message translates to:
  /// **'Precip'**
  String get precip;

  /// No description provided for @precipValue.
  ///
  /// In en, this message translates to:
  /// **'{value} mm'**
  String precipValue(Object value);

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @directionValue.
  ///
  /// In en, this message translates to:
  /// **'{value}°'**
  String directionValue(Object value);

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search a city'**
  String get searchCity;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Tokyo, Paris, Cape Town...'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start typing to explore colorful skies around the world.'**
  String get searchEmpty;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No city matches yet. Try another spelling.'**
  String get searchNoResults;

  /// No description provided for @sunnyGlow.
  ///
  /// In en, this message translates to:
  /// **'Sunny glow'**
  String get sunnyGlow;

  /// No description provided for @clearNight.
  ///
  /// In en, this message translates to:
  /// **'Clear night'**
  String get clearNight;

  /// No description provided for @playfulClouds.
  ///
  /// In en, this message translates to:
  /// **'Playful clouds'**
  String get playfulClouds;

  /// No description provided for @cottonSky.
  ///
  /// In en, this message translates to:
  /// **'Cotton sky'**
  String get cottonSky;

  /// No description provided for @mistyMood.
  ///
  /// In en, this message translates to:
  /// **'Misty mood'**
  String get mistyMood;

  /// No description provided for @snowConfetti.
  ///
  /// In en, this message translates to:
  /// **'Snow confetti'**
  String get snowConfetti;

  /// No description provided for @thunderParty.
  ///
  /// In en, this message translates to:
  /// **'Thunder party'**
  String get thunderParty;

  /// No description provided for @rainConfetti.
  ///
  /// In en, this message translates to:
  /// **'Rain confetti'**
  String get rainConfetti;

  /// No description provided for @clearSky.
  ///
  /// In en, this message translates to:
  /// **'Clear sky'**
  String get clearSky;

  /// No description provided for @mostlyClear.
  ///
  /// In en, this message translates to:
  /// **'Mostly clear'**
  String get mostlyClear;

  /// No description provided for @partlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get partlyCloudy;

  /// No description provided for @overcast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get overcast;

  /// No description provided for @foggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get foggy;

  /// No description provided for @drizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get drizzle;

  /// No description provided for @freezingDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Freezing drizzle'**
  String get freezingDrizzle;

  /// No description provided for @rainWeather.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rainWeather;

  /// No description provided for @freezingRain.
  ///
  /// In en, this message translates to:
  /// **'Freezing rain'**
  String get freezingRain;

  /// No description provided for @snow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get snow;

  /// No description provided for @snowGrains.
  ///
  /// In en, this message translates to:
  /// **'Snow grains'**
  String get snowGrains;

  /// No description provided for @rainShowers.
  ///
  /// In en, this message translates to:
  /// **'Rain showers'**
  String get rainShowers;

  /// No description provided for @snowShowers.
  ///
  /// In en, this message translates to:
  /// **'Snow showers'**
  String get snowShowers;

  /// No description provided for @thunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get thunderstorm;

  /// No description provided for @weatherShift.
  ///
  /// In en, this message translates to:
  /// **'Weather shift'**
  String get weatherShift;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

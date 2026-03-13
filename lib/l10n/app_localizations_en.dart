// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SkyPop Weather';

  @override
  String get loadingForecast => 'Mixing the forecast colors...';

  @override
  String get loadingLocation => 'Finding your current sky...';

  @override
  String get errorForecastTitle => 'Forecast hiccup';

  @override
  String get errorLocationTitle => 'Location needed';

  @override
  String get tryAgain => 'Try again';

  @override
  String get nextHours => 'Next hours';

  @override
  String get todayDetails => 'Today details';

  @override
  String get sevenDayForecast => '7-day candy forecast';

  @override
  String feelsLike(Object temp, Object high, Object low) {
    return 'Feels like $temp° · H $high°  L $low°';
  }

  @override
  String get saved => 'Saved';

  @override
  String get save => 'Save';

  @override
  String humidity(Object value) {
    return '$value% humidity';
  }

  @override
  String get humidityLabel => 'Humidity';

  @override
  String breeze(Object value) {
    return '$value km/h breeze';
  }

  @override
  String rain(Object value) {
    return '$value% rain';
  }

  @override
  String get savedCities => 'Saved cities';

  @override
  String get savedCitiesEmpty =>
      'Save the cities you love and bounce between forecasts in one tap.';

  @override
  String get wind => 'Wind';

  @override
  String windValue(Object value) {
    return '$value km/h';
  }

  @override
  String get pressure => 'Pressure';

  @override
  String pressureValue(Object value) {
    return '$value hPa';
  }

  @override
  String get clouds => 'Clouds';

  @override
  String cloudsValue(Object value) {
    return '$value%';
  }

  @override
  String get precip => 'Precip';

  @override
  String precipValue(Object value) {
    return '$value mm';
  }

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get direction => 'Direction';

  @override
  String directionValue(Object value) {
    return '$value°';
  }

  @override
  String get searchCity => 'Search a city';

  @override
  String get searchHint => 'Tokyo, Paris, Cape Town...';

  @override
  String get searchEmpty =>
      'Start typing to explore colorful skies around the world.';

  @override
  String get searchNoResults => 'No city matches yet. Try another spelling.';

  @override
  String get sunnyGlow => 'Sunny glow';

  @override
  String get clearNight => 'Clear night';

  @override
  String get playfulClouds => 'Playful clouds';

  @override
  String get cottonSky => 'Cotton sky';

  @override
  String get mistyMood => 'Misty mood';

  @override
  String get snowConfetti => 'Snow confetti';

  @override
  String get thunderParty => 'Thunder party';

  @override
  String get rainConfetti => 'Rain confetti';

  @override
  String get clearSky => 'Clear sky';

  @override
  String get mostlyClear => 'Mostly clear';

  @override
  String get partlyCloudy => 'Partly cloudy';

  @override
  String get overcast => 'Overcast';

  @override
  String get foggy => 'Foggy';

  @override
  String get drizzle => 'Drizzle';

  @override
  String get freezingDrizzle => 'Freezing drizzle';

  @override
  String get rainWeather => 'Rain';

  @override
  String get freezingRain => 'Freezing rain';

  @override
  String get snow => 'Snow';

  @override
  String get snowGrains => 'Snow grains';

  @override
  String get rainShowers => 'Rain showers';

  @override
  String get snowShowers => 'Snow showers';

  @override
  String get thunderstorm => 'Thunderstorm';

  @override
  String get weatherShift => 'Weather shift';
}

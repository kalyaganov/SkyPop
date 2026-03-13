// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SkyPop Погода';

  @override
  String get loadingForecast => 'Смешиваем краски прогноза...';

  @override
  String get loadingLocation => 'Ищем ваше небо...';

  @override
  String get errorForecastTitle => 'Ошибка прогноза';

  @override
  String get errorLocationTitle => 'Нужна геолокация';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get nextHours => 'Следующие часы';

  @override
  String get todayDetails => 'Подробности сегодня';

  @override
  String get sevenDayForecast => '7-дневный прогноз';

  @override
  String feelsLike(Object temp, Object high, Object low) {
    return 'Ощущается как $temp° · Макс $high°  Мин $low°';
  }

  @override
  String get saved => 'Сохранено';

  @override
  String get save => 'Сохранить';

  @override
  String humidity(Object value) {
    return 'Влажность $value%';
  }

  @override
  String get humidityLabel => 'Влажность';

  @override
  String breeze(Object value) {
    return 'Ветер $value км/ч';
  }

  @override
  String rain(Object value) {
    return 'Дождь $value%';
  }

  @override
  String get savedCities => 'Сохранённые города';

  @override
  String get savedCitiesEmpty =>
      'Сохраняйте любимые города и переключайтесь между прогнозами одним нажатием.';

  @override
  String get wind => 'Ветер';

  @override
  String windValue(Object value) {
    return '$value км/ч';
  }

  @override
  String get pressure => 'Давление';

  @override
  String pressureValue(Object value) {
    return '$value гПа';
  }

  @override
  String get clouds => 'Облачность';

  @override
  String cloudsValue(Object value) {
    return '$value%';
  }

  @override
  String get precip => 'Осадки';

  @override
  String precipValue(Object value) {
    return '$value мм';
  }

  @override
  String get sunrise => 'Восход';

  @override
  String get sunset => 'Закат';

  @override
  String get direction => 'Направление';

  @override
  String directionValue(Object value) {
    return '$value°';
  }

  @override
  String get searchCity => 'Поиск города';

  @override
  String get searchHint => 'Москва, Париж, Токио...';

  @override
  String get searchEmpty =>
      'Начните вводить, чтобы найти погоду в любой точке мира.';

  @override
  String get searchNoResults => 'Город не найден. Попробуйте другой запрос.';

  @override
  String get sunnyGlow => 'Солнечное сияние';

  @override
  String get clearNight => 'Ясная ночь';

  @override
  String get playfulClouds => 'Игривые облака';

  @override
  String get cottonSky => 'Хлопковое небо';

  @override
  String get mistyMood => 'Туманное настроение';

  @override
  String get snowConfetti => 'Снежное конфетти';

  @override
  String get thunderParty => 'Грозовая вечеринка';

  @override
  String get rainConfetti => 'Дождевое конфетти';

  @override
  String get clearSky => 'Ясное небо';

  @override
  String get mostlyClear => 'Преимущественно ясно';

  @override
  String get partlyCloudy => 'Переменная облачность';

  @override
  String get overcast => 'Пасмурно';

  @override
  String get foggy => 'Туман';

  @override
  String get drizzle => 'Морось';

  @override
  String get freezingDrizzle => 'Ледяная морось';

  @override
  String get rainWeather => 'Дождь';

  @override
  String get freezingRain => 'Ледяной дождь';

  @override
  String get snow => 'Снег';

  @override
  String get snowGrains => 'Снежная крупа';

  @override
  String get rainShowers => 'Ливень';

  @override
  String get snowShowers => 'Снегопад';

  @override
  String get thunderstorm => 'Гроза';

  @override
  String get weatherShift => 'Переменчивая погода';
}

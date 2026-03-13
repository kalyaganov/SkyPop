import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import 'package:weather_app/core/models/app_location.dart';
import 'package:weather_app/core/models/weather_models.dart';
import 'package:weather_app/features/weather/presentation/weather_home_screen.dart';

void main() {
  testWidgets('renders forecast content on the main view', (tester) async {
    const location = AppLocation(
      name: 'Lisbon',
      latitude: 38.72,
      longitude: -9.14,
      country: 'Portugal',
      admin1: 'Lisbon',
    );

    final weather = WeatherBundle(
      current: CurrentWeather(
        temperature: 26,
        apparentTemperature: 28,
        humidity: 55,
        windSpeed: 18,
        windDirection: 180,
        pressure: 1012,
        surfacePressure: 1008,
        cloudCover: 24,
        precipitation: 0,
        isDay: true,
        weatherCode: 1,
        time: DateTime(2026, 3, 13, 12),
      ),
      hourly: List.generate(
        12,
        (index) => HourlyForecast(
          time: DateTime(2026, 3, 13, index + 8),
          temperature: 20 + index / 2,
          weatherCode: 1,
          precipitationProbability: index * 4,
        ),
      ),
      daily: List.generate(
        7,
        (index) => DailyForecast(
          date: DateTime(2026, 3, 13 + index),
          weatherCode: index.isEven ? 1 : 61,
          maxTemperature: (28 + index).toDouble(),
          minTemperature: (16 + index).toDouble(),
          sunrise: DateTime(2026, 3, 13 + index, 6, 40),
          sunset: DateTime(2026, 3, 13 + index, 18, 35),
          precipitationProbability: 10 + index * 5,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: WeatherHomeView(
          location: location,
          savedLocations: const [location],
          weather: weather,
          onRefreshLocation: () async {},
          onToggleFavorite: () async {},
          onSelectSaved: (_) async {},
          onOpenSearch: () {},
          onToggleLocale: () {},
        ),
      ),
    );

    expect(find.text('SkyPop Weather'), findsOneWidget);
    expect(find.text('7-day candy forecast'), findsOneWidget);
    expect(find.textContaining('Feels like'), findsOneWidget);
  });
}

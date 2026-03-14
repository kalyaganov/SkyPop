import 'package:flutter/material.dart';

enum WeatherMood { sunny, partlyCloudy, cloudy, rainy, stormy, snowy, foggy }

class WeatherBundle {
  const WeatherBundle({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  factory WeatherBundle.fromApi(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final hourlyJson = json['hourly'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    final hourlyTimes = List<String>.from(hourlyJson['time'] as List<dynamic>);
    final hourlyTemps = List<num>.from(
      hourlyJson['temperature_2m'] as List<dynamic>,
    );
    final hourlyCodes = List<num>.from(
      hourlyJson['weather_code'] as List<dynamic>,
    );
    final hourlyPrecip = List<num>.from(
      hourlyJson['precipitation_probability'] as List<dynamic>,
    );

    final dailyTimes = List<String>.from(dailyJson['time'] as List<dynamic>);
    final dailyCodes = List<num>.from(
      dailyJson['weather_code'] as List<dynamic>,
    );
    final dailyMax = List<num>.from(
      dailyJson['temperature_2m_max'] as List<dynamic>,
    );
    final dailyMin = List<num>.from(
      dailyJson['temperature_2m_min'] as List<dynamic>,
    );
    final sunrise = List<String>.from(dailyJson['sunrise'] as List<dynamic>);
    final sunset = List<String>.from(dailyJson['sunset'] as List<dynamic>);
    final precipitationMax = List<num>.from(
      dailyJson['precipitation_probability_max'] as List<dynamic>,
    );

    return WeatherBundle(
      current: CurrentWeather(
        temperature: (currentJson['temperature_2m'] as num).toDouble(),
        apparentTemperature: (currentJson['apparent_temperature'] as num)
            .toDouble(),
        humidity: (currentJson['relative_humidity_2m'] as num).toInt(),
        windSpeed: (currentJson['wind_speed_10m'] as num).toDouble(),
        windDirection: (currentJson['wind_direction_10m'] as num).toInt(),
        pressure: (currentJson['pressure_msl'] as num).toDouble(),
        surfacePressure: (currentJson['surface_pressure'] as num).toDouble(),
        cloudCover: (currentJson['cloud_cover'] as num).toInt(),
        precipitation: (currentJson['precipitation'] as num).toDouble(),
        isDay: (currentJson['is_day'] as num).toInt() == 1,
        weatherCode: (currentJson['weather_code'] as num).toInt(),
        time: DateTime.parse(currentJson['time'] as String),
      ),
      hourly: () {
        final now = DateTime.parse(currentJson['time'] as String);
        final forecasts = <HourlyForecast>[];
        for (var i = 0; i < hourlyTimes.length; i++) {
          final time = DateTime.parse(hourlyTimes[i]);
          if (time.isAfter(now)) {
            forecasts.add(
              HourlyForecast(
                time: time,
                temperature: hourlyTemps[i].toDouble(),
                weatherCode: hourlyCodes[i].toInt(),
                precipitationProbability: hourlyPrecip[i].toInt(),
              ),
            );
          }
        }
        return forecasts;
      }(),
      daily: List.generate(dailyTimes.length, (index) {
        return DailyForecast(
          date: DateTime.parse(dailyTimes[index]),
          weatherCode: dailyCodes[index].toInt(),
          maxTemperature: dailyMax[index].toDouble(),
          minTemperature: dailyMin[index].toDouble(),
          sunrise: DateTime.parse(sunrise[index]),
          sunset: DateTime.parse(sunset[index]),
          precipitationProbability: precipitationMax[index].toInt(),
        );
      }),
    );
  }
}

class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.surfacePressure,
    required this.cloudCover,
    required this.precipitation,
    required this.isDay,
    required this.weatherCode,
    required this.time,
  });

  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final double pressure;
  final double surfacePressure;
  final int cloudCover;
  final double precipitation;
  final bool isDay;
  final int weatherCode;
  final DateTime time;
}

class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.precipitationProbability,
  });

  final DateTime time;
  final double temperature;
  final int weatherCode;
  final int precipitationProbability;
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.sunrise,
    required this.sunset,
    required this.precipitationProbability,
  });

  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final DateTime sunrise;
  final DateTime sunset;
  final int precipitationProbability;
}

class WeatherVisuals {
  const WeatherVisuals({
    required this.mood,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.accent,
  });

  final WeatherMood mood;
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final Color accent;
}

WeatherVisuals weatherVisualsForCode(int code, bool isDay) {
  switch (code) {
    case 0:
      return WeatherVisuals(
        mood: WeatherMood.sunny,
        label: isDay ? 'Sunny glow' : 'Clear night',
        icon: isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
        gradient: isDay
            ? const [Color(0xFFFFC857), Color(0xFFFF7B54), Color(0xFF6C63FF)]
            : const [Color(0xFF1F2558), Color(0xFF4C3F91), Color(0xFF72DDF7)],
        accent: const Color(0xFFFFF0A8),
      );
    case 1:
    case 2:
      return WeatherVisuals(
        mood: WeatherMood.partlyCloudy,
        label: 'Playful clouds',
        icon: Icons.cloud_queue_rounded,
        gradient: const [
          Color(0xFF6C63FF),
          Color(0xFF72DDF7),
          Color(0xFFFFD166),
        ],
        accent: const Color(0xFFFFFFFF),
      );
    case 3:
      return WeatherVisuals(
        mood: WeatherMood.cloudy,
        label: 'Cotton sky',
        icon: Icons.cloud_rounded,
        gradient: const [
          Color(0xFF5E60CE),
          Color(0xFF64DFDF),
          Color(0xFFCDE7FF),
        ],
        accent: const Color(0xFFEAF4FF),
      );
    case 45:
    case 48:
      return WeatherVisuals(
        mood: WeatherMood.foggy,
        label: 'Misty mood',
        icon: Icons.blur_on_rounded,
        gradient: const [
          Color(0xFF7B9ACC),
          Color(0xFFB8C0FF),
          Color(0xFFEAE2FF),
        ],
        accent: const Color(0xFFF8F7FF),
      );
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return WeatherVisuals(
        mood: WeatherMood.snowy,
        label: 'Snow confetti',
        icon: Icons.ac_unit_rounded,
        gradient: const [
          Color(0xFF8EC5FC),
          Color(0xFFE0C3FC),
          Color(0xFFF8F9FF),
        ],
        accent: const Color(0xFFFFFFFF),
      );
    case 95:
    case 96:
    case 99:
      return WeatherVisuals(
        mood: WeatherMood.stormy,
        label: 'Thunder party',
        icon: Icons.thunderstorm_rounded,
        gradient: const [
          Color(0xFF2D3250),
          Color(0xFF424769),
          Color(0xFFF6B17A),
        ],
        accent: const Color(0xFFFFD56F),
      );
    default:
      return WeatherVisuals(
        mood: WeatherMood.rainy,
        label: 'Rain confetti',
        icon: Icons.grain_rounded,
        gradient: const [
          Color(0xFF3A86FF),
          Color(0xFF4CC9F0),
          Color(0xFFA0E7E5),
        ],
        accent: const Color(0xFFD9F4FF),
      );
  }
}

String weatherDescription(int code) {
  switch (code) {
    case 0:
      return 'Clear sky';
    case 1:
      return 'Mostly clear';
    case 2:
      return 'Partly cloudy';
    case 3:
      return 'Overcast';
    case 45:
    case 48:
      return 'Foggy';
    case 51:
    case 53:
    case 55:
      return 'Drizzle';
    case 56:
    case 57:
      return 'Freezing drizzle';
    case 61:
    case 63:
    case 65:
      return 'Rain';
    case 66:
    case 67:
      return 'Freezing rain';
    case 71:
    case 73:
    case 75:
      return 'Snow';
    case 77:
      return 'Snow grains';
    case 80:
    case 81:
    case 82:
      return 'Rain showers';
    case 85:
    case 86:
      return 'Snow showers';
    case 95:
    case 96:
    case 99:
      return 'Thunderstorm';
    default:
      return 'Weather shift';
  }
}

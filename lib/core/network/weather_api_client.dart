import 'package:dio/dio.dart';

import '../models/app_location.dart';
import '../models/weather_models.dart';

class WeatherApiClient {
  WeatherApiClient(this._dio);

  final Dio _dio;

  Future<WeatherBundle> fetchWeather(AppLocation location) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m',
        'hourly': 'temperature_2m,weather_code,precipitation_probability',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max',
        'forecast_days': 7,
        'timezone': 'auto',
      },
    );

    final data = response.data;
    if (data == null) {
      throw const WeatherApiException('No weather data returned.');
    }
    return WeatherBundle.fromApi(data);
  }

  Future<List<AppLocation>> searchCities(String query) async {
    if (query.trim().isEmpty) {
      return const [];
    }

    final response = await _dio.get<Map<String, dynamic>>(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: {
        'name': query.trim(),
        'count': 12,
        'language': 'en',
        'format': 'json',
      },
    );

    final results = response.data?['results'] as List<dynamic>?;
    if (results == null) {
      return const [];
    }

    return results
        .map((json) => AppLocation.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class WeatherApiException implements Exception {
  const WeatherApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

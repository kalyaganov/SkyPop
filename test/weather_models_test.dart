import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/models/app_location.dart';
import 'package:weather_app/core/models/weather_models.dart';

void main() {
  test('AppLocation encode/decode round-trips', () {
    const location = AppLocation(
      name: 'Seoul',
      latitude: 37.5665,
      longitude: 126.978,
      country: 'South Korea',
      admin1: 'Seoul',
      timezone: 'Asia/Seoul',
    );

    final decoded = AppLocation.decode(location.encode());

    expect(decoded, location);
    expect(decoded.admin1, 'Seoul');
  });

  test('WeatherBundle parses Open-Meteo style payload', () {
    final bundle = WeatherBundle.fromApi({
      'current': {
        'temperature_2m': 25.4,
        'relative_humidity_2m': 62,
        'apparent_temperature': 27.1,
        'is_day': 1,
        'precipitation': 0.0,
        'weather_code': 2,
        'cloud_cover': 20,
        'pressure_msl': 1010.7,
        'surface_pressure': 1005.5,
        'wind_speed_10m': 14.2,
        'wind_direction_10m': 205,
        'time': '2026-03-13T12:00',
      },
      'hourly': {
        'time': ['2026-03-13T12:00', '2026-03-13T13:00'],
        'temperature_2m': [25.4, 26.0],
        'weather_code': [2, 3],
        'precipitation_probability': [10, 20],
      },
      'daily': {
        'time': ['2026-03-13', '2026-03-14'],
        'weather_code': [2, 61],
        'temperature_2m_max': [28.0, 24.0],
        'temperature_2m_min': [17.0, 16.0],
        'sunrise': ['2026-03-13T06:25', '2026-03-14T06:24'],
        'sunset': ['2026-03-13T18:19', '2026-03-14T18:20'],
        'precipitation_probability_max': [15, 70],
      },
    });

    expect(bundle.current.temperature, 25.4);
    expect(bundle.hourly.length, 1);
    expect(bundle.hourly.first.time.hour, 13);
    expect(bundle.daily.first.maxTemperature, 28.0);
    expect(weatherDescription(bundle.daily.last.weatherCode), 'Rain');
  });
}

import '../../../core/models/app_location.dart';
import '../../../core/models/weather_models.dart';
import '../../../core/network/weather_api_client.dart';

class WeatherRepository {
  const WeatherRepository(this._client);

  final WeatherApiClient _client;

  Future<WeatherBundle> fetchWeather(AppLocation location) {
    return _client.fetchWeather(location);
  }

  Future<List<AppLocation>> searchCities(String query) {
    return _client.searchCities(query);
  }
}

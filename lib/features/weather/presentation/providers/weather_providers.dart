import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_location.dart';
import '../../../../core/models/weather_models.dart';
import '../../../../core/network/weather_api_client.dart';
import '../../../location/location_controller.dart';
import '../../data/weather_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
    ),
  );
});

final weatherApiClientProvider = Provider<WeatherApiClient>((ref) {
  return WeatherApiClient(ref.watch(dioProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(ref.watch(weatherApiClientProvider));
});

final selectedLocationProvider =
    AsyncNotifierProvider<SelectedLocationController, AppLocation>(
      SelectedLocationController.new,
    );

final savedLocationsProvider =
    AsyncNotifierProvider<SavedLocationsController, List<AppLocation>>(
      SavedLocationsController.new,
    );

final weatherProvider = FutureProvider<WeatherBundle>((ref) async {
  final location = await ref.watch(selectedLocationProvider.future);
  return ref.watch(weatherRepositoryProvider).fetchWeather(location);
});

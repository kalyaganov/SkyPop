import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/app_location.dart';

const _savedLocationsKey = 'saved_locations';
const _selectedLocationKey = 'selected_location';

const _fallbackLocation = AppLocation(
  name: 'Barcelona',
  latitude: 41.3874,
  longitude: 2.1686,
  country: 'Spain',
  admin1: 'Catalonia',
  timezone: 'Europe/Madrid',
);

class SelectedLocationController extends AsyncNotifier<AppLocation> {
  @override
  Future<AppLocation> build() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_selectedLocationKey);
    if (encoded != null) {
      return AppLocation.decode(encoded);
    }
    try {
      final current = await _determineCurrentLocation();
      await _persistSelection(current);
      return current;
    } on LocationException {
      await _persistSelection(_fallbackLocation);
      return _fallbackLocation;
    }
  }

  Future<void> selectLocation(AppLocation location) async {
    state = AsyncData(location);
    await _persistSelection(location);
  }

  Future<void> useCurrentLocation() async {
    final previous = state.valueOrNull;
    state = const AsyncLoading();
    try {
      final current = await _determineCurrentLocation();
      await _persistSelection(current);
      state = AsyncData(current);
    } on LocationException {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = const AsyncData(_fallbackLocation);
      }
    }
  }

  Future<void> _persistSelection(AppLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLocationKey, location.encode());
  }

  Future<AppLocation> _determineCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Turn on location services to use your current city.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is needed for current-city weather.',
      );
    }

    final position = await Geolocator.getCurrentPosition();
    return AppLocation(
      name: 'My Location',
      latitude: position.latitude,
      longitude: position.longitude,
      country: 'Current Position',
    );
  }
}

class SavedLocationsController extends AsyncNotifier<List<AppLocation>> {
  @override
  Future<List<AppLocation>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_savedLocationsKey) ?? const [];
    return values.map(AppLocation.decode).toList();
  }

  Future<void> toggleLocation(AppLocation location) async {
    final current = [...(state.valueOrNull ?? const <AppLocation>[])];
    final exists = current.contains(location);
    if (exists) {
      current.remove(location);
    } else {
      current.add(location);
    }
    state = AsyncData(current);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _savedLocationsKey,
      current.map((location) => location.encode()).toList(),
    );
  }
}

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

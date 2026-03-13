import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/locale_provider.dart';
import '../../../core/models/app_location.dart';
import '../../../core/models/weather_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../search/presentation/city_search_sheet.dart';
import 'providers/weather_providers.dart';

class WeatherHomeScreen extends ConsumerWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final savedLocations =
        ref.watch(savedLocationsProvider).valueOrNull ?? const <AppLocation>[];
    final l10n = AppLocalizations.of(context)!;

    return selectedLocation.when(
      data: (location) {
        final weatherAsync = ref.watch(weatherProvider);
        return weatherAsync.when(
          data: (weather) => WeatherHomeView(
            location: location,
            savedLocations: savedLocations,
            weather: weather,
            onRefreshLocation: () async {
              await ref
                  .read(selectedLocationProvider.notifier)
                  .useCurrentLocation();
              ref.invalidate(weatherProvider);
            },
            onToggleFavorite: () async {
              await ref
                  .read(savedLocationsProvider.notifier)
                  .toggleLocation(location);
            },
            onSelectSaved: (saved) async {
              await ref
                  .read(selectedLocationProvider.notifier)
                  .selectLocation(saved);
              ref.invalidate(weatherProvider);
            },
            onOpenSearch: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FractionallySizedBox(
                  heightFactor: 0.88,
                  child: CitySearchSheet(),
                ),
              );
            },
            onToggleLocale: () =>
                ref.read(localeProvider.notifier).toggleLocale(),
          ),
          loading: () => _LoadingScaffold(message: l10n.loadingForecast),
          error: (error, _) => _ErrorScaffold(
            title: l10n.errorForecastTitle,
            message: error.toString(),
            onRetry: () => ref.invalidate(weatherProvider),
          ),
        );
      },
      loading: () => _LoadingScaffold(
        message: AppLocalizations.of(context)!.loadingLocation,
      ),
      error: (error, _) => _ErrorScaffold(
        title: AppLocalizations.of(context)!.errorLocationTitle,
        message: error.toString(),
        onRetry: () => ref.invalidate(selectedLocationProvider),
      ),
    );
  }
}

class WeatherHomeView extends StatelessWidget {
  const WeatherHomeView({
    super.key,
    required this.location,
    required this.savedLocations,
    required this.weather,
    required this.onRefreshLocation,
    required this.onToggleFavorite,
    required this.onSelectSaved,
    required this.onOpenSearch,
    required this.onToggleLocale,
  });

  final AppLocation location;
  final List<AppLocation> savedLocations;
  final WeatherBundle weather;
  final Future<void> Function() onRefreshLocation;
  final Future<void> Function() onToggleFavorite;
  final Future<void> Function(AppLocation location) onSelectSaved;
  final VoidCallback onOpenSearch;
  final VoidCallback onToggleLocale;

  @override
  Widget build(BuildContext context) {
    final visuals = weatherVisualsForCode(
      weather.current.weatherCode,
      weather.current.isDay,
    );
    final isSaved = savedLocations.contains(location);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: visuals.gradient,
                ),
              ),
            ),
          ),
          const Positioned.fill(child: _FloatingBlobs()),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 720;
              final topPadding = MediaQuery.paddingOf(context).top;
              final bottomPadding = MediaQuery.paddingOf(context).bottom;

              return RefreshIndicator(
                onRefresh: onRefreshLocation,
                color: visuals.accent,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 32 + bottomPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12 + topPadding),
                        _TopBar(
                          location: location,
                          onOpenSearch: onOpenSearch,
                          onRefreshLocation: onRefreshLocation,
                          onToggleLocale: onToggleLocale,
                        ),
                        const SizedBox(height: 20),
                        _HeroCard(
                          location: location,
                          weather: weather,
                          visuals: visuals,
                          isSaved: isSaved,
                          onToggleFavorite: onToggleFavorite,
                        ),
                        const SizedBox(height: 20),
                        _SavedLocationsRow(
                          locations: savedLocations,
                          selected: location,
                          onSelectSaved: onSelectSaved,
                        ),
                        const SizedBox(height: 20),
                        wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _SectionCard(
                                      title: l10n.nextHours,
                                      child: _HourlyForecastList(
                                        hourly: weather.hourly
                                            .take(12)
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: _SectionCard(
                                      title: l10n.todayDetails,
                                      child: _DetailsGrid(weather: weather),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _SectionCard(
                                    title: l10n.nextHours,
                                    child: _HourlyForecastList(
                                      hourly: weather.hourly.take(12).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _SectionCard(
                                    title: l10n.todayDetails,
                                    child: _DetailsGrid(weather: weather),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),
                        _SectionCard(
                          title: l10n.sevenDayForecast,
                          child: _DailyForecastList(days: weather.daily),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.location,
    required this.onOpenSearch,
    required this.onRefreshLocation,
    required this.onToggleLocale,
  });

  final AppLocation location;
  final VoidCallback onOpenSearch;
  final Future<void> Function() onRefreshLocation;
  final VoidCallback onToggleLocale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                location.shortLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        _ActionBubble(icon: Icons.search_rounded, onTap: onOpenSearch),
        const SizedBox(width: 10),
        _ActionBubble(
          icon: Icons.my_location_rounded,
          onTap: () => onRefreshLocation(),
        ),
        const SizedBox(width: 10),
        _ActionBubble(icon: Icons.translate_rounded, onTap: onToggleLocale),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.location,
    required this.weather,
    required this.visuals,
    required this.isSaved,
    required this.onToggleFavorite,
  });

  final AppLocation location;
  final WeatherBundle weather;
  final WeatherVisuals visuals;
  final bool isSaved;
  final Future<void> Function() onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final today = weather.daily.first;
    final temp = current.temperature.round();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d').format(current.time),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizedWeatherDescription(current.weatherCode, l10n),
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$temp°',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 92,
                        height: 0.95,
                      ),
                    ),
                    Text(
                      l10n.feelsLike(
                        current.apparentTemperature.round(),
                        today.maxTemperature.round(),
                        today.minTemperature.round(),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(visuals.icon, size: 54, color: visuals.accent),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: onToggleFavorite,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSaved
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isSaved ? l10n.saved : l10n.save,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(
                label: localizedWeatherLabel(visuals.mood, l10n),
                icon: visuals.icon,
              ),
              _InfoPill(
                label: l10n.humidity(current.humidity),
                icon: Icons.water_drop_rounded,
              ),
              _InfoPill(
                label: l10n.breeze(current.windSpeed.round()),
                icon: Icons.air_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavedLocationsRow extends StatelessWidget {
  const _SavedLocationsRow({
    required this.locations,
    required this.selected,
    required this.onSelectSaved,
  });

  final List<AppLocation> locations;
  final AppLocation selected;
  final Future<void> Function(AppLocation location) onSelectSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (locations.isEmpty) {
      return _SectionCard(
        title: l10n.savedCities,
        child: Text(
          l10n.savedCitiesEmpty,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return _SectionCard(
      title: l10n.savedCities,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final location in locations)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  selected: selected == location,
                  label: Text(location.name),
                  avatar: const Icon(Icons.place_rounded, size: 18),
                  onSelected: (_) => onSelectSaved(location),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HourlyForecastList extends StatelessWidget {
  const _HourlyForecastList({required this.hourly});

  final List<HourlyForecast> hourly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 186,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, itemIndex) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = hourly[index];
          final visuals = weatherVisualsForCode(item.weatherCode, true);
          return Container(
            width: 92,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.74),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.Hm().format(item.time),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(visuals.icon, color: visuals.gradient.first),
                Text(
                  '${item.temperature.round()}°',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                Text(
                  l10n.rain(item.precipitationProbability),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DailyForecastList extends StatelessWidget {
  const _DailyForecastList({required this.days});

  final List<DailyForecast> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        for (final day in days)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      DateFormat.E().format(day.date),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    weatherVisualsForCode(day.weatherCode, true).icon,
                    color: weatherVisualsForCode(
                      day.weatherCode,
                      true,
                    ).gradient.first,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizedWeatherDescription(day.weatherCode, l10n),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${day.precipitationProbability}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${day.maxTemperature.round()}° / ${day.minTemperature.round()}°',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.weather});

  final WeatherBundle weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final today = weather.daily.first;
    final l10n = AppLocalizations.of(context)!;

    final items = [
      (l10n.humidityLabel, '${current.humidity}%'),
      (l10n.wind, l10n.windValue(current.windSpeed.round())),
      (l10n.pressure, l10n.pressureValue(current.pressure.round())),
      (l10n.clouds, l10n.cloudsValue(current.cloudCover)),
      (l10n.precip, l10n.precipValue(current.precipitation.toStringAsFixed(1))),
      (l10n.sunrise, DateFormat.Hm().format(today.sunrise)),
      (l10n.sunset, DateFormat.Hm().format(today.sunset)),
      (l10n.direction, l10n.directionValue(current.windDirection)),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          SizedBox(
            width: 150,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$1, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(item.$2, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  const _ActionBubble({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _FloatingBlobs extends StatelessWidget {
  const _FloatingBlobs();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -30,
            left: -20,
            child: _Blob(size: 180, color: const Color(0x66FFFFFF)),
          ),
          Positioned(
            top: 160,
            right: -40,
            child: _Blob(size: 220, color: const Color(0x55FFD166)),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _Blob(size: 240, color: const Color(0x44FFFFFF)),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF4CC9F0),
                    Color(0xFFFFD166),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 18),
                  Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF4CC9F0),
                    Color(0xFFFFD166),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              bottom: bottomPadding,
              left: 24,
              right: 24,
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: onRetry,
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String localizedWeatherLabel(WeatherMood mood, AppLocalizations l10n) {
  switch (mood) {
    case WeatherMood.sunny:
      return l10n.sunnyGlow;
    case WeatherMood.partlyCloudy:
      return l10n.playfulClouds;
    case WeatherMood.cloudy:
      return l10n.cottonSky;
    case WeatherMood.rainy:
      return l10n.rainConfetti;
    case WeatherMood.stormy:
      return l10n.thunderParty;
    case WeatherMood.snowy:
      return l10n.snowConfetti;
    case WeatherMood.foggy:
      return l10n.mistyMood;
  }
}

String localizedWeatherDescription(int code, AppLocalizations l10n) {
  switch (code) {
    case 0:
      return l10n.clearSky;
    case 1:
      return l10n.mostlyClear;
    case 2:
      return l10n.partlyCloudy;
    case 3:
      return l10n.overcast;
    case 45:
    case 48:
      return l10n.foggy;
    case 51:
    case 53:
    case 55:
      return l10n.drizzle;
    case 56:
    case 57:
      return l10n.freezingDrizzle;
    case 61:
    case 63:
    case 65:
      return l10n.rainWeather;
    case 66:
    case 67:
      return l10n.freezingRain;
    case 71:
    case 73:
    case 75:
      return l10n.snow;
    case 77:
      return l10n.snowGrains;
    case 80:
    case 81:
    case 82:
      return l10n.rainShowers;
    case 85:
    case 86:
      return l10n.snowShowers;
    case 95:
    case 96:
    case 99:
      return l10n.thunderstorm;
    default:
      return l10n.weatherShift;
  }
}

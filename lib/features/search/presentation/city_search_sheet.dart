import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_location.dart';
import '../../../l10n/app_localizations.dart';
import '../../weather/presentation/providers/weather_providers.dart';

class CitySearchSheet extends ConsumerStatefulWidget {
  const CitySearchSheet({super.key});

  @override
  ConsumerState<CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends ConsumerState<CitySearchSheet> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _loading = false;
  List<AppLocation> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      if (value.trim().isEmpty) {
        setState(() {
          _results = const [];
          _loading = false;
        });
        return;
      }

      setState(() {
        _loading = true;
      });

      final results = await ref
          .read(weatherRepositoryProvider)
          .searchCities(value);

      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final saved =
        ref.watch(savedLocationsProvider).valueOrNull ?? const <AppLocation>[];
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 28 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFD5DAF3),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.searchCity,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Flexible(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          _controller.text.isEmpty
                              ? l10n.searchEmpty
                              : l10n.searchNoResults,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _results.length,
                      separatorBuilder: (_, itemIndex) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final result = _results[index];
                        final isSaved = saved.contains(result);
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          child: ListTile(
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              await ref
                                  .read(selectedLocationProvider.notifier)
                                  .selectLocation(result);
                              if (mounted) {
                                navigator.pop();
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FF),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.location_city_rounded),
                            ),
                            title: Text(result.name),
                            subtitle: Text(result.subtitle),
                            trailing: IconButton(
                              onPressed: () {
                                ref
                                    .read(savedLocationsProvider.notifier)
                                    .toggleLocation(result);
                              },
                              icon: Icon(
                                isSaved
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: isSaved ? const Color(0xFFFF7B54) : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

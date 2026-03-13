import 'dart:convert';

class AppLocation {
  const AppLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
    this.timezone,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;
  final String? timezone;

  String get subtitle {
    final region = admin1?.trim();
    if (region == null || region.isEmpty) {
      return country;
    }
    return '$region, $country';
  }

  String get shortLabel => '$name, $country';

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
    'admin1': admin1,
    'timezone': timezone,
  };

  String encode() => jsonEncode(toJson());

  factory AppLocation.decode(String value) {
    return AppLocation.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  factory AppLocation.fromJson(Map<String, dynamic> json) {
    return AppLocation(
      name: json['name'] as String? ?? 'Unknown',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String? ?? 'Unknown',
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppLocation &&
            other.name == name &&
            other.latitude == latitude &&
            other.longitude == longitude &&
            other.country == country;
  }

  @override
  int get hashCode => Object.hash(name, latitude, longitude, country);
}

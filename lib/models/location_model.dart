/// Model untuk data lokasi hasil pencarian Geocoding Open-Meteo
class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1; // Provinsi / wilayah administratif

  LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  /// Factory constructor untuk membuat instance dari JSON API
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Tidak Diketahui',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }

  /// Konversi model ke Map JSON untuk penyimpanan di SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
    };
  }

  /// Deskripsi subtitle rapi (contoh: "Jawa Tengah, Indonesia")
  String get locationSubtitle {
    final parts = [admin1, country].where((p) => p != null && p.isNotEmpty).toList();
    return parts.isEmpty ? 'Koordinat: ${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}' : parts.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

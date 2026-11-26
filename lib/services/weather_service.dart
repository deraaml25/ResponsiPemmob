import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/exceptions/app_exception.dart';
import '../models/weather_model.dart';

/// Service untuk mengambil data cuaca terkini dan prakiraan 7 hari dari Open-Meteo API
class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data cuaca berdasarkan koordinat latitude dan longitude
  Future<WeatherData> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw AppException('Gagal memuat data cuaca (Server Status: ${response.statusCode}).');
      }
    } on SocketException {
      throw AppException('Gagal terhubung ke server cuaca. Pastikan perangkat terhubung ke internet.');
    } on TimeoutException {
      throw AppException('Permintaan data cuaca melebihi batas waktu (10 detik). Silakan muat ulang.');
    } on FormatException {
      throw AppException('Terjadi kesalahan saat memproses data cuaca.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Terjadi kesalahan saat mengambil cuaca: ${e.toString()}');
    }
  }
}

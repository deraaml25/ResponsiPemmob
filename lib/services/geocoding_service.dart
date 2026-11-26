import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/exceptions/app_exception.dart';
import '../models/location_model.dart';

/// Service untuk menangani pencarian lokasi menggunakan Geocoding API Open-Meteo
class GeocodingService {
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  final http.Client _client;

  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari daftar kota berdasarkan kata kunci (query)
  Future<List<LocationModel>> searchCity(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'name': cleanQuery,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Open-Meteo tidak menyertakan key 'results' jika pencarian tidak ditemukan
        if (!data.containsKey('results') || data['results'] == null) {
          return [];
        }

        final List<dynamic> results = data['results'];
        return results.map((item) => LocationModel.fromJson(item)).toList();
      } else {
        throw AppException('Gagal mengambil data lokasi dari server (Status: ${response.statusCode}).');
      }
    } on SocketException {
      throw AppException('Tidak ada koneksi internet. Silakan periksa jaringan Anda.');
    } on TimeoutException {
      throw AppException('Batas waktu koneksi habis (10 detik). Silakan coba lagi.');
    } on FormatException {
      throw AppException('Format data dari server tidak sesuai.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

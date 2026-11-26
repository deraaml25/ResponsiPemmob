import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

/// Service untuk mengelola persistensi data lokasi favorit dan lokasi terakhir di SharedPreferences
class FavoriteStorageService {
  static const String _keyFavorites = 'favorite_locations_list_v1';
  static const String _keyLastLocation = 'last_selected_location_v1';

  /// Mendapatkan daftar semua lokasi favorit yang tersimpan
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyFavorites);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = json.decode(jsonString);
      return decodedList.map((item) => LocationModel.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambahkan lokasi ke daftar favorit
  Future<bool> addFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    // Hindari duplikasi berdasarkan id
    if (!favorites.any((item) => item.id == location.id)) {
      favorites.add(location);
      return await _saveFavoritesList(favorites);
    }
    return true;
  }

  /// Menghapus lokasi dari daftar favorit berdasarkan ID lokasi
  Future<bool> removeFavorite(int locationId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == locationId);
    return await _saveFavoritesList(favorites);
  }

  /// Mengecek apakah suatu lokasi sudah ditandai sebagai favorit
  Future<bool> isFavorite(int locationId) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == locationId);
  }

  /// Menyimpan array list favorit ke format JSON String di local storage
  Future<bool> _saveFavoritesList(List<LocationModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = favorites.map((loc) => loc.toJson()).toList();
    return await prefs.setString(_keyFavorites, json.encode(rawList));
  }

  /// Menyimpan lokasi terakhir yang dipilih pengguna
  Future<bool> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyLastLocation, json.encode(location.toJson()));
  }

  /// Mengambil lokasi terakhir yang dipilih pengguna (jika ada)
  Future<LocationModel?> getLastSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastLocation);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded = json.decode(jsonString);
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}

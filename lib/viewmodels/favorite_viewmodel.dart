import 'package:flutter/foundation.dart';
import '../core/constants/view_state.dart';
import '../models/favorite_weather.dart';
import '../models/location_model.dart';
import '../services/favorite_storage_service.dart';
import '../services/weather_service.dart';

/// ViewModel untuk mengelola state dan pemuatan cuaca lokasi favorit
class FavoriteViewModel extends ChangeNotifier {
  final FavoriteStorageService _storageService;
  final WeatherService _weatherService;

  FavoriteViewModel({
    FavoriteStorageService? storageService,
    WeatherService? weatherService,
  })  : _storageService = storageService ?? FavoriteStorageService(),
        _weatherService = weatherService ?? WeatherService();

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<FavoriteWeather> _favoriteWeathers = [];
  List<FavoriteWeather> get favoriteWeathers => _favoriteWeathers;

  /// Daftar lokasi murni untuk kompatibilitas pengecekan favorit
  List<LocationModel> get favorites =>
      _favoriteWeathers.map((item) => item.location).toList();

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Memuat daftar lokasi favorit dari SharedPreferences dan mengambil cuacanya secara paralel
  Future<void> loadFavorites() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final savedLocations = await _storageService.getFavorites();
      if (savedLocations.isEmpty) {
        _favoriteWeathers = [];
        _state = ViewState.empty;
        notifyListeners();
        return;
      }

      // Siapkan item dengan status awal loading
      _favoriteWeathers = savedLocations
          .map((loc) => FavoriteWeather(location: loc, state: ViewState.loading))
          .toList();
      _state = ViewState.success;
      notifyListeners();

      // Eksekusi pengambilan cuaca ke Open-Meteo secara paralel
      await Future.wait(
        savedLocations.map((loc) => _fetchWeatherForLocation(loc)),
      );

      _state = _favoriteWeathers.isEmpty ? ViewState.empty : ViewState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat favorit: $e';
      _state = ViewState.error;
      notifyListeners();
    }
  }

  /// Mengambil data cuaca untuk 1 lokasi spesifik secara aman (isolasikan error)
  Future<void> _fetchWeatherForLocation(LocationModel loc) async {
    final index = _favoriteWeathers.indexWhere((item) => item.location.id == loc.id);
    if (index == -1) return;

    try {
      final weather = await _weatherService.fetchWeather(
        latitude: loc.latitude,
        longitude: loc.longitude,
      );

      final currentIndex = _favoriteWeathers.indexWhere((item) => item.location.id == loc.id);
      if (currentIndex != -1) {
        _favoriteWeathers[currentIndex] = _favoriteWeathers[currentIndex].copyWith(
          weather: weather,
          state: ViewState.success,
        );
        notifyListeners();
      }
    } catch (e) {
      final currentIndex = _favoriteWeathers.indexWhere((item) => item.location.id == loc.id);
      if (currentIndex != -1) {
        _favoriteWeathers[currentIndex] = _favoriteWeathers[currentIndex].copyWith(
          state: ViewState.error,
          errorMessage: 'Gagal memuat',
        );
        notifyListeners();
      }
    }
  }

  /// Coba lagi memuat cuaca untuk 1 kartu favorit yang error
  Future<void> retryFavoriteWeather(int locationId) async {
    final index = _favoriteWeathers.indexWhere((item) => item.location.id == locationId);
    if (index == -1) return;

    _favoriteWeathers[index] = _favoriteWeathers[index].copyWith(
      state: ViewState.loading,
      errorMessage: null,
    );
    notifyListeners();

    await _fetchWeatherForLocation(_favoriteWeathers[index].location);
  }

  /// Toggle simpan/hapus lokasi favorit
  Future<void> toggleFavorite(LocationModel location) async {
    final alreadyFavorite = isFavorite(location.id);
    if (alreadyFavorite) {
      await removeFavorite(location.id);
    } else {
      await addFavorite(location);
    }
  }

  /// Menambahkan lokasi baru ke daftar favorit dan langsung memuat cuacanya
  Future<void> addFavorite(LocationModel location) async {
    try {
      await _storageService.addFavorite(location);
      if (!_favoriteWeathers.any((item) => item.location.id == location.id)) {
        final newItem = FavoriteWeather(location: location, state: ViewState.loading);
        _favoriteWeathers.add(newItem);
        _state = ViewState.success;
        notifyListeners();

        // Ambil data cuacanya
        await _fetchWeatherForLocation(location);
      }
    } catch (e) {
      _errorMessage = 'Gagal menambahkan favorit: $e';
      notifyListeners();
    }
  }

  /// Menghapus lokasi dari daftar favorit
  Future<void> removeFavorite(int locationId) async {
    try {
      await _storageService.removeFavorite(locationId);
      _favoriteWeathers.removeWhere((item) => item.location.id == locationId);
      _state = _favoriteWeathers.isEmpty ? ViewState.empty : ViewState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menghapus favorit: $e';
      notifyListeners();
    }
  }

  /// Mengecek apakah suatu lokasi ada di daftar favorit
  bool isFavorite(int locationId) {
    return _favoriteWeathers.any((item) => item.location.id == locationId);
  }
}

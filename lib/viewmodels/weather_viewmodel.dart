import 'package:flutter/foundation.dart';
import '../core/constants/view_state.dart';
import '../core/exceptions/app_exception.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/favorite_storage_service.dart';
import '../services/weather_service.dart';

/// ViewModel untuk mengelola state dan data cuaca terkini serta prakiraan 7 hari
class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;
  final FavoriteStorageService _storageService;

  WeatherViewModel({
    WeatherService? weatherService,
    FavoriteStorageService? storageService,
  })  : _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? FavoriteStorageService();

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  LocationModel? _selectedLocation;
  LocationModel? get selectedLocation => _selectedLocation;

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Inisialisasi awal saat aplikasi pertama kali dibuka:
  /// Mencoba memuat lokasi terakhir yang tersimpan di local storage
  Future<void> initialize() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final lastLocation = await _storageService.getLastSelectedLocation();
      if (lastLocation != null) {
        await selectLocation(lastLocation);
      } else {
        // Belum ada lokasi yang dipilih sebelumnya
        _state = ViewState.empty;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat preferensi lokasi: $e';
      _state = ViewState.error;
      notifyListeners();
    }
  }

  /// Memilih lokasi baru, menyimpannya ke local storage, dan memuat data cuaca
  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    // Simpan ke local storage sebagai lokasi terakhir
    await _storageService.saveLastSelectedLocation(location);
    await fetchWeatherForSelectedLocation();
  }

  /// Memuat cuaca untuk lokasi yang saat ini terpilih
  Future<void> fetchWeatherForSelectedLocation() async {
    if (_selectedLocation == null) {
      _state = ViewState.empty;
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await _weatherService.fetchWeather(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );
      _weatherData = data;
      _state = ViewState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem saat memuat cuaca: $e';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  /// Fitur pull-to-refresh untuk memperbarui cuaca lokasi saat ini
  Future<void> refreshWeather() async {
    if (_selectedLocation != null) {
      await fetchWeatherForSelectedLocation();
    }
  }
}

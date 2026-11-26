import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/constants/view_state.dart';
import '../core/exceptions/app_exception.dart';
import '../models/location_model.dart';
import '../services/geocoding_service.dart';

/// ViewModel untuk mengelola pencarian kota dengan debounce dan Geocoding API
class SearchViewModel extends ChangeNotifier {
  final GeocodingService _geocodingService;
  Timer? _debounceTimer;

  SearchViewModel({GeocodingService? geocodingService})
      : _geocodingService = geocodingService ?? GeocodingService();

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<LocationModel> _searchResults = [];
  List<LocationModel> get searchResults => _searchResults;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  /// Dipanggil setiap kali pengguna mengetik di TextField pencarian
  /// Menggunakan debounce 500ms untuk mencegah spam panggilan ke API
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _lastQuery = '';
      _searchResults = [];
      _state = ViewState.initial;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchCity(trimmed);
    });
  }

  /// Mengeksekusi pencarian kota langsung ke GeocodingService
  Future<void> searchCity(String query) async {
    _lastQuery = query;
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await _geocodingService.searchCity(query);
      _searchResults = results;
      if (results.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem: $e';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  /// Menghapus input pencarian dan mereset hasil
  void clearSearch() {
    _debounceTimer?.cancel();
    _lastQuery = '';
    _searchResults = [];
    _state = ViewState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/favorite_storage_service.dart';
import 'services/geocoding_service.dart';
import 'services/weather_service.dart';
import 'viewmodels/favorite_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home/weather_screen.dart';

void main() async {
  // Memastikan inisialisasi binding Flutter selesai sebelum interaksi dengan platform/plugin
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi service layer mandiri
  final weatherService = WeatherService();
  final geocodingService = GeocodingService();
  final storageService = FavoriteStorageService();

  runApp(
    MultiProvider(
      providers: [
        // Provider untuk manajemen lokasi favorit dan pemuatan cuaca paralel
        ChangeNotifierProvider(
          create: (_) => FavoriteViewModel(
            storageService: storageService,
            weatherService: weatherService,
          ),
        ),
        // Provider untuk pencarian kota via Geocoding API
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(geocodingService: geocodingService),
        ),
        // Provider untuk cuaca terkini dan prakiraan 7 hari layar utama
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            weatherService: weatherService,
            storageService: storageService,
          ),
        ),
      ],
      child: const CuacaKitaApp(),
    ),
  );
}

/// Root Widget Aplikasi Cuaca Kita
class CuacaKitaApp extends StatelessWidget {
  const CuacaKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaca Kita',
      debugShowCheckedModeBanner: false,
      // Mengaktifkan Material 3 dan tema terpusat
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Menyesuaikan preferensi sistem (Light/Dark)
      home: const WeatherScreen(),
    );
  }
}

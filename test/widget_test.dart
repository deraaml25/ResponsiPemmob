import 'package:flutter/material.dart';
import 'package:cuaca_kita/core/theme/app_theme.dart';
import 'package:cuaca_kita/services/favorite_storage_service.dart';
import 'package:cuaca_kita/services/geocoding_service.dart';
import 'package:cuaca_kita/services/weather_service.dart';
import 'package:cuaca_kita/viewmodels/favorite_viewmodel.dart';
import 'package:cuaca_kita/viewmodels/search_viewmodel.dart';
import 'package:cuaca_kita/viewmodels/weather_viewmodel.dart';
import 'package:cuaca_kita/views/home/weather_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Aplikasi Cuaca Kita dapat dirender dengan sukses', (WidgetTester tester) async {
    final weatherService = WeatherService();
    final geocodingService = GeocodingService();
    final storageService = FavoriteStorageService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => FavoriteViewModel(
              storageService: storageService,
              weatherService: weatherService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchViewModel(geocodingService: geocodingService),
          ),
          ChangeNotifierProvider(
            create: (_) => WeatherViewModel(
              weatherService: weatherService,
              storageService: storageService,
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const WeatherScreen(),
        ),
      ),
    );

    // Verifikasi bahwa judul aplikasi 'Cuaca Kita' muncul
    expect(find.text('Cuaca Kita'), findsOneWidget);
  });
}

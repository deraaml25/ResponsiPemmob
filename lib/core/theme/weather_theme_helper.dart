import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Data class untuk menyimpan informasi palet warna & visual per kondisi cuaca
class WeatherPalette {
  final List<Color> gradientColors;
  final Color onColor; // Warna teks dan ikon dengan kontras tinggi (minimal 4.5:1)
  final IconData icon;
  final String description;

  const WeatherPalette({
    required this.gradientColors,
    required this.onColor,
    required this.icon,
    required this.description,
  });

  /// LinearGradient helper siap pakai
  LinearGradient get gradient => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}

/// Helper untuk memetakan WMO weather_code ke WeatherPalette spesifik
class WeatherThemeHelper {
  static WeatherPalette getPalette(int? code) {
    if (code == null) {
      return const WeatherPalette(
        gradientColors: [AppColors.glacialSky, AppColors.morningMist],
        onColor: AppColors.tealWaters,
        icon: Icons.wb_cloudy_rounded,
        description: 'Memuat Cuaca',
      );
    }

    // Cerah (0, 1)
    if (code == 0 || code == 1) {
      return WeatherPalette(
        gradientColors: const [AppColors.sunnyStart, AppColors.sunnyEnd],
        onColor: AppColors.tealWaters,
        icon: code == 0 ? Icons.wb_sunny_rounded : Icons.wb_sunny_outlined,
        description: code == 0 ? 'Cerah' : 'Cerah Berawan',
      );
    }

    // Berawan (2, 3)
    if (code == 2 || code == 3) {
      return WeatherPalette(
        gradientColors: const [AppColors.cloudyStart, AppColors.cloudyEnd],
        onColor: AppColors.textWhite,
        icon: code == 2 ? Icons.cloud_queue_rounded : Icons.cloud_rounded,
        description: code == 2 ? 'Sebagian Berawan' : 'Berawan Tebal',
      );
    }

    // Berkabut (45, 48)
    if (code == 45 || code == 48) {
      return const WeatherPalette(
        gradientColors: [AppColors.foggyStart, AppColors.foggyEnd],
        onColor: AppColors.textWhite,
        icon: Icons.foggy,
        description: 'Berkabut',
      );
    }

    // Gerimis / Hujan / Hujan lebat (51-67, 80-82)
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      String desc = 'Hujan';
      if (code >= 51 && code <= 57) desc = 'Gerimis';
      if (code == 65 || code == 82) desc = 'Hujan Lebat';
      return WeatherPalette(
        gradientColors: const [AppColors.rainyStart, AppColors.rainyEnd],
        onColor: AppColors.textWhite,
        icon: (code >= 51 && code <= 57)
            ? Icons.grain_rounded
            : Icons.water_drop_rounded,
        description: desc,
      );
    }

    // Salju (71-77, 85, 86)
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return const WeatherPalette(
        gradientColors: [AppColors.snowyStart, AppColors.snowyEnd],
        onColor: AppColors.textWhite,
        icon: Icons.ac_unit_rounded,
        description: 'Salju',
      );
    }

    // Badai Petir (95-99)
    if (code >= 95 && code <= 99) {
      return const WeatherPalette(
        gradientColors: [AppColors.stormStart, AppColors.stormEnd],
        onColor: AppColors.textWhite,
        icon: Icons.thunderstorm_rounded,
        description: 'Badai Petir',
      );
    }

    // Tidak Dikenal: Default Sand Sky
    return const WeatherPalette(
      gradientColors: [AppColors.glacialSky, AppColors.morningMist],
      onColor: AppColors.tealWaters,
      icon: Icons.wb_cloudy_rounded,
      description: 'Berawan',
    );
  }
}

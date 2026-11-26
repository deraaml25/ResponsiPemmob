import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Helper untuk memetakan WMO Weather Code (Open-Meteo) ke:
/// 1. Deskripsi cuaca dalam Bahasa Indonesia
/// 2. Ikon Material UI yang representatif
/// 3. Warna ikon dengan kontras tinggi (pada kartu maupun di luar kartu)
/// 4. Gradien latar belakang kartu cuaca yang estetis sesuai palet warna
class WeatherCodeHelper {
  /// Mengambil deskripsi cuaca berdasarkan kode WMO
  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Sebagian Berawan';
      case 3:
        return 'Berawan Tebal';
      case 45:
        return 'Berkabut';
      case 48:
        return 'Kabut Mengembun';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis Sedang';
      case 55:
        return 'Gerimis Lebat';
      case 56:
      case 57:
        return 'Gerimis Membeku';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Membeku';
      case 71:
        return 'Salju Ringan';
      case 73:
        return 'Salju Sedang';
      case 75:
      case 77:
        return 'Salju Lebat';
      case 80:
        return 'Hujan Ringan Singkat';
      case 81:
        return 'Hujan Deras Singkat';
      case 82:
        return 'Hujan Badai Dahsyat';
      case 85:
      case 86:
        return 'Hujan Salju Lebat';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai Petir & Hujan Es';
      default:
        return 'Kondisi Berubah';
    }
  }

  /// Mengambil ikon Material yang tepat sesuai kode WMO
  static IconData getIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
        return Icons.wb_sunny_outlined;
      case 2:
        return Icons.cloud_queue_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain_rounded;
      case 61:
      case 63:
        return Icons.water_drop_rounded;
      case 65:
      case 66:
      case 67:
        return Icons.shower_rounded;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit_rounded;
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm_outlined;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  /// Warna ikon khusus saat berada di dalam Kartu Cuaca Utama (selalu cerah & kontras tinggi)
  static Color getIconColorOnCard(int code) {
    if (code == 0 || code == 1) {
      return AppColors.sunnyStart; // Kuning emas matahari cerah
    }
    if (code >= 95) {
      return const Color(0xFFFFD54F); // Kuning petir menyala
    }
    if (code >= 61 && code <= 82) {
      return const Color(0xFFB2EBF2); // Biru muda air berkilau
    }
    // Untuk berawan / kabut: putih bersih agar kontras sempurna dengan background navy
    return Colors.white;
  }

  /// Warna ikon untuk list harian di luar kartu utama
  static Color getIconColor(int code, {bool isDark = false}) {
    if (code == 0 || code == 1) {
      return const Color(0xFFF59E0B);
    }
    if (code >= 95) {
      return const Color(0xFFD97706);
    }
    if (code >= 61 && code <= 82) {
      return const Color(0xFF0288D1);
    }
    if (isDark) {
      return AppColors.glacialSky;
    }
    return AppColors.tealWaters;
  }

  /// Gradien kartu cuaca utama yang kaya & hidup (menggunakan palet Deep Navy, Ocean Glass, Sunlit Ochre)
  static LinearGradient getCardGradient(int code, bool isDark) {
    if (isDark) {
      return const LinearGradient(
        colors: [
          Color(0xFF1B3B3B),
          Color(0xFF162E2E),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    if (code == 0 || code == 1) {
      // Cuaca cerah: Deep Navy dengan semburat hangat
      return const LinearGradient(
        colors: [
          Color(0xFF2C7574),
          Color(0xFF1F5958),
          Color(0xFF184544),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (code >= 61 && code <= 82) {
      // Cuaca hujan: Deep navy sejuk bernuansa biru laut
      return const LinearGradient(
        colors: [
          Color(0xFF236569),
          Color(0xFF1B4E52),
          Color(0xFF14393C),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Cuaca berawan / kabut: Deep navy elegan dengan transisi halus
      return const LinearGradient(
        colors: [
          Color(0xFF2A6F6E),
          Color(0xFF225958),
          Color(0xFF1A4443),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna resmi terpusat untuk aplikasi "Cuaca Kita"
/// Menggabungkan palet Sand resmi:
/// - Sunlit Ochre (#FFD248)
/// - Ocean Glass (#A7BEC1)
/// - Deep Navy (#2F7C7A)
/// - Warm Sand (#F1E4CF)
/// Serta gradasi kondisi cuaca dinamis (Sunny, Cloudy, Rainy, Snowy, Storm).
/// Semua teks dan elemen mematuhi standar kontras AA Pass.
class AppColors {
  // Palet Utama Sand (Referensi Sand Card AA Pass)
  static const Color sunlitOchre = Color(0xFFFFD248); // Kuning keemasan hangat
  static const Color oceanGlass = Color(0xFFA7BEC1);  // Biru abu-abu lembut
  static const Color deepNavy = Color(0xFF2F7C7A);    // Biru toska gelap (elemen tegas & teks)
  static const Color warmSand = Color(0xFFF1E4CF);    // Pasir gading lembut (latar belakang)

  // Aksen tambahan pelengkap
  static const Color springMeadow = Color(0xFFCAFFA6); // Aksen hijau segar
  static const Color tealWaters = Color(0xFF204654);   // Navy pekat untuk teks sangat kontras
  static const Color glacialSky = Color(0xFFA9E0F1);   // Biru langit cerah
  static const Color morningMist = Color(0xFFF7F9E1);  // Putih gading lembut

  // Gradasi Cuaca - Cerah (0, 1) - Kuning hangat keemasan (seperti Istanbul di referensi)
  static const Color sunnyStart = Color(0xFFFFC043);
  static const Color sunnyEnd = Color(0xFFF58A07);

  // Gradasi Cuaca - Berawan (2, 3) - Ungu lembayung / indigo (seperti Toronto di referensi)
  static const Color cloudyStart = Color(0xFF6B4FA0);
  static const Color cloudyEnd = Color(0xFF3B2A63);

  // Gradasi Cuaca - Berkabut (45, 48) - Abu-abu biru kabut lembut
  static const Color foggyStart = Color(0xFF6E8996);
  static const Color foggyEnd = Color(0xFF475E69);

  // Gradasi Cuaca - Hujan / Gerimis (51-67, 80-82) - Biru kelabu hujan (seperti My Location)
  static const Color rainyStart = Color(0xFF3B5B78);
  static const Color rainyEnd = Color(0xFF223547);

  // Gradasi Cuaca - Salju (71-77, 85, 86) - Biru es cerah (seperti Nuuk di referensi)
  static const Color snowyStart = Color(0xFF56B4D3);
  static const Color snowyEnd = Color(0xFF348AC7);

  // Gradasi Cuaca - Badai Petir (95-99) - Ungu gelap pekat
  static const Color stormStart = Color(0xFF453D66);
  static const Color stormEnd = Color(0xFF201B36);

  // Warna Transparan & Kaca (Glassmorphism)
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);
  static const Color glassCardLight = Color(0x28FFFFFF);
  static const Color glassCardDark = Color(0x1FFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
}

/// Konfigurasi Tema Terpusat Material 3
class AppTheme {
  // Alias konstan ke AppColors untuk kompatibilitas widget
  static const Color sunlitOchre = AppColors.sunlitOchre;
  static const Color oceanGlass = AppColors.oceanGlass;
  static const Color deepNavy = AppColors.deepNavy;
  static const Color warmSand = AppColors.warmSand;
  static const Color darkBackground = Color(0xFF0F1B20);
  static const Color darkSurface = Color(0xFF14242A);
  static const Color lightBackground = AppColors.warmSand;
  static const Color lightSurface = Colors.white;

  /// Tema Terang (Light Mode)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepNavy,
      brightness: Brightness.light,
      primary: AppColors.deepNavy,
      onPrimary: AppColors.warmSand,
      secondary: AppColors.sunlitOchre,
      onSecondary: AppColors.deepNavy,
      surface: Colors.white,
      onSurface: AppColors.deepNavy,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.warmSand,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.deepNavy),
        titleTextStyle: TextStyle(
          color: AppColors.deepNavy,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.85),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.deepNavy.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.deepNavy.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.deepNavy, width: 2),
        ),
        prefixIconColor: AppColors.deepNavy,
        hintStyle: TextStyle(color: AppColors.deepNavy.withValues(alpha: 0.5)),
      ),
    );
  }

  /// Tema Gelap (Dark Mode)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepNavy,
      brightness: Brightness.dark,
      primary: AppColors.oceanGlass,
      onPrimary: AppColors.deepNavy,
      secondary: AppColors.sunlitOchre,
      onSecondary: AppColors.deepNavy,
      surface: const Color(0xFF14242A),
      onSurface: AppColors.warmSand,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F1B20),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.warmSand),
        titleTextStyle: TextStyle(
          color: AppColors.warmSand,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A2E35),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.sunlitOchre, width: 2),
        ),
        prefixIconColor: AppColors.sunlitOchre,
        hintStyle: const TextStyle(color: Color(0xFF8B9E9E)),
      ),
    );
  }
}

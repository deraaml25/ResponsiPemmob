import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/view_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/weather_theme_helper.dart';
import '../../core/utils/greeting_helper.dart';
import '../../viewmodels/favorite_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../search/search_screen.dart';
import '../widgets/cloud_background.dart';
import '../widgets/daily_forecast_strip.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/stat_row.dart';
import '../widgets/state_widgets.dart';

/// Layar Utama Cuaca Kita: Menampilkan cuaca detail kota terpilih dengan gradasi dinamis
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
      context.read<FavoriteViewModel>().loadFavorites();
    });
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  /// Format tanggal Indonesia: "Hari ini, Kamis 26 Nov"
  String _formatIndonesianDate(String? isoDate) {
    try {
      final now = isoDate != null ? DateTime.parse(isoDate) : DateTime.now();
      const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final dayName = days[now.weekday - 1];
      final monthName = months[now.month - 1];
      return 'Hari ini, $dayName ${now.day} $monthName';
    } catch (_) {
      return 'Hari ini';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherViewModel>();
    final favoriteVM = context.watch<FavoriteViewModel>();
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    // Tentukan palet warna aktif berdasarkan kondisi cuaca
    final WeatherPalette palette;
    if (weatherVM.state == ViewState.success && weatherVM.weatherData != null) {
      palette = WeatherThemeHelper.getPalette(
        weatherVM.weatherData!.current.weatherCode,
      );
    } else {
      // Saat loading/error/kosong gunakan palet default Sand
      palette = WeatherThemeHelper.getPalette(null);
    }

    final isFav = weatherVM.selectedLocation != null &&
        favoriteVM.isFavorite(weatherVM.selectedLocation!.id);

    return AnimatedContainer(
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: palette.gradient,
      ),
      child: CloudBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context, weatherVM, favoriteVM, palette, isFav),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: RefreshIndicator(
                  color: palette.onColor,
                  backgroundColor: AppColors.warmSand,
                  onRefresh: () async {
                    await weatherVM.refreshWeather();
                    if (context.mounted) {
                      await favoriteVM.loadFavorites();
                    }
                  },
                  child: _buildBody(context, weatherVM, palette),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar Modern dengan Sapaan Ramah dan Tombol Kaca Bulat (48x48)
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WeatherViewModel weatherVM,
    FavoriteViewModel favoriteVM,
    WeatherPalette palette,
    bool isFav,
  ) {
    return AppBar(
      titleSpacing: 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GreetingHelper.getGreeting(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.onColor.withValues(alpha: 0.75),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Cuaca Kita',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: palette.onColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        if (weatherVM.selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GlassIconButton(
              icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              tooltip: isFav ? 'Hapus dari favorit' : 'Simpan ke favorit',
              iconColor: isFav ? const Color(0xFFE53935) : palette.onColor,
              backgroundColor: AppColors.glassWhite,
              onPressed: () {
                favoriteVM.toggleFavorite(weatherVM.selectedLocation!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFav
                          ? '${weatherVM.selectedLocation!.name} dihapus dari favorit'
                          : '${weatherVM.selectedLocation!.name} disimpan ke favorit',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GlassIconButton(
            icon: Icons.search_rounded,
            tooltip: 'Cari lokasi',
            iconColor: palette.onColor,
            backgroundColor: AppColors.glassWhite,
            onPressed: () => _navigateToSearch(context),
          ),
        ),
      ],
    );
  }

  /// Membangun isi layar sesuai ViewState
  Widget _buildBody(
    BuildContext context,
    WeatherViewModel weatherVM,
    WeatherPalette palette,
  ) {
    switch (weatherVM.state) {
      case ViewState.loading:
        return const LoadingStateWidget(
          message: 'Mengambil data cuaca terbaru...',
        );

      case ViewState.error:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ErrorStateWidget(
              message: weatherVM.errorMessage,
              onRetry: () => weatherVM.fetchWeatherForSelectedLocation(),
            ),
          ),
        );

      case ViewState.empty:
      case ViewState.initial:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: EmptyStateWidget(
              title: 'Belum Ada Lokasi',
              subtitle: 'Cari dan pilih kota untuk mengetahui prakiraan cuaca terkini.',
              buttonText: 'Cari Lokasi Sekarang',
              onAction: () => _navigateToSearch(context),
            ),
          ),
        );

      case ViewState.success:
        final weatherData = weatherVM.weatherData!;
        final location = weatherVM.selectedLocation!;
        final current = weatherData.current;
        final daily = weatherData.daily;
        final todayDaily = daily.isNotEmpty ? daily.first : null;
        final todayRainProb = todayDaily?.precipitationProbabilityMax ?? 0;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // 1. Info Lokasi & Tanggal (Rata Tengah seperti Referensi)
              Text(
                location.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: palette.onColor,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                location.locationSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: palette.onColor.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _formatIndonesianDate(todayDaily?.date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.onColor.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Ikon Cuaca Besar dengan Glow Lingkaran Berlapis (Gaya Referensi)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow Latar Belakang Lembut
                  Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          palette.onColor.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Lingkaran Kaca Frosted Ikon
                  Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        palette.icon,
                        size: 68,
                        color: palette.onColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 3. Suhu Sangat Besar (64) & Kondisi Teks
              Semantics(
                label: 'Suhu saat ini ${current.temperature2m.round()} derajat celcius',
                child: Text(
                  '${current.temperature2m.round()}°',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: palette.onColor,
                    height: 1.0,
                    letterSpacing: -2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                palette.description,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: palette.onColor,
                ),
              ),

              // Tertinggi & Terendah
              if (todayDaily != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Tertinggi ${todayDaily.temperatureMax.round()}° - Terendah ${todayDaily.temperatureMin.round()}°',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: palette.onColor.withValues(alpha: 0.8),
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // 4. Kartu Statistik Kaca 3 Kolom + 2 Kartu Kecil
              StatRow(
                current: current,
                todayRainProb: todayRainProb,
                onColor: palette.onColor,
              ),

              const SizedBox(height: 20),

              // 5. Prakiraan 7 Hari dalam Satu Kartu Kaca Horizontal
              DailyForecastStrip(
                dailyList: daily,
                onColor: palette.onColor,
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
    }
  }
}

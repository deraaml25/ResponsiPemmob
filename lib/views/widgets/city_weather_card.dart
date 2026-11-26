import 'package:flutter/material.dart';
import '../../core/constants/view_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/weather_theme_helper.dart';
import '../../models/favorite_weather.dart';
import 'glass_card.dart';

/// Kartu cuaca lokasi favorit dengan warna gradasi sesuai kondisi cuaca (Gaya Referensi)
class CityWeatherCard extends StatelessWidget {
  final FavoriteWeather item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRetry;

  const CityWeatherCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('fav_card_${item.location.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 26),
            SizedBox(width: 6),
            Text(
              'Hapus',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final location = item.location;

    // 1. Tampilan saat data cuaca item ini masih loading
    if (item.state == ViewState.loading) {
      return Semantics(
        label: '${location.name}, sedang memuat cuaca',
        child: Container(
          height: 98,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealWaters,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location.locationSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.tealWaters.withValues(alpha: 0.65),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.tealWaters),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. Tampilan saat data cuaca item ini gagal dimuat
    if (item.state == ViewState.error || item.weather == null) {
      return Semantics(
        label: '${location.name}, gagal memuat cuaca',
        child: Container(
          height: 98,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealWaters,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Gagal memuat cuaca',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Coba lagi', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.tealWaters,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey),
                  onPressed: onDelete,
                  tooltip: 'Hapus dari favorit',
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Tampilan Sukses: Kartu berwarna sesuai kondisi cuaca (Gaya Referensi)
    final current = item.weather!.current;
    final palette = WeatherThemeHelper.getPalette(current.weatherCode);
    final tempText = '${current.temperature2m.round()}°';
    final semanticLabel = '${location.name}, ${palette.description}, $tempText derajat';

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Container(
        height: 98,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: palette.gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: palette.gradientColors.last.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Stack(
              children: [
                // Ikon Cuaca Besar Transparan di Pojok Kanan Bawah
                Positioned(
                  right: -6,
                  bottom: -10,
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        palette.icon,
                        size: 46,
                        color: palette.onColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ),

                // Tombol Hapus/Favorit Kecil di Pojok Kanan Atas
                Positioned(
                  top: 8,
                  right: 8,
                  child: Semantics(
                    button: true,
                    label: 'Hapus ${location.name} dari favorit',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: palette.onColor.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Konten Teks: Nama, Kondisi, dan Suhu Besar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sisi Kiri: Nama Kota & Kondisi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              location.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: palette.onColor,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              palette.description,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: palette.onColor.withValues(alpha: 0.85),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Suhu Angka Besar di Kiri Ikon
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: Text(
                          tempText,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: palette.onColor,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

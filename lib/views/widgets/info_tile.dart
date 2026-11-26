import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/weather_model.dart';

/// Kartu individual untuk metrik informasi cuaca dengan tampilan elegan
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color accentColor;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14242A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.glacialSky.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : AppColors.tealWaters.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: accentColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : AppColors.morningMist.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFA5B8B8) : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.tealWaters,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFA5B8B8) : const Color(0xFF6B7280),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Grid responsif yang menyusun 5 metrik cuaca utama
class WeatherInfoGrid extends StatelessWidget {
  final CurrentWeather current;
  final int todayRainProb;

  const WeatherInfoGrid({
    super.key,
    required this.current,
    required this.todayRainProb,
  });

  String _getHumidityDesc(int val) {
    if (val < 40) return 'Kering';
    if (val <= 70) return 'Nyaman';
    return 'Lembap';
  }

  String _getWindDesc(double speed) {
    if (speed < 5) return 'Tenang';
    if (speed < 20) return 'Sepoi';
    return 'Kencang';
  }

  String _getPrecipDesc(double p) {
    if (p <= 0.0) return 'Kering';
    if (p < 2.5) return 'Gerimis';
    return 'Basah';
  }

  String _getApparentDesc(double app, double actual) {
    final diff = app - actual;
    if (diff.abs() < 1) return 'Sesuai';
    return diff > 0 ? 'Lebih Hangat' : 'Lebih Sejuk';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 650 ? 3 : 2;

        final items = [
          InfoTile(
            icon: Icons.thermostat_rounded,
            label: 'Terasa Seperti',
            value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
            subtitle: _getApparentDesc(current.apparentTemperature, current.temperature2m),
            accentColor: const Color(0xFFE65100),
          ),
          InfoTile(
            icon: Icons.water_drop_rounded,
            label: 'Kelembapan Udara',
            value: '${current.relativeHumidity2m}%',
            subtitle: _getHumidityDesc(current.relativeHumidity2m),
            accentColor: const Color(0xFF0288D1),
          ),
          InfoTile(
            icon: Icons.air_rounded,
            label: 'Kecepatan Angin',
            value: '${current.windSpeed10m.toStringAsFixed(1)} km/h',
            subtitle: _getWindDesc(current.windSpeed10m),
            accentColor: const Color(0xFF00897B),
          ),
          InfoTile(
            icon: Icons.umbrella_rounded,
            label: 'Curah Hujan',
            value: '${current.precipitation.toStringAsFixed(1)} mm',
            subtitle: _getPrecipDesc(current.precipitation),
            accentColor: const Color(0xFF3949AB),
          ),
          InfoTile(
            icon: Icons.cloud_outlined,
            label: 'Peluang Hujan',
            value: '$todayRainProb%',
            subtitle: todayRainProb > 50 ? 'Peluang Tinggi' : 'Peluang Rendah',
            accentColor: const Color(0xFF7E57C2),
          ),
        ];

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

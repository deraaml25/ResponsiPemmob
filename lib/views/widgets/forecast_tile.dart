import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_code_helper.dart';
import '../../models/weather_model.dart';

/// Komponen list item modern untuk menampilkan prakiraan cuaca harian
class ForecastTile extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;

  const ForecastTile({
    super.key,
    required this.forecast,
    this.isToday = false,
  });

  String _formatDayName(String dateStr) {
    if (isToday) return 'Hari Ini';
    try {
      final parsed = DateTime.parse(dateStr);
      const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      return days[parsed.weekday - 1];
    } catch (_) {
      return dateStr;
    }
  }

  String _formatDateSubtitle(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${parsed.day} ${months[parsed.month - 1]}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weatherDesc = WeatherCodeHelper.getDescription(forecast.weatherCode);
    final weatherIcon = WeatherCodeHelper.getIcon(forecast.weatherCode);
    final iconColor = WeatherCodeHelper.getIconColor(forecast.weatherCode, isDark: isDark);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14242A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isToday
              ? (isDark ? AppColors.sunnyStart : AppColors.tealWaters)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : AppColors.glacialSky.withValues(alpha: 0.28)),
          width: isToday ? 1.6 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : AppColors.tealWaters.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDayName(forecast.date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w700,
                    color: isToday
                        ? (isDark ? AppColors.sunnyStart : AppColors.tealWaters)
                        : (isDark ? Colors.white : AppColors.tealWaters),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateSubtitle(forecast.date),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFFA5B8B8) : const Color(0xFF8A9494),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    weatherIcon,
                    size: 20,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weatherDesc,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFE4ECEC) : const Color(0xFF2D3748),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (forecast.precipitationProbabilityMax > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.water_drop_rounded,
                                size: 10,
                                color: Color(0xFF0288D1),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${forecast.precipitationProbabilityMax}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0288D1),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${forecast.temperatureMin.round()}°',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFA5B8B8) : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.glacialSky,
                          AppColors.sunnyStart,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${forecast.temperatureMax.round()}°',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.tealWaters,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

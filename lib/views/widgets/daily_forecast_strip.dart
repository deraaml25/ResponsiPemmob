import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_code_helper.dart';
import '../../models/weather_model.dart';
import 'glass_card.dart';

/// Prakiraan cuaca 7 hari dalam 1 kartu kaca horizontal yang dapat digeser (Gaya Referensi)
class DailyForecastStrip extends StatelessWidget {
  final List<DailyForecast> dailyList;
  final Color onColor;

  const DailyForecastStrip({
    super.key,
    required this.dailyList,
    required this.onColor,
  });

  String _formatShortDay(String dateStr, int index) {
    if (index == 0) return 'Hari ini';
    try {
      final parsed = DateTime.parse(dateStr);
      const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      return days[parsed.weekday - 1];
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 26,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: onColor.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Prakiraan 7 Hari',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: onColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(dailyList.length, (index) {
                final item = dailyList[index];
                final iconData = WeatherCodeHelper.getIcon(item.weatherCode);
                final shortDay = _formatShortDay(item.date, index);

                return Container(
                  width: 76,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? onColor.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: index == 0
                        ? Border.all(color: onColor.withValues(alpha: 0.22), width: 1)
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nama Hari Singkat
                      Text(
                        shortDay,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.w600,
                          color: onColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Ikon Cuaca
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: onColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          size: 22,
                          color: onColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Suhu Max
                      Text(
                        '${item.temperatureMax.round()}°',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: onColor,
                        ),
                      ),
                      // Suhu Min
                      Text(
                        '${item.temperatureMin.round()}°',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: onColor.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Chip Peluang Hujan (Aksen Spring Meadow, Teks Teal Waters)
                      if (item.precipitationProbabilityMax > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.springMeadow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.precipitationProbabilityMax}%',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tealWaters,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 15),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

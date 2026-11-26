import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_code_helper.dart';
import '../../models/location_model.dart';
import '../../models/weather_model.dart';

/// Kartu visual utama cuaca terkini dengan desain Glassmorphism modern
class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;
  final DailyForecast? todayForecast;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.current,
    this.todayForecast,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weatherDesc = WeatherCodeHelper.getDescription(current.weatherCode);
    final weatherIcon = WeatherCodeHelper.getIcon(current.weatherCode);
    final cardIconColor = WeatherCodeHelper.getIconColorOnCard(current.weatherCode);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: WeatherCodeHelper.getCardGradient(current.weatherCode, isDark),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.tealWaters.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.sunnyStart.withValues(alpha: 0.22),
                    Colors.white.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.sunnyStart.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.sunnyStart,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  location.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              location.locationSubtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onToggleFavorite,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isFavorite ? AppColors.sunnyStart : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current.temperature2m.round().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 76,
                                fontWeight: FontWeight.w800,
                                height: 0.95,
                                letterSpacing: -2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 2.0),
                              child: Text(
                                '°C',
                                style: TextStyle(
                                  color: AppColors.sunnyStart,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                weatherIcon,
                                size: 16,
                                color: cardIconColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                weatherDesc,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          weatherIcon,
                          size: 64,
                          color: cardIconColor,
                        ),
                      ),
                    ),
                  ],
                ),

                if (todayForecast != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.wb_twilight_rounded,
                              size: 16,
                              color: AppColors.sunnyStart,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Rentang: ${todayForecast!.temperatureMin.round()}° - ${todayForecast!.temperatureMax.round()}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (todayForecast!.precipitationProbabilityMax > 0)
                          Row(
                            children: [
                              const Icon(
                                Icons.umbrella_rounded,
                                size: 15,
                                color: Color(0xFF80DEEA),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${todayForecast!.precipitationProbabilityMax}% Hujan',
                                style: const TextStyle(
                                  color: Color(0xFFE0F7FA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

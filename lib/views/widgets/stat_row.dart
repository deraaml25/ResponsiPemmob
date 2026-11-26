import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import 'glass_card.dart';

/// Kartu statistik kaca 3 kolom dan 2 kartu sekunder (Gaya Referensi)
/// Semua teks dan ikon menggunakan onColor dari palet kondisi cuaca saat ini
class StatRow extends StatelessWidget {
  final CurrentWeather current;
  final int todayRainProb;
  final Color onColor;

  const StatRow({
    super.key,
    required this.current,
    required this.todayRainProb,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kartu Utama 3 Kolom dengan Pembatas Vertikal Tipis
        GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Kolom 1: Kelembapan
              Expanded(
                child: _buildStatItem(
                  icon: Icons.water_drop_rounded,
                  label: 'Kelembapan',
                  value: '${current.relativeHumidity2m}%',
                ),
              ),

              // Pembatas Tipis 1
              Container(
                width: 1,
                height: 38,
                color: onColor.withValues(alpha: 0.18),
              ),

              // Kolom 2: Angin
              Expanded(
                child: _buildStatItem(
                  icon: Icons.air_rounded,
                  label: 'Angin',
                  value: '${current.windSpeed10m.toStringAsFixed(1)} km/j',
                ),
              ),

              // Pembatas Tipis 2
              Container(
                width: 1,
                height: 38,
                color: onColor.withValues(alpha: 0.18),
              ),

              // Kolom 3: Peluang Hujan
              Expanded(
                child: _buildStatItem(
                  icon: Icons.umbrella_rounded,
                  label: 'Peluang',
                  value: '$todayRainProb%',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Baris Bawah: 2 Kartu Kaca Kecil (Terasa Seperti & Curah Hujan)
        Row(
          children: [
            Expanded(
              child: GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: onColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.thermostat_rounded,
                        size: 20,
                        color: onColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terasa Seperti',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: onColor.withValues(alpha: 0.75),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${current.apparentTemperature.toStringAsFixed(1)}°C',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: onColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: onColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.grain_rounded,
                        size: 20,
                        color: onColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Curah Hujan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: onColor.withValues(alpha: 0.75),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${current.precipitation.toStringAsFixed(1)} mm',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: onColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: onColor.withValues(alpha: 0.9),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: onColor,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: onColor.withValues(alpha: 0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

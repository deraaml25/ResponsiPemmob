/// Model untuk cuaca saat ini (Current Weather)
class CurrentWeather {
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed10m;
  final String time;

  CurrentWeather({
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed10m,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature2m: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity2m: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed10m: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      time: json['time'] as String? ?? '',
    );
  }
}

/// Model untuk prakiraan cuaca harian (Daily Forecast item)
class DailyForecast {
  final String date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
  });
}

/// Model utama pembungkus respons prakiraan cuaca Open-Meteo
class WeatherData {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  /// Factory untuk mem-parsing JSON dari endpoint https://api.open-meteo.com/v1/forecast
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    // Parsing data harian berformat array paralel dari Open-Meteo
    final List<String> times = List<String>.from(dailyJson['time'] ?? []);
    final List<dynamic> weatherCodes = dailyJson['weather_code'] ?? [];
    final List<dynamic> maxTemps = dailyJson['temperature_2m_max'] ?? [];
    final List<dynamic> minTemps = dailyJson['temperature_2m_min'] ?? [];
    final List<dynamic> precipProbabilities = dailyJson['precipitation_probability_max'] ?? [];

    final List<DailyForecast> dailyList = [];
    final int count = times.length;

    for (int i = 0; i < count; i++) {
      dailyList.add(
        DailyForecast(
          date: times[i],
          weatherCode: i < weatherCodes.length ? (weatherCodes[i] as num).toInt() : 0,
          temperatureMax: i < maxTemps.length ? (maxTemps[i] as num).toDouble() : 0.0,
          temperatureMin: i < minTemps.length ? (minTemps[i] as num).toDouble() : 0.0,
          precipitationProbabilityMax: i < precipProbabilities.length
              ? (precipProbabilities[i] as num?)?.toInt() ?? 0
              : 0,
        ),
      );
    }

    return WeatherData(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
    );
  }
}

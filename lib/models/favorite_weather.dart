import '../core/constants/view_state.dart';
import 'location_model.dart';
import 'weather_model.dart';

/// Model untuk item lokasi favorit beserta data cuacanya dan status pemuatan
class FavoriteWeather {
  final LocationModel location;
  final WeatherData? weather;
  final ViewState state;
  final String? errorMessage;

  FavoriteWeather({
    required this.location,
    this.weather,
    this.state = ViewState.loading,
    this.errorMessage,
  });

  /// CopyWith helper untuk kemudahan update state per item
  FavoriteWeather copyWith({
    LocationModel? location,
    WeatherData? weather,
    ViewState? state,
    String? errorMessage,
  }) {
    return FavoriteWeather(
      location: location ?? this.location,
      weather: weather ?? this.weather,
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

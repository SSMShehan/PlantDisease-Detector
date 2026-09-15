class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String iconCode;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      condition: json['weather'][0]['main'] as String,
      iconCode: json['weather'][0]['icon'] as String,
    );
  }

  // Fallback mock data
  factory WeatherModel.mock() {
    return WeatherModel(
      temperature: 28.5,
      humidity: 78,
      windSpeed: 12.0,
      condition: 'Sunny',
      iconCode: '01d',
    );
  }
}

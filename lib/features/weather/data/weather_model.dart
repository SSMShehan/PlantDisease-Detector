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
    final current = json['current_weather'];
    final temp = (current['temperature'] as num).toDouble();
    final wind = (current['windspeed'] as num).toDouble();
    final code = current['weathercode'] as int;
    
    // Attempt to get current humidity (default 60 if missing)
    int rh = 60;
    try {
       rh = (json['hourly']['relative_humidity_2m'] as List)[0] as int;
    } catch (_) {}

    String cond = 'Sunny';
    String iCode = '01d';
    
    // WMO Weather interpretation codes
    if (code == 0) { cond = 'Clear Sky'; iCode = '01d'; }
    else if (code == 1 || code == 2 || code == 3) { cond = 'Partly Cloudy'; iCode = '02d'; }
    else if (code == 45 || code == 48) { cond = 'Fog'; iCode = '50d'; }
    else if (code >= 51 && code <= 67) { cond = 'Rain'; iCode = '10d'; }
    else if (code >= 71 && code <= 77) { cond = 'Snow'; iCode = '13d'; }
    else if (code >= 80 && code <= 82) { cond = 'Rain Showers'; iCode = '09d'; }
    else if (code >= 95 && code <= 99) { cond = 'Thunderstorm'; iCode = '11d'; }

    return WeatherModel(
      temperature: temp,
      humidity: rh,
      windSpeed: wind,
      condition: cond,
      iconCode: iCode,
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

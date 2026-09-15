import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Request location permissions and get current position.
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    } 

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Convert coordinates to a readable address.
  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? 'Unknown Location';
        String country = place.country ?? '';
        return country.isNotEmpty ? '$city, $country' : city;
      }
    } catch (e) {
      // Fallback to OSM Nominatim API if native geocoding fails (e.g., on Web)
      try {
        final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
        final response = await http.get(url, headers: {
          'User-Agent': 'PlantDiseaseDetectorApp/1.0',
        });
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final address = data['address'];
          if (address != null) {
            String city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? address['state_district'] ?? 'Unknown Location';
            String country = address['country'] ?? '';
            return country.isNotEmpty ? '$city, $country' : city;
          }
        }
      } catch (_) {}
      
      // If all fails, show coordinates
      return '${lat.toStringAsFixed(3)}, ${lon.toStringAsFixed(3)}';
    }
    return '${lat.toStringAsFixed(3)}, ${lon.toStringAsFixed(3)}';
  }
}

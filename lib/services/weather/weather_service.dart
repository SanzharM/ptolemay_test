import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ptolemay_test/services/api.dart';

class WeatherService {
  static Future<String?> fetchWeather(Position position) async {
    final String url = Api.urlWithParams(Api.baseUrl + Endpoints.weather, {
      '{lat}': position.latitude.toString(),
      '{lng}': position.longitude.toString(),
      '{params}': 'airTemperature',
      '{start_time}': DateTime.now().toString(),
      '{end_time}': DateTime.now().add(const Duration(hours: 1)).toString(),
    });

    try {
      final response = await http.get(Uri.parse(url), headers: Api.headers).timeout(const Duration(seconds: 10));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return await compute(parseWeather, response.bodyBytes);
      }
      return await compute(parseError, response.bodyBytes);
    } catch (e) {
      debugPrint('Error at fetching Weather: $e');
    }
    return null;
  }

  static String? parseWeather(Uint8List bodyBytes) {
    if (bodyBytes.isEmpty) return null;
    try {
      final json = convert.json.decode(convert.utf8.decode(bodyBytes)) as Map<String, dynamic>;
      final hours = json['hours'] as List<Map<String, dynamic>>?;

      if (hours?.isEmpty ?? true) {
        return null;
      }
      return hours!.first['airTemperature']['noaa'].toString();
    } catch (e) {
      debugPrint('Error at parsing Weather: $e');
    }
    return null;
  }

  static String? parseError(Uint8List bodyBytes) {
    if (bodyBytes.isEmpty) return null;
    try {
      final json = convert.json.decode(convert.utf8.decode(bodyBytes)) as Map<String, dynamic>;
      return json['errors']?['key'] ?? json['details'] ?? 'Unknown error';
    } catch (e) {
      debugPrint('Error at parsing error with Weather: $e');
    }
    return 'Unknown error';
  }
}

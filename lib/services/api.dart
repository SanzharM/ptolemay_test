import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Api {
  static const baseUrl = 'https://api.stormglass.io';
  static const _apiKey = '16195dae-f392-11ec-91f7-0242ac130002-16195e1c-f392-11ec-91f7-0242ac130002';
  static const headers = {'Authorization': _apiKey};

  static String urlWithParams(String url, Map<String, String>? queryParams) {
    if (queryParams == null) return url;
    queryParams.forEach((key, value) => url = url.replaceAll(key, value));
    return url;
  }

  static void logResponse(Response response) {
    debugPrint('\n-------------');
    debugPrint('Url: ${response.request?.url}');
    debugPrint('Headers: ${response.headers}');
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
  }
}

class Endpoints {
  static const weather = '/v2/weather/point?lat={lat}&lng={lng}&params={params}&start={start_time}&end={end_time}';
}

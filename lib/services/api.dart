class Api {
  static const baseUrl = 'https://api.stormglass.io';
  static const headers = {'Authorization': '3306d47e-f37d-11ec-9e5f-0242ac130002-3306d4ec-f37d-11ec-9e5f-0242ac130002'};

  static String urlWithParams(String url, Map<String, String>? queryParams) {
    if (queryParams == null) return url;
    queryParams.forEach((key, value) => url = url.replaceAll(key, value));
    return url;
  }
}

class Endpoints {
  static const weather = '/v2/weather/point?lat={lat}&lng={lng}&params={params}&start={start_time}&end={end_time}';
}

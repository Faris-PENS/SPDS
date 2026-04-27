import 'package:http/http.dart' as http;

class ApService {

  static Future<http.Response> post(String endpoint, {Object? body}) {
    return http.post(Uri.parse(endpoint), body: body);
  }
}
import 'package:http/http.dart' as http;

class ApService {
  final http.Client client;

  ApService(this.client);

  Future<http.Response> post(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return client.post(
      Uri.parse(endpoint),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> get(String endpoint) {
    return client.get(Uri.parse(endpoint));
  }
}
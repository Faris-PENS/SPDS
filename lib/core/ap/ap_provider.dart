import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/ap/ap_init.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final apServiceProvider = Provider<ApService>((ref) {
  final client = ref.read(httpClientProvider);
  return ApService(client);
});
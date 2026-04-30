import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/ap/ap_init.dart';
import 'package:spds/core/ap/ap_provider.dart';

final apNotifierProvider =
    NotifierProvider<ApNotifier, bool>(ApNotifier.new);

class ApNotifier extends Notifier<bool> {
  late final ApService api;

  @override
  bool build() {
    api = ref.read(apServiceProvider);
    return false;
  }

  Future<bool> sendCredential(String ssid, String password) async {
    try {
      state = true;

      final res = await api
          .post(
            "http://192.168.4.1/provision",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: {"ssid": ssid, "password": password},
          )
          .timeout(const Duration(seconds: 5));
        print("Provision response: ${res.statusCode}");
      print("Provision body: ${res.body}");
      state = false;
      return res.statusCode == 200;
    } catch (_) {
      state = false;
      return false;
    }
  }

  Future<bool> konfirmasiKonek() async {
    try {
      state = true;

      final res = await api.post(
        "http://192.168.4.1/confirm",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "confirm=1",
      );
         print("konfirmasi response: ${res.statusCode}");
      print("konfirmasi body: ${res.body}");

      state = false;
      return res.statusCode == 200;
    } catch (_) {
      state = false;
      return false;
    }
  }

  Future<String?> statusEsp() async {
    try {
      final res = await api.get("http://192.168.4.1/status");
      print("Status code: ${res.statusCode}");
      print("Status body: ${res.body}");
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["state"];
      }
      else if (res.statusCode == 404) {
        return null;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
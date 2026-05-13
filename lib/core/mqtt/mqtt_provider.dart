import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/mqtt/mqtt_client.dart';
final mqttProvider = StateNotifierProvider<MqttNotifier, MqttClientCore?>(
  (ref) => MqttNotifier(),
);

class MqttNotifier extends StateNotifier<MqttClientCore?> {
  MqttNotifier() : super(null);

  void set(MqttClientCore client) {
    state = client;
  }

  void clear() {
    state = null;
  }
}

final currentEspProvider = StateProvider<String?>((ref) => null);
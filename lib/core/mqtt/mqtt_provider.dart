import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/mqtt/mqtt_client.dart';
import 'package:spds/core/mqtt/mqtt_msg_handler.dart';
import 'package:spds/presentation/current/provider/provider.dart';
import 'package:spds/presentation/load_page/provider/provider_mqtt.dart';
import 'package:spds/presentation/header/provider/provider.dart';

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

final mqttHandlerProvider = Provider<MqttMessageHandler>((ref) {
  return MqttMessageHandler(
    ref.read(loadProvider.notifier),
    ref.read(phaseCurrentProvider.notifier),
    ref.read(balanceableProvider.notifier),
    ref.read(modeProvider.notifier),
    ref.read(statusProvider.notifier),
  );
});

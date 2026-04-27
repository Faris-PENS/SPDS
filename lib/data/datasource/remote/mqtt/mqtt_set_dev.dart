import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/topic_mqtt.dart';
import 'package:spds/core/mqtt/mqtt_client.dart';
import 'package:spds/core/mqtt/mqtt_provider.dart';
class SetDevice {
  final WidgetRef ref;

  SetDevice(this.ref);

  Future<void> setdev({
    required String hwid,
    required String clientid,
    void Function()? isReset,
  }) async {
    final mqttNotifier = ref.read(mqttProvider.notifier);
    final mqtt = ref.read(mqttProvider);
    final handler = ref.read(mqttHandlerProvider);
    final oldEsp = ref.read(currentEspProvider);

    final newTopics = MqttTopics.fromEspId(hwid);
    final oldTopics =
        oldEsp != null ? MqttTopics.fromEspId(oldEsp) : null;

    isReset?.call();

    if (mqtt != null) {
      try {
        mqtt.client.autoReconnect = false;

        mqtt.publish(oldTopics?.pubStatus ?? "", '{"status": 0}');

        mqtt.disconnect();
      } catch (_) {}

      mqttNotifier.clear();
    }
  
    final newMqtt = MqttClientCore(newTopics, handler);

    try {
      await newMqtt.connect(
        "4db5068a397f4f9bb1156a1fd4c038df.s1.eu.hivemq.cloud",
        clientid,
        8883,
      );

      newMqtt.client.autoReconnect = true;

      mqttNotifier.set(newMqtt);

      ref.read(currentEspProvider.notifier).state = hwid;

      print("MQTT CONNECTED");
    } catch (e) {
      mqttNotifier.clear();
      print("MQTT ERROR: $e");
      return;
    }

    for (final topic in newTopics.subscribeAll) {
      newMqtt.subscribe(topic);
    }
  }
}
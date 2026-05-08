import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/mqtt/mqtt_msg_handler.dart';
import 'package:spds/data/model/all_data.dart';
import 'package:spds/data/model/topic_mqtt.dart';
import 'package:spds/core/mqtt/mqtt_client.dart';
import 'package:spds/core/mqtt/mqtt_provider.dart';
import 'package:spds/presentation/header/provider/provider.dart';

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
    final oldEsp = ref.read(currentEspProvider);

    final newTopics = MqttTopics.fromEspId(hwid);
    final oldTopics = oldEsp != null ? MqttTopics.fromEspId(oldEsp) : null;

    isReset?.call();

    if (mqtt != null) {
      try {
        mqtt.client.autoReconnect = false;

        mqtt.publish(oldTopics?.pubStatus ?? "", '{"status": 0}');

        mqtt.disconnect();
      } catch (_) {}

      mqttNotifier.clear();
    }

    final newMqtt = MqttClientCore(newTopics);

    try {
      await newMqtt.connect(clientid);

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
    newMqtt.ensureUpdatesListener(ref.read(mqttHandlerProvider.notifier));

   
  }
}

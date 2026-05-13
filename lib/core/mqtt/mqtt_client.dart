import 'dart:async';
import 'dart:ffi';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:spds/data/model/topic_mqtt.dart';
import 'mqtt_msg_handler.dart';

class MqttClientCore {
  late MqttServerClient client;
  final MqttTopics topics;
  StreamSubscription? _updatesSubscription;
  Function()? onConnecting;
  MqttClientCore(this.topics);
  bool reconnect = false;
  Future<void> connect(String clientId) async {
    client = MqttServerClient('mqtt.vixmo.ai', clientId);
    client.port = 1885;
    // client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 10;
    client.autoReconnect = true;

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs('vixmo', 'vixmo123098*')
        .withWillTopic(topics.pubStatus)
        .withWillMessage('{"status": 0}')
        .withWillQos(MqttQos.exactlyOnce)
        // .keepAliveFor(3)
        .startClean();

    client.onConnected = () {
      publish(topics.pubStatus, '{"status": 1}');
      reconnect = false;
    };

    client.onAutoReconnect = () {
      if (onConnecting != null) {
        onConnecting!();
      }
      print("mqtt rec");
    };
    await client.connect();
  }

  void ensureUpdatesListener(MqttMessageHandlerNotifier read) {
    if (_updatesSubscription != null) return;

    final updates = client.updates;
    if (updates == null) return;

    _updatesSubscription = updates.listen((events) {
      for (final event in events) {
        final payload = event.payload;
        if (payload is! MqttPublishMessage) continue;

        final msg = MqttPublishPayload.bytesToStringAsString(
          payload.payload.message,
        );
        read.handle(msg);
      }
    });
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String payload, {bool retain = false}) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    client.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: retain,
    );
  }

  void disconnect() {
    _updatesSubscription?.cancel();
    _updatesSubscription = null;
    client.disconnect();
  }
}

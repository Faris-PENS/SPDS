import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:spds/data/model/topic_mqtt.dart';
import 'mqtt_msg_handler.dart';

class MqttClientCore {
  late MqttServerClient client;
  final MqttTopics topics;
  final MqttMessageHandler msgHandler;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
      _updatesSubscription;

  MqttClientCore(this.topics, this.msgHandler);

  Future<void> connect(String broker, String clientId, int port) async {

  
    client = MqttServerClient.withPort(broker, clientId, port);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 10;
    client.autoReconnect = true;

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs('Fariscoba', 'Faris123')
        .withWillTopic(topics.pubStatus)
        .withWillMessage('{"status": 0}')
        .withWillQos(MqttQos.exactlyOnce)
        .withWillRetain()
        // .keepAliveFor(3)
        .startClean();

    client.onConnected = () {
    publish(topics.pubStatus, '{"status": 1}');
    };

    client.onAutoReconnect = () {
      print("Auto reconnecting...");
    };
    await client.connect();

  }

  void _ensureUpdatesListener() {
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
        msgHandler.handle(msg);
      }
    });
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    _ensureUpdatesListener();
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
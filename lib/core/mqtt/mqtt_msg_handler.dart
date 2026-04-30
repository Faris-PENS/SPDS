import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/remote/mqtt/mqtt_parser.dart';
import '../../presentation/current/provider/provider.dart';
import '../../presentation/load_page/provider/provider_mqtt.dart';
import '../../presentation/header/provider/provider.dart';
import 'package:spds/data/model/all_data.dart';

class MqttMessageHandlerNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  int? _normalizeLoadIndex(int rawLoad) {
    final load = rawLoad > 0 ? rawLoad - 1 : rawLoad;
    if (load < 0 || load > 11) return null;
    return load;
  }

  void _applyLoadUpdate(LoadUpdate update) {
    final index = _normalizeLoadIndex(update.load);
    if (index == null) return;

    if (update.arus != null) {
      ref.read(loadProvider.notifier).update(index, arus: update.arus);
    }

    if (update.clearPhase) {
      ref.read(loadProvider.notifier).update(index, clearPhase: true);
    } else if (update.phase != null) {
      ref.read(loadProvider.notifier).update(index, phase: update.phase);
    }
  }


  void handle(String message)  {
    final msg = message.trim();
    print("RAW MQTT: $msg");

    final data = MqttParser.decode(msg);
    if (data == null) return;
    final mode = MqttParser.parseMode(data);
    if (mode != null) {
    ref.read(modeProvider.notifier).update(mode);
    }
    final status = MqttParser.parseStatus(data);
    if (status != null) {
      ref.read(statusProvider.notifier).update(status);
    }
    final balanceable = MqttParser.parseBalanceable(data);
    if (balanceable != null) {
    ref.read(balanceableProvider.notifier).update(balanceable.isBalanceable);
    }

    final bulkLoads = MqttParser.parseBulkLoads(data);
    for (final item in bulkLoads) {
      _applyLoadUpdate(item);
    }
    final phases = MqttParser.parsePhaseCurrents(data);
    if (phases.isNotEmpty) {
     ref.read(phaseCurrentProvider.notifier).updateFromMqtt(phases);
    }

    final singleLoad = MqttParser.parseSingleLoad(data);
    if (singleLoad != null) {
      _applyLoadUpdate(singleLoad);
    }
  }
}

final mqttHandlerProvider = NotifierProvider<MqttMessageHandlerNotifier, bool>(
  () => MqttMessageHandlerNotifier(),
);

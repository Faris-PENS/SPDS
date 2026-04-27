import '../../data/datasource/remote/mqtt/mqtt_parser.dart';
import '../../presentation/current/provider/provider.dart';
import '../../presentation/load_page/provider/provider_mqtt.dart';
import '../../presentation/header/provider/provider.dart';
import 'package:spds/data/model/all_data.dart';

class MqttMessageHandler {
  final LoadNotifier loadNotifier;
  final PhaseCurrentNotifier? phaseCurrentNotifier;
  final BalanceableNotifier? balanceableNotifier;
  final ModeNotifier modeNotifier;
  final StatusNotifier statusNotifier;

  MqttMessageHandler(
    this.loadNotifier,
    this.phaseCurrentNotifier,
    this.balanceableNotifier,
    this.modeNotifier,
    this.statusNotifier,
  );

  int? _normalizeLoadIndex(int rawLoad) {
    final load = rawLoad > 0 ? rawLoad - 1 : rawLoad;
    if (load < 0 || load > 11) return null;
    return load;
  }

  void _applyLoadUpdate(LoadUpdate update) {
    final index = _normalizeLoadIndex(update.load);
    if (index == null) return;

    if (update.arus != null) {
      loadNotifier.update(index, arus: update.arus);
    }

    if (update.clearPhase) {
      loadNotifier.update(index, clearPhase: true);
    } else if (update.phase != null) {
      loadNotifier.update(index, phase: update.phase);
    }
  }

  void handle(String message) {
    final msg = message.trim();
    print("RAW MQTT: $msg");

    final data = MqttParser.decode(msg);
    if (data == null) return;
    final mode = MqttParser.parseMode(data);
    if (mode != null) {
      modeNotifier.update(mode);
    }
    final status = MqttParser.parseStatus(data);
    if (status != null) {
      statusNotifier.update(status);
    }
    final balanceable = MqttParser.parseBalanceable(data);
    if (balanceable != null) {
      balanceableNotifier?.update(balanceable.isBalanceable);
    }
    final bulkLoads = MqttParser.parseBulkLoads(data);
    for (final item in bulkLoads) {
      _applyLoadUpdate(item);
    }

    final phases = MqttParser.parsePhaseCurrents(data);
    if (phases.isNotEmpty) {
      phaseCurrentNotifier?.updateFromMqtt(phases);
    }

    final singleLoad = MqttParser.parseSingleLoad(data);
    if (singleLoad != null) {
      _applyLoadUpdate(singleLoad);
    }
  }
}

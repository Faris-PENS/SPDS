import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';
import 'provider_database.dart';
import 'provider_mqtt.dart';

class LoadControlState {
  final int load;
  final String? selectedPhase;
  final bool isSendEnabled;

  const LoadControlState({
    required this.load,
    this.selectedPhase,
    this.isSendEnabled = false,
  });

  LoadControlState copyWith({
    String? selectedPhase,
    bool? isSendEnabled,
    bool clearPhase = false,
  }) {
    return LoadControlState(
      load: load,
      selectedPhase: clearPhase ? null : (selectedPhase ?? this.selectedPhase),
      isSendEnabled: isSendEnabled ?? this.isSendEnabled,
    );
  }
}

final loadControlProvider =
    StateNotifierProvider<LoadControlNotifier, List<LoadControlState>>(
      (ref) => LoadControlNotifier(),
    );

class LoadControlNotifier extends StateNotifier<List<LoadControlState>> {
  static const Set<String> _validPhases = {'R', 'S', 'T', 'U'};

  String? _normalizePhase(String? value) {
    final phase = value?.toUpperCase();
    if (phase == null || !_validPhases.contains(phase)) {
      return null;
    }
    return phase;
  }

  LoadControlNotifier()
    : super(List.generate(12, (i) => LoadControlState(load: i)));

  void syncFromMqtt(List<LoadParam> mqttLoads) {
    var hasChanges = false;

    final nextState = [
      for (final item in state)
        () {
          final mqttItem = mqttLoads.firstWhere(
            (e) => e.load == item.load,
            orElse: () => LoadParam(load: item.load),
          );

          final normalizedPhase = _normalizePhase(mqttItem.phase);

          final nextSelectedPhase = normalizedPhase ?? item.selectedPhase;
          final nextEnabled = normalizedPhase != null;

          if (item.selectedPhase == nextSelectedPhase &&
              item.isSendEnabled == nextEnabled) {
            return item;
          }

          hasChanges = true;
          return item.copyWith(
            selectedPhase: nextSelectedPhase,
            isSendEnabled: nextEnabled,
          );
        }(),
    ];

    if (hasChanges) {
      state = nextState;
    }
  }

  void setPhase(int load, String phase) {
    state = [
      for (final item in state)
        if (item.load == load)
          () {
            final nextPhase = phase.toUpperCase();
            final phaseChanged = item.selectedPhase?.toUpperCase() != nextPhase;

            return item.copyWith(
              selectedPhase: nextPhase,
              isSendEnabled: phaseChanged ? false : item.isSendEnabled,
            );
          }()
        else
          item,
    ];
  }

  void clearPhase(int load) {
    state = [
      for (final item in state)
        if (item.load == load)
          item.copyWith(clearPhase: true, isSendEnabled: false)
        else
          item,
    ];
  }

  void setSendEnabled(int load, bool enabled) {
    state = [
      for (final item in state)
        if (item.load == load) item.copyWith(isSendEnabled: enabled) else item,
    ];
  }

  void reset() {
    state = List.generate(12, (i) => LoadControlState(load: i));
  }
}

final loadCardProvider = Provider<List<LoadViewData>>((ref) {
  final db = ref.watch(loadDatabaseProvider);
  final mqtt = ref.watch(loadProvider);
  final control = ref.watch(loadControlProvider);

  return List.generate(12, (i) {
    final dbItem = db.firstWhere(
      (e) => e.load == i,
      orElse: () => LoadDatabase(
        load: i,
        name: "Load ${i + 1}",
        assetNum: "0000",
        type: 0,
        location: "N/A",
        maxAmps: 10,
      ),
    );

    final mqttItem = mqtt.firstWhere(
      (e) => e.load == i,
      orElse: () => LoadParam(load: i),
    );

    final controlItem = control.firstWhere(
      (e) => e.load == i,
      orElse: () => LoadControlState(load: i),
    );
    final displayPhase = controlItem.selectedPhase ?? mqttItem.phase;

    return LoadViewData(
      load: i,
      name: dbItem.name,
      assetNum: dbItem.assetNum,
      type: dbItem.type,
      location: dbItem.location,
      maxAmps: dbItem.maxAmps,
      arus: mqttItem.arus,
      phase: displayPhase ?? 'N',
    );
  });
});

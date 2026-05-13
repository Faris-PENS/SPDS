import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';

final modeProvider = StateNotifierProvider<ModeNotifier, ModeData?>(
  (ref) => ModeNotifier(),
);

class ModeNotifier extends StateNotifier<ModeData?> {
  ModeNotifier() : super(null);

  void update(ModeData? mode) {
    state = mode;
  }

  void reset() {
    state = ModeData(0);
  }
}

final statusProvider = StateNotifierProvider<StatusNotifier, ConnectionStatus?>(
  (ref) => StatusNotifier(),
);

class StatusNotifier extends StateNotifier<ConnectionStatus?> {
  StatusNotifier() : super(null);

  void update(ConnectionStatus? status) {
    state = status;
  }

  void reset() {
    state = ConnectionStatus(0);
  }
}

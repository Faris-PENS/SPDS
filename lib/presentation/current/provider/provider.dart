import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';

final phaseCurrentProvider =
    StateNotifierProvider<PhaseCurrentNotifier, List<PhaseData>>(
      (ref) => PhaseCurrentNotifier(),
    );

final balanceableProvider = StateNotifierProvider<BalanceableNotifier, bool>(
  (ref) => BalanceableNotifier(),
);

class PhaseCurrentNotifier extends StateNotifier<List<PhaseData>> {
  static const List<String> _phaseOrder = ['R', 'S', 'T', 'U'];

  PhaseCurrentNotifier()
    : super(_phaseOrder.map((phase) => PhaseData(phase, 0)).toList());

  void updateFromMqtt(List<PhaseData> phases) {
    if (phases.isEmpty) return;

    final nextByPhase = {
      for (final item in phases) item.phase.toUpperCase(): item.arus,
    };

    final currentByPhase = {
      for (final item in state) item.phase.toUpperCase(): item.arus,
    };

    state = [
      for (final phase in _phaseOrder)
        PhaseData(phase, nextByPhase[phase] ?? currentByPhase[phase] ?? 0),
    ];
  }

  void reset() {
    state = _phaseOrder.map((phase) => PhaseData(phase, 0)).toList();
  }
}

class BalanceableNotifier extends StateNotifier<bool> {
  BalanceableNotifier() : super(false);

  void update(bool value) {
    state = value;
  }

  void reset() {
    state = false;
  }
}

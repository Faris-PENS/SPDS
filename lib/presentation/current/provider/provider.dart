import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';
import 'package:spds/data/datasource/remote/supabase/device_supabase.dart';

final phaseCurrentProvider =
    StateNotifierProvider<PhaseCurrentNotifier, List<PhaseData>>(
      (ref) => PhaseCurrentNotifier(),
    );

final balanceableProvider = StateNotifierProvider<BalanceableNotifier, bool>(
  (ref) => BalanceableNotifier(),
);

final maxArusProvider =
    StateNotifierProvider<MaxArusNotifier, Map<String, double>>(
      (ref) => MaxArusNotifier(),
    );

class MaxArusNotifier extends StateNotifier<Map<String, double>> {
  MaxArusNotifier() : super({});

  final _remote = DeviceSupabase();

  Future<void> fetchData() async {
    final res = await _remote.fetchDeviceedit();

    if (res.isEmpty) return;

    final data = res.first;

    state = {
      'R': (data['ampsR'] ?? 0).toDouble(),
      'S': (data['ampsS'] ?? 0).toDouble(),
      'T': (data['ampsT'] ?? 0).toDouble(),
      'U': (data['ampsU'] ?? 0).toDouble(),
    };
  }

  void reset() {
    state = {};
  }
}

class PhaseCurrentNotifier extends StateNotifier<List<PhaseData>> {
  static const List<String> _phaseOrder = ['R', 'S', 'T', 'U'];

  PhaseCurrentNotifier()
    : super(_phaseOrder.map((e) => PhaseData(e, 0)).toList());

  void updateFromMqtt(List<PhaseData> phases) {
    if (phases.isEmpty) return;

    final next = {for (final e in phases) e.phase.toUpperCase(): e.arus};

    final current = {for (final e in state) e.phase.toUpperCase(): e.arus};

    state = [
      for (final p in _phaseOrder) PhaseData(p, next[p] ?? current[p] ?? 0),
    ];
  }

  void reset() {
    state = _phaseOrder.map((e) => PhaseData(e, 0)).toList();
  }
}

class BalanceableNotifier extends StateNotifier<bool> {
  BalanceableNotifier() : super(false);

  void update(bool v) {
    state = v;
  }

  void reset() {
    state = false;
  }
}

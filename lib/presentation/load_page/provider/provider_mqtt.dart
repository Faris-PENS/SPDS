import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';

final loadProvider =
    StateNotifierProvider<LoadNotifier, List<LoadParam>>(
  (ref) => LoadNotifier(),
);

class LoadNotifier extends StateNotifier<List<LoadParam>> {
  LoadNotifier() : super(List.generate(
      12,
      (i) => LoadParam(load: i),
    ));

  void update(int load, {double? arus, String? phase, bool clearPhase = false}) {
    state = [
      for (final item in state)
        if (item.load == load)
          LoadParam(
            load: load,
            arus: arus ?? item.arus,
            phase: clearPhase ? null : (phase ?? item.phase),
          )
        else
          item
    ];
  }

  void reset() {
    state = List.generate(12, (i) => LoadParam(load: i));
  }
}
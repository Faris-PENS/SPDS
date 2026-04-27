import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasource/remote/supabase/load_param_supabase.dart';
import '../../../data/domain/entities/result.dart';
import 'package:spds/core/exceptions.dart';

final loadParam =
    StateNotifierProvider<LoadParamNotifier, ResultState<bool>>((ref) {
  return LoadParamNotifier(LoadparamSupabase());
});

class LoadParamNotifier extends StateNotifier<ResultState<bool>> {
  final LoadparamSupabase _remote;

  LoadParamNotifier(this._remote) : super(const ResultState.init());

  Future<void> updateLoad(int index, int type, String name, String assetNum, String location, int maxAmps) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.updateLoad(loadIndex: index, type: type, name: name, Assetnumber: assetNum, Location: location, maxAmps: maxAmps);

      if (success) {


        state = const ResultState.success(true);
      } else {
        state = ResultState.error(AppCustomException('Failed'));
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException(errorMessage));
    }
  }

  void reset() {
    state = const ResultState.init();
  }
}
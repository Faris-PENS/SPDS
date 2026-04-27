import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/data/datasource/remote/supabase/share_dev_supabase.dart';


final sharedDeviceProvider =
    StateNotifierProvider<SharedDeviceNotifier, ResultState<List<Map<String, dynamic>>>>(
        (ref) {
  return SharedDeviceNotifier(SharedevSupabase());
});

class SharedDeviceNotifier
    extends StateNotifier<ResultState<List<Map<String, dynamic>>>> {
  final SharedevSupabase _remote;

  SharedDeviceNotifier(this._remote)
      : super(const ResultState.init());
    
    

  Future<void> getShared() async {
    state = const ResultState.loading();

    try {
      final data = await _remote.fetchSharedDevice();

      state = ResultState.success(data);
    } catch (e) {
      state = ResultState.error(Exception(e.toString()));
    }
  }


}
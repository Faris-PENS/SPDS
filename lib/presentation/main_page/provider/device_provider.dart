import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/data/datasource/remote/supabase/device_supabase.dart';

final deviceProvider =
    StateNotifierProvider<DeviceNotifier, ResultState<List<Map<String, dynamic>>>>(
        (ref) {
  return DeviceNotifier(DeviceSupabase());
});

class DeviceNotifier
    extends StateNotifier<ResultState<List<Map<String, dynamic>>>> {
  final DeviceSupabase _remote;

  DeviceNotifier(this._remote) : super(const ResultState.init());

  Future<void> getDevices() async {
    state = const ResultState.loading();

    try {
      final data = await _remote.fetchDevice();

      state = ResultState.success(data);
    } catch (e) {
      state = ResultState.error(Exception(e.toString()));
    }
  }

}
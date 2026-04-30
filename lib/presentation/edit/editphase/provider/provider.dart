import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/core/exceptions.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/data/datasource/remote/supabase/device_supabase.dart';

final updateProvider =
    StateNotifierProvider<updatePhase, ResultState<bool>>((ref) {
  return updatePhase(DeviceSupabase());
});

class updatePhase extends StateNotifier<ResultState<bool>> {
  final DeviceSupabase _remote;

  updatePhase(this._remote) : super(const ResultState.init());

  Future<void> editphase(
      String hwid,
      String place,
      double ampsR,
      double ampsS,
      double ampsT,
      double ampsU) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.updateDevice(
        hwid: hwid,
        location: place,
        ampsR: ampsR,
        ampsS: ampsS,
        ampsT: ampsT,
        ampsU: ampsU,
      );

      if (success) {
        state = const ResultState.success(true);
      } else {
        state = ResultState.error(
            AppCustomException('FAILED_TO_UPDATE_DEVICE'));
      }
    } catch (e) {
      state = ResultState.error(AppCustomException(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> fetchDevice() async {
    try {
      final device = await _remote.fetchDeviceedit();
      if (device.isNotEmpty) {
        return device.first;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
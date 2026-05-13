import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/remote/supabase/device_supabase.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/core/exceptions.dart';

final newDeviceProvider =
    StateNotifierProvider<registerDevice, ResultState<bool>>((ref) {
      return registerDevice(DeviceSupabase());
    });

class registerDevice extends StateNotifier<ResultState<bool>> {
  final DeviceSupabase _remote;

  registerDevice(this._remote) : super(const ResultState.init());

  Future<void> isRegistered(String hwid) async {
    state = const ResultState.loading();

    try {
      final shared = await _remote.isRegistered(hwid: hwid);
      if (shared) {
        state = ResultState.success(true);
      } else {
        state = ResultState.error(AppCustomException('DEVICE_NOT_SHARED'));
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException('errorMessage'));
    }
  }

  Future<void> registerDevices(
    String hwid,
    String place,
    double ampsR,
    double ampsS,
    double ampsT,
    double ampsU,
  ) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.registerDevice(
        hwid: hwid,
        place: place,
        ampsR: ampsR,
        ampsS: ampsS,
        ampsT: ampsT,
        ampsU: ampsU,
      );

      if (success) {
        state = const ResultState.success(true);
      } else {
        state = ResultState.error(AppCustomException('FAILED_TO_SHARE_DEVICE'));
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException(errorMessage));
    }
  }
}

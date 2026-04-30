import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/remote/supabase/share_dev_supabase.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/core/exceptions.dart';
final shareDeviceProvider =
    StateNotifierProvider<ShareDeviceNotifier, ResultState<bool>>((ref) {
  return ShareDeviceNotifier(SharedevSupabase());
});

class ShareDeviceNotifier extends StateNotifier<ResultState<bool>> {
  final SharedevSupabase _remote;

  ShareDeviceNotifier(this._remote) : super(const ResultState.init());


  Future<void> isRegistered(String hwid) async {
    state = const ResultState.loading();

    try {
      final shared = await _remote.isRegistered(hwid: hwid);
      if (shared) {
        state =  ResultState.success(true);
      } else {
        state =  ResultState.error(AppCustomException('DEVICE_NOT_SHARED') );
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException('errorMessage'));
    }
}


  Future<void> isShared(String hwid) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.isShared(hwid: hwid);

      if (success) {
        state = const ResultState.success(true);
      } else {
        state =  ResultState.error(AppCustomException('FAILED_TO_SHARE_DEVICE'));
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException(errorMessage));
    }
  }
}
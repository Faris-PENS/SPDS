import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'package:spds/data/datasource/remote/AP/ESP/Esp_connect.dart';
import 'package:spds/core/exceptions.dart';
final pairWifiProvider =
    StateNotifierProvider<PairWifiNotifier, ResultState<bool>>((ref) {
  final ds = ref.read(apNotifierProvider.notifier);
  return PairWifiNotifier(ds);
});

class PairWifiNotifier extends StateNotifier<ResultState<bool>> {
  final ApNotifier ds;

  PairWifiNotifier(this.ds) : super(const ResultState.init());

  Future<void> pairWifi(String ssid, String password) async {
  state = const ResultState.loading();

  try {
    final sendOk = await ds.sendCredential(ssid, password);
    if (!sendOk) {
      state = ResultState.error(
        AppCustomException('FAILED_TO_SEND_CREDENTIALS'),
      );
      return;
    }

    String? status;
    const timeout = Duration(seconds: 20);
    final start = DateTime.now();

    while (DateTime.now().difference(start) < timeout) {
      await Future.delayed(const Duration(seconds: 2));

      status = await ds.statusEsp();

      if (status == "connected") {
        break;
      }

      if (status == "not_connected") {
        state = ResultState.error(
          AppCustomException('WIFI_NOT_CONNECTED'),
        );
        return;
      }
    }

    if (status != "connected") {
      state = ResultState.error(
        AppCustomException('TIMEOUT_CONNECTION'),
      );
      return;
    }

    final confirmOk = await ds.konfirmasiKonek();
    if (confirmOk) {
      state = ResultState.success(true);
    } else {
      state = ResultState.error(
        AppCustomException('FAILED_CONFIRM'),
      );
    }

  } catch (e) {
    state = ResultState.error(AppCustomException(e.toString()));
  }
}
}
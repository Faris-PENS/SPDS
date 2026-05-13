import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/data/model/all_data.dart';
import 'package:spds/data/datasource/remote/supabase/load_param_supabase.dart';

final loadDatabaseProvider =
    StateNotifierProvider<LoadDatabaseNotifier, List<LoadDatabase>>(
      (ref) => LoadDatabaseNotifier(LoadparamSupabase()),
    );

class LoadDatabaseNotifier extends StateNotifier<List<LoadDatabase>> {
  final LoadparamSupabase _remote;

  LoadDatabaseNotifier(this._remote) : super([]);

  Future<void> fetch() async {
    final data = await _remote.fetchLoads();

    state = data.map<LoadDatabase>((e) {
      final index = (e['loadIndex'] ?? 1) - 1;

      return LoadDatabase(
        load: index,
        name: e['name'] ?? "Load ${index + 1}",
        assetNum: e['assetNum'] ?? "0000",
        type: e['type'] ?? 0,
        location: e['location'] ?? "N/A",
        maxAmps: e['maxAmps'] ?? 10,
        cutoff: e['cutoff'] ?? false,
        pushNotification: e['notif'] ?? false,
      );
    }).toList();
  }

  void reset() {
    state = [];
  }
}

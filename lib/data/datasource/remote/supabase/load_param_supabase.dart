import 'package:flutter/material.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadparamSupabase {
  final SupabaseClient _client = SupabaseInit.client;
  Future<List<Map<String, dynamic>>> fetchLoads() async {
    try {
      final esp = await LocalSession.loadSessiondevice();
      // print("RAW SUPABASE: $esp");
      if (esp == null) return [];
      final res = await _client
          .from('loadAssets')
          .select()
          .eq('HWID', esp)
          .order('loadIndex');
      print("RAW SUPABASE: $res");
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("FETCH LOAD ERROR: $e");
      return [];
    }
  }

  Future<bool> updateLoad({
    required int loadIndex,
    required int type,
    required String name,
    required String Assetnumber,
    required String Location,
    required int maxAmps,
    required bool autoCutoff,
    required bool pushNotification,
  }) async {
    try {
      final esp = await LocalSession.loadSessiondevice();

      if (esp == null) {
        return false;
      }

      final res = await _client
          .from('loadAssets')
          .update({
            'type': type,
            'name': name,
            'assetNum': Assetnumber,
            'location': Location,
            'maxAmps': maxAmps,
            'cutoff': autoCutoff,
            'notif': pushNotification,
          })
          .eq('HWID', esp)
          .eq('loadIndex', loadIndex)
          .select();
      print("updateLoad response: $res");

      if (res.isEmpty) {
        debugPrint("gagal");
        return true;
      } else {
        debugPrint("Load updated");
      }
      return true;
    } catch (e) {
      debugPrint("updateLoad error: $e");
      return false;
    }
  }
}

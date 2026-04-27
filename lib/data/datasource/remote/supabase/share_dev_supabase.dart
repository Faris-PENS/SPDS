import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/data/datasource/local/session.dart';

class SharedevSupabase {
  final SupabaseClient _client = SupabaseInit.client;

  Future<bool> deleteSharedDevice({required String hwid}) async {
    try {
      final username = await LocalSession.loadSessionuser();
      if (username == null) return true;

      final user = await _client
          .from('user')
          .select('id')
          .eq('user', username)
          .maybeSingle();

      if (user == null) {
        debugPrint("User tidak ditemukan");
        return true;
      }

      final res = await _client
          .from('DeviceHW')
          .select('id')
          .eq('HWID', hwid)
          .maybeSingle();
      if (res == null) {
        debugPrint("Device tidak ditemukan");
        return true;
      }

      final userId = user['id'];
      final deviceId = res['id'];

      await _client
          .from('sharedev')
          .delete()
          .eq('device_id', deviceId)
          .eq('user_id', userId);

      debugPrint("shared device deleted");
      return false;
    } catch (e) {
      debugPrint("deleteSharedDevice error: $e");
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSharedDevice() async {
    try {
      final username = await LocalSession.loadSessionuser();

      if (username == null) return [];  

      final user = await _client
          .from('user')
          .select('id')
          .eq('user', username)
          .maybeSingle();

      if (user == null) return [];

      final res = await _client
          .from('sharedev')
          .select('DeviceHW(HWID,tempat)')
          .eq('user_id', user['id']);

      final List<Map<String, dynamic>> devices = [];

      for (var item in res) {
        final dev = item['DeviceHW'];
        if (dev != null) {
          devices.add({'HWID': dev['HWID'], 'tempat': dev['tempat']});
        }
      }

      return devices;
    } catch (e) {
      debugPrint('fetchSharedDevice error: $e');
      return [];
    }
  }
}
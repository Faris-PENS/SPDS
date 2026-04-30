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

    
      final res = await _client
          .from('DeviceHW')
          .select('id')
          .eq('HWID', hwid)
          .maybeSingle();
      if (res == null) {
        debugPrint("Device tidak ditemukan");
        return true;
      }

      final deviceId = res['id'];

      await _client
          .from('sharedev')
          .delete()
          .eq('HWID', deviceId)
          .eq('user_id', username);

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

      final res = await _client
          .from('sharedev')
          .select('DeviceHW(HWID,tempat)')
          .eq('user_id', username);

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

  Future<bool> isRegistered({required String hwid}) async {
    try {
      final username = await LocalSession.loadSessionuser();
      if (username == null) return true;

      final device = await _client
          .from('DeviceHW')
          .select('id')
          .eq('HWID', hwid)
          .maybeSingle();

      if (device == null) {
        debugPrint("Device tidak ditemukan");
        return false;
      }
    
      return true;
    } catch (e) {
      debugPrint("isShared error: $e");
      return false;
    }
  }


  Future<bool> isShared({required String hwid}) async {
    try {
      final username = await LocalSession.loadSessionuser();
      if (username == null) return true;

      final device = await _client
          .from('DeviceHW')
          .select('id')
          .eq('HWID', hwid)
          .maybeSingle();

      if (device == null) {
        print("Device tidak ditemukans");
        return false;
      }
      final deviceId = device['id'];
      print(  "deviceawdawdawdawdwadawdawdId: $deviceId, username: $username");

      final checkowner = await _client
    .from('DeviceHW')
    .select()
    .eq('id', deviceId) 
    .maybeSingle();

    if (checkowner == null) {
      return false;
    }

    final shared = await _client
    .from('sharedev')
    .select()
    .eq('HWID', deviceId)
    .eq('user_id', username)
    .maybeSingle();

    if (shared != null) {
  return true;
}


  await _client.from('sharedev').insert({
    'HWID': deviceId,
    'user_id': username,
  });

return false;
   
    } catch (e) {
      debugPrint("isShared error: $e");
      return true;
    }
  }



}
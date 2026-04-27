import 'package:flutter/material.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/data/datasource/local/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceSupabase {
final SupabaseClient _client = SupabaseInit.client;


  Future<bool> deleteHWID({required String userdevice}) async {
    try {
      final userid = await LocalSession.loadSessionuser();

      if (userid == null) {
        debugPrint('DELETE FAILED: no session');
        return false;
      }

      final res = await _client
          .from('DeviceHW')
          .delete()
          .eq('user', userid)
          .eq('HWID', userdevice)
          .maybeSingle();

      if (res == null) {
        debugPrint('DELETE FAILED: device not found / not owned');
        return false;
      }

      debugPrint('DELETE SUCCESS: ${res['HWID']}');
      return true;
    } catch (e) {
      debugPrint('deleteHWID error: $e');
      return false;
    }
  }


Future<List<Map<String, dynamic>>> fetchDevice() async {
  final userdevice = await LocalSession.loadSessionuser();
  if (userdevice == null) {
    debugPrint('FETCH FAILED: no session');
    return [];
  }
    try {
      final res = await _client
          .from('DeviceHW')
          .select()
          .eq('user', userdevice);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("FETCH DEVICE ERROR: $e");
      return [];
    }
  }

  Future<bool> isRegistered({required String userdevice,required String place}) async {
    try {
      final userid = await LocalSession.loadSessionuser();
      if (userid == null) {
        return true;
      }

      final res = await _client
          .from('DeviceHW')
          .select('id')
          .eq('HWID', userdevice)
          .maybeSingle();
      if (res != null) {
        debugPrint('device already registered');
        return true;
      }
      await _client.from('DeviceHW').insert({
        'HWID': userdevice,
        'user': userid,
        'tempat': place,
      });

      debugPrint('device inserted');
      return false;
    } catch (e) {
      debugPrint('ensureRegistered error: $e');
      return true;
    }
  }

}
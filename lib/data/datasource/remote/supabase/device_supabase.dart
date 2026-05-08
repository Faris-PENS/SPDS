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

  Future<List<Map<String, dynamic>>> fetchDeviceedit() async {
  final userdevice = await LocalSession.loadSessionuser();
  if (userdevice == null) {
    debugPrint('FETCH FAILED: no session');
    return [];
  }

  final esp = await LocalSession.loadSessiondevice();
  if (esp == null) {
    debugPrint('FETCH FAILED: no device session');
    return [];
  }
    try {
      final res = await _client
          .from('DeviceHW')
          .select()
          // .eq('user', userdevice)
          .eq('HWID', esp);
                 print("FETCH UPDATE DEVICE RESPONSE: $res");
      return List<Map<String, dynamic>>.from(res);
  
    } catch (e) {
      debugPrint("FETCH DEVICE ERROR: $e");
      return [];
    }
  }

  Future<bool> isRegistered({required String hwid}) async {
    try {
   
      final res = await _client
          .from('DeviceHW')
          .select()
          .eq('HWID', hwid)
          .maybeSingle();
      if (res != null) {
        debugPrint('device already registered');
        return true;
      }
      else{
        return false;
      } 
     
    } catch (e) {
      debugPrint('ensureRegistered error: $e');
      return false;
    }
  }

Future<bool> registerDevice({required String hwid, required String place, required double ampsR, required double ampsS, required double ampsT, required double ampsU}) async {
    try {
      final userid = await LocalSession.loadSessionuser();
      if (userid == null) {
        return false;
      }

      final res = await _client
          .from('DeviceHW')
          .insert({
            'user': userid,
            'HWID': hwid,
            'tempat': place,
            'ampsR': ampsR,
            'ampsS': ampsS,
            'ampsT': ampsT,
            'ampsU': ampsU,
          })
          .select(); 
          print(  "REGISTER DEVICE RESPONSE: $res");

      // if (res == null) {
      //   return false;
      // }
      return true;
    } catch (e) {
      debugPrint('registerDevice error: $e');
      return false;
    }
  }


  Future<bool> updateDevice({required String hwid, required String location, required double ampsR, required double ampsS, required double ampsT, required double ampsU}) async {
    try {
      final userid = await LocalSession.loadSessionuser();
      if (userid == null) {
        return false;
      }

      final res = await _client
          .from('DeviceHW')
          .update({
          'tempat': location,
          'ampsR': ampsR,
          'ampsS': ampsS,
          'ampsT': ampsT,
          'ampsU': ampsU,
          })
          .eq('user', userid)
          .eq('HWID', hwid)
          .select();
        print(  "UPDATE DEVICE RESPONSE: $res");
   
      return true;
    } catch (e) {
      debugPrint('updateDevice error: $e');
      return false;
    }}


}
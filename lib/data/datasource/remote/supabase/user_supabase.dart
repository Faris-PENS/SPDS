import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/data/datasource/local/session.dart';

class UserRemoteDatasource {
  final SupabaseClient _client = SupabaseInit.client;

  Future<bool> login(String user, String pass) async {
    try {
      final res = await _client
          .from('user')
          .select('user')
          .eq('user', user)
          .eq('pass', pass)
          .maybeSingle();

      return res != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> insertUser({
    required String user,
    required String password,
  }) async {
    try {
      final check = await _client
          .from('user')
          .select('user')
          .eq('user', user)
          .maybeSingle();

      if (check != null) {
        return false;
      }

      await _client.from('user').insert({'user': user, 'pass': password});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    try {
      final userid = await LocalSession.loadSessionuser();

      if (userid == null) {
        return "NO_SESSION";
      }

      final res = await _client
          .from('user')
          .select('user')
          .eq('user', userid)
          .eq('pass', oldPassword)
          .maybeSingle();

      if (res == null) {
        return "WRONG_PASSWORD";
      }

      await _client
          .from('user')
          .update({'pass': newPassword})
          .eq('user', userid);

      return "SUCCESS";
    } catch (e) {
      return "FAILED: $e";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/data/datasource/local/session.dart';

class TokenSupabase {
  final SupabaseClient _client = SupabaseInit.client;

  Future<void> saveToken(String token) async {
    try {
      final username = await LocalSession.loadSessionuser();
      if (username == null) return;
      final user = await _client
          .from('user')
          .select('id')
          .eq('user', username)
          .maybeSingle();
      if (user == null) {
        debugPrint("User tidak ditemukan");
        return;
      }

      await _client.from('user_tokens').upsert({
        'user_id': user['id'],
        'fcm_token': token,
      });

      debugPrint("Token saved to database");
    } catch (e) {
      debugPrint("Error saving token: $e");
    }
  }

}
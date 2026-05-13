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

      await _client.from('user_token').upsert({
        'user': username,
        'fcm_token': token,
      });

      debugPrint("Token saved to database");
    } catch (e) {
      debugPrint("Error saving token: $e");
    }
  }
  
}
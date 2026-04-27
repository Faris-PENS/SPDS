import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInit {
  SupabaseInit._();

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://rcvbwyvnnuurudizkuec.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJjdmJ3eXZubnV1cnVkaXprdWVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxOTgzNDksImV4cCI6MjA3Mzc3NDM0OX0.YCXPxFi7IQvWKN16soE0-YA_mziN9uN2B1wYkOfuhrc',
      postgrestOptions: const PostgrestClientOptions(schema: 'KP'),
    );
  }
     static SupabaseClient get client => Supabase.instance.client;
}
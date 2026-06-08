import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // SUBSTITUA ESTES VALORES PELOS SEUS DO SUPABASE
  static const String _url = 'https://frgolnqnefirjyesluwx.supabase.co';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZyZ29sbnFuZWZpcmp5ZXNsdXd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4ODkyNTgsImV4cCI6MjA5NjQ2NTI1OH0.UQhZrW4ez3GOHpd4z3lzu-vIt6TJx08mco0HPARO9tY';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
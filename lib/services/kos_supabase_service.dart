import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/saved_kos_model.dart';

class KosSupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // READ (SELECT)
  Future<List<SavedKos>> getSavedKosList() async {
    final response = await _client
        .from('saved_kos')
        .select()
        .order('id', ascending: false);

    return (response as List<dynamic>)
        .map((json) => SavedKos.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // CREATE (INSERT)
  Future<SavedKos> insertSavedKos(SavedKos item) async {
    final response = await _client
        .from('saved_kos')
        .insert(item.toJson())
        .select()
        .single();

    return SavedKos.fromJson(response);
  }

  // UPDATE
  Future<void> updateSavedKos(int id, SavedKos item) async {
    await _client
        .from('saved_kos')
        .update(item.toJson())
        .eq('id', id);
  }

  // DELETE
  Future<void> deleteSavedKos(int id) async {
    await _client
        .from('saved_kos')
        .delete()
        .eq('id', id);
  }
}
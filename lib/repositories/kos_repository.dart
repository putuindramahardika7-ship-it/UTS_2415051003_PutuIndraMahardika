import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../services/kos_api_service.dart';
import '../services/kos_supabase_service.dart';

class KosRepository {
  final KosApiService apiService;
  final KosSupabaseService supabaseService;

  KosRepository({
    required this.apiService,
    required this.supabaseService,
  });

  // REST API Methods
  Future<List<Kos>> fetchCatalog() => apiService.fetchKosCatalog();

  // Supabase Database Methods
  Future<List<SavedKos>> fetchSavedKos() => supabaseService.getSavedKosList();
  Future<SavedKos> addSavedKos(SavedKos item) => supabaseService.insertSavedKos(item);
  Future<void> updateSavedKos(int id, SavedKos item) => supabaseService.updateSavedKos(id, item);
  Future<void> deleteSavedKos(int id) => supabaseService.deleteSavedKos(id);
}
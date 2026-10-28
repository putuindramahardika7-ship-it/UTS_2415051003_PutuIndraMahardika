import 'package:flutter/material.dart';
import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../repositories/kos_repository.dart';

class KosProvider extends ChangeNotifier {
  final KosRepository repository;

  KosProvider(this.repository);

  // States
  List<Kos> _catalog = [];
  List<SavedKos> _savedKosList = [];
  bool _isLoadingCatalog = false;
  bool _isLoadingSaved = false;
  bool _isSaving = false;
  String? _catalogError;
  String? _savedError;

  // Filter & Search States
  String _searchQuery = '';
  String _selectedStatus = 'all';

  // Getters
  List<Kos> get catalog => _catalog;
  List<SavedKos> get savedKosList => _savedKosList;
  bool get isLoadingCatalog => _isLoadingCatalog;
  bool get isLoadingSaved => _isLoadingSaved;
  bool get isSaving => _isSaving;
  String? get catalogError => _catalogError;
  String? get savedError => _savedError;
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;

  // Total Favorite Count & Status Analytics
  int get favoriteCount => _savedKosList.length;
  int get visitedCount => _savedKosList.where((k) => k.status == 'visited').length;
  int get dealCount => _savedKosList.where((k) => k.status == 'deal').length;

  // Filtered Catalog
  List<Kos> get filteredCatalog {
    return _catalog.where((kos) {
      final matchesSearch = kos.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kos.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  // Filtered Saved Kos
  List<SavedKos> get filteredSavedKos {
    return _savedKosList.where((item) {
      final matchesStatus = _selectedStatus == 'all' || item.status == _selectedStatus;
      return matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Fetch REST API Catalog
  Future<void> loadCatalog() async {
    _isLoadingCatalog = true;
    _catalogError = null;
    notifyListeners();

    try {
      _catalog = await repository.fetchCatalog();
    } catch (e) {
      _catalogError = e.toString();
    } finally {
      _isLoadingCatalog = false;
      notifyListeners();
    }
  }

  // Fetch Supabase Saved Kos
  Future<void> loadSavedKos() async {
    _isLoadingSaved = true;
    _savedError = null;
    notifyListeners();

    try {
      _savedKosList = await repository.fetchSavedKos();
    } catch (e) {
      _savedError = e.toString();
    } finally {
      _isLoadingSaved = false;
      notifyListeners();
    }
  }

  // Add (Create)
  Future<bool> addSavedKos(SavedKos item) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.addSavedKos(item);
      await loadSavedKos();
      return true;
    } catch (e) {
      _savedError = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Update
  Future<bool> updateSavedKos(int id, SavedKos item) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.updateSavedKos(id, item);
      await loadSavedKos();
      return true;
    } catch (e) {
      _savedError = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Delete
  Future<bool> deleteSavedKos(int id) async {
    try {
      await repository.deleteSavedKos(id);
      await loadSavedKos();
      return true;
    } catch (e) {
      _savedError = e.toString();
      return false;
    }
  }
}

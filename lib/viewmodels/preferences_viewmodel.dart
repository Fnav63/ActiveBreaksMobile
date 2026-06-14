import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class PreferencesViewModel extends ChangeNotifier {
  final StorageService _storageService;

  PreferencesViewModel({required StorageService storageService})
      : _storageService = storageService;

  List<String> _selectedCategories = [];
  bool _isLoading = true;

  List<String> get selectedCategories => _selectedCategories;
  bool get isLoading => _isLoading;

  static const List<String> allCategories = [
    'Cuello',
    'Hombros',
    'Espalda',
    'Visual',
    'Muñecas',
  ];

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    _selectedCategories = await _storageService.getSelectedCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleCategory(String category) async {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.clear();
      _selectedCategories.add(category);
    }
    
    await _storageService.saveSelectedCategories(_selectedCategories);
    notifyListeners();
  }
}
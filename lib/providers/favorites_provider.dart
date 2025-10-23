import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;

  // Agrega o quita película de favoritos
  void toggleFavorite(dynamic movie) {
    if (_favorites.contains(movie)) {
      _favorites.remove(movie);
    } else {
      _favorites.add(movie);
    }
    notifyListeners();
  }
}

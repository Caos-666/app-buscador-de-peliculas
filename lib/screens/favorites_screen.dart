import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas Favoritas"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No tienes películas favoritas aún",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = favorites[index];
                  final poster = movie['poster_path'] != null
                      ? "https://image.tmdb.org/t/p/w500${movie['poster_path']}"
                      : null;

                  return Stack(
                    children: [
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Imagen de la película
                            Expanded(
                              child: poster != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        poster,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.movie,
                                      size: 80, color: Colors.white70),
                            ),
                            // Título y fecha
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'] ?? 'Sin título',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie['release_date'] ?? 'Sin fecha',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón eliminar en la esquina superior derecha
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => favoritesProvider.toggleFavorite(movie),
                            tooltip: "Eliminar de favoritos",
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

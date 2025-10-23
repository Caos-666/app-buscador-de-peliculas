import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/movie_service.dart';
import '../providers/favorites_provider.dart';
import 'details_screen.dart';

class ResultsScreen extends StatefulWidget {
  final String query;
  final int? genreId;
  const ResultsScreen({super.key, required this.query, this.genreId});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = _movieService.searchMovies(widget.query, genreId: widget.genreId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultados: ${widget.query}")),
      body: FutureBuilder<List<dynamic>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar películas"));
          }

          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text("No se encontraron películas"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final poster = movie['poster_path'] != null
                  ? "https://image.tmdb.org/t/p/w500${movie['poster_path']}"
                  : null;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: poster != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(poster, width: 60, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.movie, size: 60, color: Colors.white70),
                  title: Text(
                    movie['title'] ?? 'Sin título',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(movie['release_date'] ?? 'Sin fecha'),
                  trailing: Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, _) {
                      final isFavorite = favoritesProvider.favorites.contains(movie);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => favoritesProvider.toggleFavorite(movie),
                        tooltip: isFavorite ? "Quitar de favoritos" : "Agregar a favoritos",
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailsScreen(movie: movie)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

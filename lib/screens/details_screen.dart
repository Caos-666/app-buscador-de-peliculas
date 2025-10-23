import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/movie_service.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final MovieService _movieService = MovieService();
  String? trailerKey;
  bool loadingTrailer = true;

  @override
  void initState() {
    super.initState();
    _loadTrailer();
  }

  void _loadTrailer() async {
    try {
      final key = await _movieService.getMovieTrailer(widget.movie['id']);
      setState(() {
        trailerKey = key;
        loadingTrailer = false;
      });
    } catch (e) {
      setState(() {
        trailerKey = null;
        loadingTrailer = false;
      });
    }
  }

  void _launchTrailer() async {
    if (trailerKey == null) return;
    final url = "https://www.youtube.com/watch?v=$trailerKey";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el tráiler")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final poster = widget.movie['poster_path'] != null
        ? "https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}"
        : null;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.favorites.contains(widget.movie);

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie['title'] ?? "Detalles")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            poster != null
                ? Image.network(poster, height: 300, fit: BoxFit.cover)
                : const Icon(Icons.movie, size: 200, color: Colors.white70),
            const SizedBox(height: 16),
            Text(widget.movie['title'] ?? 'Sin título', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Fecha de estreno: ${widget.movie['release_date'] ?? 'Desconocida'}"),
            const SizedBox(height: 8),
            Text(widget.movie['overview'] ?? "Sin descripción", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isFavorite
                  ? () => favoritesProvider.toggleFavorite(widget.movie)
                  : () => favoritesProvider.toggleFavorite(widget.movie),
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(isFavorite ? "Quitar de favoritos" : "Agregar a favoritos"),
            ),
            const SizedBox(height: 16),
            loadingTrailer
                ? const Center(child: CircularProgressIndicator())
                : trailerKey != null
                    ? ElevatedButton.icon(
                        onPressed: _launchTrailer,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Ver Tráiler"),
                      )
                    : const Text("No hay tráiler disponible"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'results_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  int? _selectedGenre;
  final Map<int, String> genres = {
    28: "Acción",
    12: "Aventura",
    16: "Animación",
    35: "Comedia",
    80: "Crimen",
    18: "Drama",
    27: "Terror",
  };

  void _search() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El campo de búsqueda no puede estar vacío")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          query: _controller.text,
          genreId: _selectedGenre,
        ),
      ),
    );
  }

  void _goToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscador de Películas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _goToFavorites,
            tooltip: "Favoritos",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Buscar película...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<int>(
              value: _selectedGenre,
              hint: const Text("Selecciona categoría", style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.grey[900],
              items: genres.entries
                  .map((e) => DropdownMenuItem<int>(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: const Text("Buscar"),
            ),
          ],
        ),
      ),
    );
  }
}

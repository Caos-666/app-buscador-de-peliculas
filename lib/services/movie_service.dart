import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = "40e93c6db335ac296349ed74698ca6b9";
  final String baseUrl = "https://api.themoviedb.org/3";

  // Busca películas por texto y optional filtro por género
  Future<List<dynamic>> searchMovies(String query, {int? genreId}) async {
    String urlStr = "$baseUrl/search/movie?api_key=$apiKey&query=$query&language=es-ES";
    if (genreId != null) {
      urlStr += "&with_genres=$genreId";
    }
    final url = Uri.parse(urlStr);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception("Error al buscar películas: ${response.statusCode}");
    }
  }

  // Obtener trailer de YouTube de una película
  Future<String?> getMovieTrailer(int movieId) async {
    final url = Uri.parse("$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=es-ES");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final trailers = data['results'] as List<dynamic>;
      final youtubeTrailer = trailers.firstWhere(
        (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
        orElse: () => null,
      );
      return youtubeTrailer != null ? youtubeTrailer['key'] : null;
    } else {
      throw Exception("Error al obtener tráiler");
    }
  }
}

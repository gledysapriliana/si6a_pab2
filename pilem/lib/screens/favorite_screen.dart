import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_screen.dart';

// FavoriteScreen menggunakan StatefulWidget karena data favorit bisa berubah
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  // List untuk menyimpan film favorit
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    // Muat data favorit saat screen pertama kali dibuka
    _loadFavorites();
  }

  // Fungsi untuk memuat data favorit dari SharedPreferences
  Future<void> _loadFavorites() async {
    // Mendapatkan instance SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil list string JSON dari key 'favorites', atau list kosong jika belum ada
    final List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

    // Konversi setiap string JSON menjadi objek Movie
    setState(() {
      _favoriteMovies = favoritesJson
          .map((jsonStr) => Movie.fromJson(json.decode(jsonStr)))
          .toList();
    });
  }

  // Fungsi untuk menghapus film dari favorit
  Future<void> _removeFavorite(int movieId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

    // Hapus film yang memiliki id yang sama
    favoritesJson.removeWhere((jsonStr) {
      final Map<String, dynamic> movieMap = json.decode(jsonStr);
      return movieMap['id'] == movieId;
    });

    // Simpan kembali list yang sudah diupdate
    await prefs.setStringList('favorites', favoritesJson);

    // Muat ulang data favorit untuk update UI
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film Favorit')),
      body: _favoriteMovies.isEmpty
          // Tampilkan pesan jika belum ada film favorit
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada film favorit',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          // Tampilkan list film favorit
          : ListView.builder(
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final Movie movie = _favoriteMovies[index];
                return ListTile(
                  // Poster film kecil di sebelah kiri
                  leading: movie.posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(width: 50, child: Icon(Icons.movie)),
                  // Judul film
                  title: Text(movie.title),
                  // Tahun rilis dan rating
                  subtitle: Text('${movie.releaseDate} ⭐ ${movie.voteAverage}'),
                  // Tombol hapus favorit di sebelah kanan
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(movie.id),
                  ),
                  // Navigasi ke DetailScreen saat item di-tap
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(movie: movie),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

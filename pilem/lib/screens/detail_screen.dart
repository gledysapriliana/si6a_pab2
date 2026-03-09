import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  // Flag untuk menandai apakah film ini sudah di-favorit-kan
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Cek status favorit saat screen dibuka
    _checkFavoriteStatus();
  }

  // Fungsi untuk mengecek apakah film ini sudah ada di daftar favorit
  Future<void> _checkFavoriteStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

    // Cek apakah ada film dengan id yang sama di list favorit
    final bool isFav = favoritesJson.any((jsonStr) {
      final Map<String, dynamic> movieMap = json.decode(jsonStr);
      return movieMap['id'] == widget.movie.id;
    });

    setState(() {
      _isFavorite = isFav;
    });
  }

  // Fungsi untuk toggle (tambah/hapus) favorit
  Future<void> _toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJson = prefs.getStringList('favorites') ?? [];

    if (_isFavorite) {
      // Hapus dari favorit
      favoritesJson.removeWhere((jsonStr) {
        final Map<String, dynamic> movieMap = json.decode(jsonStr);
        return movieMap['id'] == widget.movie.id;
      });
    } else {
      // Tambah ke favorit — konversi Movie ke JSON string
      favoritesJson.add(json.encode(widget.movie.toJson()));
    }

    // Simpan kembali ke SharedPreferences
    await prefs.setStringList('favorites', favoritesJson);

    // Update status favorit
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          // Tombol favorit di AppBar
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Overview:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(widget.movie.overview),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Text(
                    'Release Date:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.releaseDate),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 10),
                  const Text(
                    'Rating:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.voteAverage.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

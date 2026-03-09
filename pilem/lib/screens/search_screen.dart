import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_service.dart';
import 'detail_screen.dart';

// SearchScreen menggunakan StatefulWidget karena data berubah saat user mengetik
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  // Instance ApiService untuk memanggil API
  final ApiService _apiService = ApiService();

  // Controller untuk mengontrol dan membaca teks dari TextField
  final TextEditingController _searchController = TextEditingController();

  // List untuk menyimpan hasil pencarian
  List<Movie> _searchResults = [];

  // Flag untuk menampilkan loading indicator
  bool _isLoading = false;

  // Fungsi untuk mencari film berdasarkan query
  Future<void> _searchMovies(String query) async {
    // Jika query kosong, kosongkan hasil pencarian
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Tampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    // Panggil API untuk mencari film
    final List<Map<String, dynamic>> results =
        await _apiService.searchMovies(query);

    // Update state dengan hasil pencarian
    setState(() {
      _searchResults = results.map((e) => Movie.fromJson(e)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Film')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul film...',
                prefixIcon: const Icon(Icons.search),
                // Tombol clear (X) muncul jika ada teks
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchMovies('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Panggil _searchMovies setiap kali teks berubah
              onChanged: (value) => _searchMovies(value),
            ),
          ),

          // Konten utama
          Expanded(
            child: _isLoading
                // Tampilkan loading indicator saat sedang memuat
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    // Tampilkan pesan jika belum ada hasil
                    ? const Center(
                        child: Text('Ketik untuk mencari film...'),
                      )
                    // Tampilkan hasil pencarian dalam bentuk list
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final Movie movie = _searchResults[index];
                          return ListTile(
                            // Poster film kecil di sebelah kiri
                            leading: movie.posterPath.isNotEmpty
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(
                                    width: 50,
                                    child: Icon(Icons.movie),
                                  ),
                            // Judul film
                            title: Text(movie.title),
                            // Tahun rilis dan rating
                            subtitle: Text(
                              '${movie.releaseDate} ⭐ ${movie.voteAverage}',
                            ),
                            // Navigasi ke DetailScreen saat item di-tap
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(movie: movie),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
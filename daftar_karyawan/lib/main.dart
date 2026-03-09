import 'dart:convert'; // library untuk decode JSON

import 'package:flutter/material.dart'; // library utama Flutter UI
import 'package:flutter/services.dart'; // untuk akses file asset
import 'package:daftar_karyawan/models/karyawan.dart'; // import model Karyawan

// Fungsi utama, entry point aplikasi
void main() {
  runApp(const MainApp());
}

// Widget root aplikasi
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,  // sembunyikan banner debug
      home: MyHomePage(), // halaman utama
    );
  }
}

// Halaman utama yang menampilkan daftar karyawan
class MyHomePage extends StatelessWidget {
  const MyHomePage();

  // Fungsi async untuk membaca data JSON dari file asset
  Future<List<Karyawan>> _readJsonData() async {
    final String response = await rootBundle.loadString('assets/karyawan.json'); // baca file JSON
    final List<dynamic> data = json.decode(response); // decode string JSON jadi List
    return data.map((json) => Karyawan.fromJson(json)).toList(); // konversi tiap item ke objek Karyawan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // warna AppBar dari tema
        title: const Text('Daftar Karyawan'), // judul AppBar
      ),
      // FutureBuilder untuk menangani data async
      body: FutureBuilder(
        future: _readJsonData(), // panggil fungsi baca JSON
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // tampilkan pesan error
          }
          if (snapshot.hasData) {
            // Jika data sudah tersedia, tampilkan dalam ListView
            return ListView.builder(
              itemCount: snapshot.data!.length, // jumlah item sesuai data
              itemBuilder: (context, index) {
                final karyawan = snapshot.data![index]; // ambil data karyawan per index
                return ListTile(
                  title: Text(karyawan.nama), // tampilkan nama sebagai judul
                  subtitle: Text(karyawan.umur.toString()), // tampilkan umur
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator()); // tampilkan loading spinner
          }
        },
      ),
    );
  }
}
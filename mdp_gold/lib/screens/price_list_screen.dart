// Import package material design dari Flutter untuk komponen UI
import "package:flutter/material.dart";
// Import package firebase_database untuk tipe data DatabaseEvent
import "package:firebase_database/firebase_database.dart";
// Import GoldService yang berisi method untuk akses Firebase
import "package:mdp_gold/services/gold_service.dart";
import 'package:intl/intl.dart';

import "package:mdp_gold/screens/login_screen.dart";
import "package:mdp_gold/services/auth_service.dart";

class PriceList extends StatefulWidget {
  const PriceList({super.key});

  @override
  State<PriceList> createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {
  final GoldService _goldService = GoldService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harga Emas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _goldService.getPriceList(),
        builder: (context, snapshot) {
          // Menampilkan loading indicator saat menunggu data pertama kali
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Mengambil data dari snapshot Firebase
          final data = snapshot.data?.snapshot.value;

          // Jika data null (kosong), tampilkan pesan
          if (data == null) {
            return const Center(child: Text('Belum ada item.'));
          }

          // Mengkonversi data dari Firebase (Map) ke dalam bentuk Map Dart
          final Map<dynamic, dynamic> itemsMap = data as Map<dynamic, dynamic>;
          // Mengubah Map menjadi List agar bisa diiterasi
          final items = itemsMap.entries.toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = Map<String, dynamic>.from(items[index].value as Map);
              // Mengambil tanggal dari data item
              final String tanggal = item['tanggal']?.toString() ?? '';
              final harga = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(item['harga']);

              return ListTile(
                title: Text(harga),
                subtitle: Text("Tanggal: $tanggal"),
              );
            },
          );
        },
      ),
    );
  }
}

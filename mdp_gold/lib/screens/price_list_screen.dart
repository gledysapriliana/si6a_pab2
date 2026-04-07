import 'package:flutter/widgets.dart';
import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
import "package:mdp_gold/services/gold_service.dart";

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  final GoldService _goldService = GoldService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Emas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _goldService.getPriceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.snapshot.value;

          final Map<dynamic, dynamic> itemsMap = data as Map<dynamic, dynamic>;

          final items = itemsMap.entries.toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = Map<String, dynamic>.from(items[index].value as Map);

              final String tanggal = item['tanggal']?.toString() ?? '';
              final String harga = item['harga']?.toString() ?? '';

              return ListTile(title: Text(harga), subtitle: Text(tanggal));
            },
          );
        },
      ),
    );
  }
}

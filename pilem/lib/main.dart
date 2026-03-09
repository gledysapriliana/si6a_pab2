import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pilem/screens/home_screen.dart';
import 'package:pilem/screens/search_screen.dart';
import 'package:pilem/screens/favorite_screen.dart';

void main() {
  runApp(const MainApp());
}

// Custom ScrollBehavior agar scroll horizontal bisa dengan mouse drag
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: "Pilem",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(), // ← Diubah dari HomeScreen() ke MainScreen()
    );
  }
}

// ✅ Widget baru: MainScreen dengan BottomNavigationBar
// MainScreen menggunakan StatefulWidget karena index tab bisa berubah
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // Index tab yang sedang aktif (0 = Home, 1 = Search, 2 = Favorite)
  int _currentIndex = 0;

  // Daftar halaman yang bisa ditampilkan
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai index yang dipilih
      body: _screens[_currentIndex],

      // Bottom Navigation Bar dengan 3 item
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Update index saat tab di-tap
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}

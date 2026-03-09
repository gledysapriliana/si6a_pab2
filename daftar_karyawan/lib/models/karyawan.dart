// Model untuk data karyawan
class Karyawan {
  final String nama; // nama karyawan
  final int umur; // umur karyawan
  final Alamat alamat; // alamat (objek dari class Alamat)
  final List<String> hobi; // daftar hobi

  // Constructor - semua field wajib diisi
  Karyawan({
    required this.nama,
    required this.umur,
    required this.alamat,
    required this.hobi,
  });

  // Membuat objek Karyawan dari data JSON
  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      nama: json['nama'], // ambil nilai 'nama' dari JSON
      umur: json['umur'], // ambil nilai 'umur' dari JSON
      alamat: Alamat.fromJson(json['alamat']), // konversi JSON ke objek Alamat
      hobi: List<String>.from(json['hobi']), // konversi JSON array ke List
    );
  }
}

// Model untuk data alamat
class Alamat {
  final String jalan; // nama jalan
  final String kota; // nama kota
  final String provinsi; // nama provinsi

  // Constructor - semua field wajib diisi
  Alamat({required this.jalan, required this.kota, required this.provinsi});

  // Membuat objek Alamat dari data JSON
  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      jalan: json['jalan'], // ambil nilai 'jalan' dari JSON
      kota: json['kota'], // ambil nilai 'kota' dari JSON
      provinsi: json['provinsi'], // ambil nilai 'provinsi' dari JSON
    );
  }
}

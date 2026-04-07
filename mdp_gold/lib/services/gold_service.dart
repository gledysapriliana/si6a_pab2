import "package:firebase_database/firebase_database.dart";

class GoldService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'harga_emas',
  );

  Stream<DatabaseEvent> getPriceList() {
    // onValue mengembalikan stream yang mendengarkan perubahan data
    return _database.onValue;
  }
}

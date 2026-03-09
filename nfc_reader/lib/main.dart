import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NFCReaderScreen(),
    );
  }
}

class NFCReaderScreen extends StatefulWidget {
  const NFCReaderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NFCReaderScreenState();
}

class _NFCReaderScreenState extends State<NFCReaderScreen> {
  final List<String> _nfcIds = []; // Daftar history NFC yang terbaca
  bool _isScanning = false; // Status apakah sedang scanning
  double _progressValue = 0.0; // Progress bar (0.0 - 1.0)
  Color _statusColor = Colors.blue; // Warna indikator status
  String _statusText = "Tekan tombol untuk memulai pemindaian";

  @override
  void initState() {
    super.initState();
    _checkNFCAvailability();
  }

  void _checkNFCAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcIds.add("NFC tidak tersedia pada perangkat ini");
      });
    }
  }

  void _startNFCScan() {
    if (_isScanning) return; // Cegah double scanning
    setState(() {
      _isScanning = true;
      _progressValue = 0.2;
      _statusColor = Colors.orange;
      _statusText = "Scanning NFC...";
    });

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var nfcData = tag.data;
        String? nfcId = nfcData['nfca']?['identifier']?.toString();
        String timeStamp = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(DateTime.now());

        if (nfcId != null) {
          setState(() {
            _nfcIds.insert(0, "$timeStamp - NFC ID: $nfcId");
            _progressValue = 1.0;
            _statusColor = Colors.green;
            _statusText = "Kartu berhasil dibaca!";
          });
        } else {
          setState(() {
            _nfcIds.insert(0, "$timeStamp - Tidak dapat membaca ID NFC");
            _progressValue = 1.0;
            _statusColor = Colors.red;
            _statusText = "Gagal membaca kartu";
          });
        }
      },
    );
  }

  void _stopNFCScan() async {
    await NfcManager.instance.stopSession();
    setState(() {
      _isScanning = false;
      _progressValue = 0.0;
      _statusColor = Colors.blue;
      _statusText = "Tekan tombol untuk memulai pemindaian";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NFC Reader"), // Judul di AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // status
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusText,
                style: TextStyle(color: Colors.amber, fontSize: 18),
              ),
            ),

            SizedBox(height: 20),

            // indikator scanning
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isScanning ? Colors.orangeAccent : Colors.grey,
              ),
              child: Icon(
                _isScanning ? Icons.nfc : Icons.nfc,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // ================= PROGRESS BAR =================
            LinearProgressIndicator(
              value: _progressValue, // Nilai progress (0.0 - 1.0)
              minHeight: 8, // Ketebalan bar
              backgroundColor: Colors.grey, // Warna background
              color: _statusColor, // Warna progress mengikuti status
            ),

            SizedBox(height: 20),

            // ================= HISTORY LIST =================
            Expanded(
              // Mengisi sisa ruang layar
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background list
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Bayangan halus
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _nfcIds.length, // Jumlah history NFC
                  itemBuilder: (context, index) {
                    String entry = _nfcIds[index]; // Data history

                    // Memisahkan timestamp & NFC ID
                    List<String> parts = entry.split(' - NFC ID: ');
                    String timeStamp = parts[0];
                    String nfcId = parts.length > 1
                        ? parts[1]
                        : "Tidak dapat membaca ID NFC";

                    return Card(
                      elevation: 3, // Tinggi bayangan card
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timestamp scan
                            Text(
                              timeStamp,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 5),

                            // NFC ID yang terbaca
                            Text(nfcId, style: TextStyle(fontSize: 16)),
                          ],
                        ),

                        // Alternatif tampilan sederhana:
                        // title: Text(_nfcIds[index])
                        // leading: Icon(Icons.history)
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 20),

            // ================= TOMBOL CONTROL =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol mulai scan
                ElevatedButton(
                  onPressed: _startNFCScan, // Fungsi start scanning
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Mulai Scan",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),

                SizedBox(width: 20), // Spasi antar tombol
                // Tombol stop scan
                ElevatedButton(
                  onPressed: _stopNFCScan, // Fungsi stop scanning
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.redAccent, // Warna tombol stop
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Stop Scan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

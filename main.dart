// ==================== CINEBOOK - SI2A ====================
// Nama: Azriel Miracle Yuandre & Esti Anggraini

class Film {
  final int id, harga, rating;
  final String judul, genre;
  const Film(this.id, this.judul, this.harga, this.rating, this.genre);
  String info() => "🎬 $judul | $genre | ⭐$rating/5 | Rp$harga";
}

class Studio {
  final int id;
  final String nama;
  final double multiplier;
  const Studio(this.id, this.nama, this.multiplier);
  String info() => "🏢 $nama (${multiplier}x)";
}

class Kursi {
  final String kode, tipe;
  final int harga;
  bool dipesan;
  Kursi(this.kode, this.harga, this.tipe, {this.dipesan = false});
  void pesan() => dipesan = true;
  void batalPesan() => dipesan = false;
}

class Pembeli {
  final String nama;
  final List<Tiket> tiketList = [];
  Pembeli(this.nama);
  void beliTiket(Tiket t) => tiketList.add(t);
}

class Tiket {
  final String id, nama, film, studio, kursi, tanggal;
  final int total, hargaAwal;
  const Tiket(this.id, this.nama, this.film, this.studio, this.kursi, 
              this.total, this.hargaAwal, this.tanggal);
  String cetak() => """
┌─────────────────────────────────┐
│        🎟️ TIKET BIOSKOP        │
├─────────────────────────────────┤
│ ID:$id | Nama:$nama
│ Film:$film | Studio:$studio
│ Kursi:$kursi | Tgl:$tanggal
│ Harga:Rp$hargaAwal
│ TOTAL:Rp$total
└─────────────────────────────────┘
""";
}

// ==================== MAIN ====================
void main() {
  print("=" * 50);
  print("   🎬 CINEBOOK - SISTEM TIKET SEDERHANA");
  print("=" * 50);
  
  // Data film
  final film = [
    const Film(1, "Avengers: Endgame", 50000, 5, "Action"),
    const Film(2, "Oppenheimer", 60000, 5, "Drama"),
    const Film(3, "Inside Out 2", 45000, 4, "Animation"),
  ];
  
  // Data studio
  final studio = [
    const Studio(1, "Teater 1 (Reguler)", 1.0),
    const Studio(2, "Teater 2 (VIP)", 1.5),
    const Studio(3, "Teater 3 (IMAX)", 2.0),
  ];
  
  // Data kursi
  final kursi = <Kursi>[];
  for (final b in ['A','B','C','D','E','F']) {
    for (var i = 1; i <= 8; i++) {
      kursi.add(Kursi('$b$i', (b == 'A' || b == 'B') ? 45000 : 75000, 
                       (b == 'A' || b == 'B') ? 'Reguler' : 'VIP'));
    }
  }
  
  // Data pembeli
  final pembeli = [
    Pembeli("Azriel"), Pembeli("Esti"), Pembeli("Ratu"), Pembeli("Alicia"), Pembeli("Budi"),
    Pembeli("Siti"), Pembeli("Andi"), Pembeli("Dewi"), Pembeli("Rizky"), Pembeli("Maya"),
  ];
  
  // Tampilkan film
  print("\n📽️ FILM:");
  for (final f in film) {
    print(f.info());
  }
  
  // Pemesanan
  print("\n📋 PEMESANAN:");
  int counter = 1;
  final pesanan = [
    ["Azriel", 0, 0, "19:30", ["A1","A2"]],
    ["Esti",   0, 0, "19:30", ["A3"]],
    ["Ratu",   1, 1, "21:00", ["C1","C2"]],
    ["Alicia", 1, 1, "21:00", ["C3"]],
    ["Budi",   0, 0, "19:30", ["B1"]],
    ["Siti",   1, 1, "21:00", ["D1","D2"]],
    ["Andi",   2, 2, "15:00", ["A1","A2"]],
    ["Dewi",   2, 2, "15:00", ["A3"]],
    ["Rizky",  0, 0, "19:30", ["B2"]],
    ["Maya",   1, 1, "21:00", ["E1"]],
  ];
  
  for (final p in pesanan) {
    final nama = p[0] as String;
    final f = film[p[1] as int];
    final s = studio[p[2] as int];
    final kodeKursi = (p[4] as List).cast<String>();
    
    final beli = pembeli.firstWhere((x) => x.nama == nama);
    
    final dipesan = <Kursi>[];
    for (final k in kodeKursi) {
      final ks = kursi.firstWhere((x) => x.kode == k);
      if (!ks.dipesan) dipesan.add(ks);
    }
    
    if (dipesan.isEmpty) {
      print("   ❌ $nama: Gagal");
      continue;
    }
    
    int total = 0;
    for (final k in dipesan) { k.pesan(); total += k.harga; }
    total = (total * s.multiplier).round();
    
    final tiket = Tiket(
      'TIX${counter.toString().padLeft(3, '0')}', nama, f.judul, s.nama,
      dipesan.map((k) => k.kode).join(', '), total, total,
      DateTime.now().toString().substring(0, 10)
    );
    counter++;
    beli.beliTiket(tiket);
    
    print("   ✅ $nama: ${f.judul} - ${tiket.kursi} (Rp$total)");
  }
  
  // Tampilkan tiket
  print("\n🎟️ TIKET:");
  for (final p in pembeli) {
    for (final t in p.tiketList) {
      print(t.cetak());
    }
  }
  
  // Batal kursi
  final batal = kursi.firstWhere((k) => k.kode == 'A1');
  batal.batalPesan();
  print("\n🔄 BATAL A1: ✅ Berhasil");
  
  // Ringkasan
  int jual = 0, dana = 0, pembeliBeli = 0;
  for (final p in pembeli) {
    if (p.tiketList.isNotEmpty) pembeliBeli++;
    for (final t in p.tiketList) {
      jual++;
      dana += t.total;
    }
  }
  print("\n📊 Total: $jual tiket | Rp$dana | $pembeliBeli pembeli");
  print("🎬 TERIMA KASIH!");
}

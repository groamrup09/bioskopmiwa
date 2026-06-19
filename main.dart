// ==================== CINEBOOK - APLIKASI PEMESANAN TIKET BIOSKOP ====================
// Nama: Azriel Miracle Yuandre & Esti Anggraini
// Kelas: SI2A

// ===================================================================================
// CLASS 1: FILM
// ===================================================================================
class Film {
  String judul;
  int harga;
  int rating;
  String genre;

  Film(this.judul, this.harga, this.rating, this.genre);

  String info() {
    return "🎬 $judul | $genre | ⭐ $rating/5 | Rp $harga";
  }
}

// ===================================================================================
// CLASS 2: KURSI
// ===================================================================================
class Kursi {
  String kode;
  bool dipesan;
  int harga;

  Kursi(this.kode, this.dipesan, this.harga);

  bool get tersedia => !dipesan;
  void pesan() => dipesan = true;
  void batalPesan() => dipesan = false;
  String get tampil => dipesan ? "[XX]" : "[$kode]";
}

// ===================================================================================
// CLASS 3: TEATER
// ===================================================================================
class Teater {
  String nama;
  Film film;
  String jam;
  List<Kursi> kursi = [];

  Teater(this.nama, this.film, this.jam) {
    for (var b in ["A","B","C","D","E","F"]) {
      for (var i = 1; i <= 8; i++) {
        int harga = (b == "A" || b == "B") ? 45000 : 75000;
        kursi.add(Kursi("$b$i", false, harga));
      }
    }
  }

  bool pesanKursi(String kode) {
    for (var k in kursi) {
      if (k.kode == kode && k.tersedia) {
        k.pesan();
        return true;
      }
    }
    return false;
  }

  bool batalKursi(String kode) {
    for (var k in kursi) {
      if (k.kode == kode && !k.tersedia) {
        k.batalPesan();
        return true;
      }
    }
    return false;
  }

  Kursi? cariKursi(String kode) {
    for (var k in kursi) {
      if (k.kode == kode) return k;
    }
    return null;
  }

  int get terjual {
    int count = 0;
    for (var k in kursi) {
      if (!k.tersedia) count++;
    }
    return count;
  }

  int get pendapatan {
    int total = 0;
    for (var k in kursi) {
      if (!k.tersedia) total += k.harga;
    }
    return total;
  }

  String info() {
    return "\n🏢 $nama - ${film.judul} ($jam)\n   Tiket terjual: ${terjual} dari ${kursi.length}\n   Pendapatan: Rp $pendapatan";
  }

  String denah() {
    String hasil = "\n   LAYAR BIOSKOP - ${film.judul}\n   ====================\n";
    List<String> baris = ["A", "B", "C", "D", "E", "F"];
    for (var b in baris) {
      hasil += "   $b  ";
      for (var i = 0; i < 8; i++) {
        var k = kursi.firstWhere((k) => k.kode == "$b${i+1}");
        hasil += "${k.tampil} ";
      }
      hasil += "\n";
    }
    hasil += "\n   🟢 Tersedia  🔴 Terisi";
    return hasil;
  }
}

// ===================================================================================
// CLASS 4: DISKON
// ===================================================================================
class Diskon {
  String kode;
  int potongan;
  int minimalBeli;

  Diskon(this.kode, this.potongan, this.minimalBeli);

  int hitungDiskon(int total) {
    if (total >= minimalBeli) {
      return total - (total * potongan ~/ 100);
    }
    return total;
  }

  String info() {
    return "🎫 $kode | Potongan ${potongan}% | Min. beli Rp $minimalBeli";
  }
}

// ===================================================================================
// CLASS 5: TIKET
// ===================================================================================
class Tiket {
  String id;
  String nama;
  String film;
  String teater;
  String jam;
  String kursi;
  int total;
  int hargaAwal;
  String kodeDiskon;
  int diskonTerpakai;

  Tiket({
    required this.id,
    required this.nama,
    required this.film,
    required this.teater,
    required this.jam,
    required this.kursi,
    required this.total,
    required this.hargaAwal,
    required this.kodeDiskon,
    required this.diskonTerpakai,
  });

  String cetak() {
    String diskonInfo = "";
    if (diskonTerpakai > 0) {
      diskonInfo = "\n│ Diskon   : -Rp $diskonTerpakai ($kodeDiskon)";
    }
    return "\n┌─────────────────────────────────────────────────┐\n"
         "│              🎟️ TIKET BIOSKOP 🎟️              │\n"
         "├─────────────────────────────────────────────────┤\n"
         "│ Nama     : $nama\n"
         "│ Film     : $film\n"
         "│ Teater   : $teater\n"
         "│ Jam      : $jam\n"
         "│ Kursi    : $kursi\n"
         "│ Harga Awal: Rp $hargaAwal$diskonInfo\n"
         "├─────────────────────────────────────────────────┤\n"
         "│ Total    : Rp $total\n"
         "│ Status   : ✅ LUNAS\n"
         "└─────────────────────────────────────────────────┘";
  }

  String ringkasan() {
    return "$film - $kursi - Rp $total${diskonTerpakai > 0 ? " (hemat Rp $diskonTerpakai)" : ""}";
  }
}

// ===================================================================================
// CLASS 6: PEMBELI
// ===================================================================================
class Pembeli {
  String nama;
  List<Tiket> tiket = [];

  Pembeli(this.nama);

  void beli(Tiket t) => tiket.add(t);

  int get totalTiket => tiket.length;

  int get totalBelanja {
    int total = 0;
    for (var t in tiket) {
      total += t.total;
    }
    return total;
  }

  int get totalHemat {
    int total = 0;
    for (var t in tiket) {
      total += t.diskonTerpakai;
    }
    return total;
  }

  String info() {
    return "👤 $nama | Tiket: $totalTiket | Belanja: Rp $totalBelanja | Hemat: Rp $totalHemat";
  }

  String daftarFilm() {
    if (tiket.isEmpty) return "   $nama belum nonton film apapun.";
    List<String> list = [];
    for (var t in tiket) {
      if (!list.contains(t.film)) list.add(t.film);
    }
    return "   $nama sudah menonton: ${list.join(", ")}";
  }
}

// ===================================================================================
// CLASS 7: BIOSKOP
// ===================================================================================
class Bioskop {
  String nama;
  List<Teater> daftarTeater = [];
  List<Pembeli> daftarPembeli = [];
  List<Diskon> daftarDiskon = [];

  Bioskop(this.nama);

  void tambahTeater(Teater t) => daftarTeater.add(t);
  void tambahPembeli(Pembeli p) => daftarPembeli.add(p);
  void tambahDiskon(Diskon d) => daftarDiskon.add(d);

  Teater? cariTeater(String nama) {
    for (var t in daftarTeater) {
      if (t.nama == nama) return t;
    }
    return null;
  }

  Pembeli? cariPembeli(String nama) {
    for (var p in daftarPembeli) {
      if (p.nama == nama) return p;
    }
    return null;
  }

  Diskon? cariDiskon(String kode) {
    for (var d in daftarDiskon) {
      if (d.kode == kode) return d;
    }
    return null;
  }

  int get totalTiketTerjual {
    int total = 0;
    for (var t in daftarTeater) {
      total += t.terjual;
    }
    return total;
  }

  int get totalPendapatan {
    int total = 0;
    for (var t in daftarTeater) {
      total += t.pendapatan;
    }
    return total;
  }

  String info() {
    String hasil = "\n🏢 ${nama.toUpperCase()}\n";
    hasil += "   Teater: ${daftarTeater.length} | Pembeli: ${daftarPembeli.length}\n";
    hasil += "   Total Tiket: $totalTiketTerjual | Pendapatan: Rp $totalPendapatan";
    return hasil;
  }
}

// ===================================================================================
// MAIN PROGRAM
// ===================================================================================
void main() {
  // 1. Buat Film
  var f1 = Film("Avengers: Endgame", 50000, 5, "Action");
  var f2 = Film("Oppenheimer", 60000, 5, "Drama");
  var f3 = Film("Inside Out 2", 45000, 4, "Animation");
  var f4 = Film("Spider-Man", 50000, 5, "Action");
  var f5 = Film("Joker 2", 55000, 4, "Drama");

  List<Film> daftarFilm = [f1, f2, f3, f4, f5];

  // 2. Buat Teater
  var t1 = Teater("Teater 1", f1, "19:30");
  var t2 = Teater("Teater 2", f2, "21:00");
  var t3 = Teater("Teater 3", f3, "15:00");

  List<Teater> semuaTeater = [t1, t2, t3];

  // 3. Buat Diskon
  var d1 = Diskon("STUDENT10", 10, 50000);
  var d2 = Diskon("FAMILY20", 20, 100000);
  var d3 = Diskon("WEEKEND15", 15, 75000);

  List<Diskon> daftarDiskon = [d1, d2, d3];

  // 4. Buat Bioskop
  var bioskop = Bioskop("CineBook Cinema");
  for (var t in semuaTeater) {
    bioskop.tambahTeater(t);
  }
  for (var d in daftarDiskon) {
    bioskop.tambahDiskon(d);
  }

  // 5. Buat Pembeli (15 orang)
  List<Pembeli> pembeli = [
    Pembeli("Azriel"), Pembeli("Esti"), Pembeli("Ratu"),
    Pembeli("Alicia"), Pembeli("Budi"), Pembeli("Siti"),
    Pembeli("Andi"), Pembeli("Dewi"), Pembeli("Rizky"),
    Pembeli("Maya"), Pembeli("Doni"), Pembeli("Nina"),
    Pembeli("Fajar"), Pembeli("Lina"), Pembeli("Rizki")
  ];
  for (var p in pembeli) {
    bioskop.tambahPembeli(p);
  }

  // 6. Data Pemesanan (nama, teater, kursi, diskon)
  List<Map<String, dynamic>> pesanan = [
    {"nama": "Azriel", "teater": t1, "kursi": ["A1", "A2"], "diskon": "STUDENT10"},
    {"nama": "Esti", "teater": t1, "kursi": ["A3"], "diskon": null},
    {"nama": "Ratu", "teater": t2, "kursi": ["C1", "C2"], "diskon": "FAMILY20"},
    {"nama": "Alicia", "teater": t2, "kursi": ["C3"], "diskon": null},
    {"nama": "Budi", "teater": t1, "kursi": ["B1"], "diskon": "WEEKEND15"},
    {"nama": "Siti", "teater": t1, "kursi": ["B2", "B3"], "diskon": null},
    {"nama": "Andi", "teater": t2, "kursi": ["D1"], "diskon": "STUDENT10"},
    {"nama": "Dewi", "teater": t2, "kursi": ["D2", "D3"], "diskon": null},
    {"nama": "Rizky", "teater": t1, "kursi": ["B4"], "diskon": "FAMILY20"},
    {"nama": "Maya", "teater": t2, "kursi": ["E1"], "diskon": null},
    {"nama": "Doni", "teater": t1, "kursi": ["A4", "A5"], "diskon": "WEEKEND15"},
    {"nama": "Nina", "teater": t2, "kursi": ["E2", "E3"], "diskon": null},
    {"nama": "Fajar", "teater": t3, "kursi": ["A1", "A2"], "diskon": "STUDENT10"},
    {"nama": "Lina", "teater": t3, "kursi": ["A3"], "diskon": null},
    {"nama": "Rizki", "teater": t3, "kursi": ["B1", "B2"], "diskon": "FAMILY20"},
  ];

  // ========== TAMPILKAN OUTPUT ==========
  String output = "";

  // HEADER
  output += "\n==========================================";
  output += "\n       🎬 CINEBOOK - PEMESANAN TIKET";
  output += "\n==========================================";

  // DAFTAR FILM
  output += "\n\n📽️ DAFTAR FILM TERSEDIA:";
  output += "\n==========================================";
  for (var f in daftarFilm) {
    output += "\n${f.info()}";
  }

  // DAFTAR DISKON
  output += "\n\n🎫 DAFTAR DISKON:";
  output += "\n==========================================";
  for (var d in daftarDiskon) {
    output += "\n${d.info()}";
  }

  // PROSES PEMESANAN
  output += "\n\n📋 PROSES PEMESANAN";
  output += "\n==========================================";

  for (var data in pesanan) {
    String nama = data["nama"] as String;
    Teater t = data["teater"] as Teater;
    List<String> kursiDipilih = data["kursi"] as List<String>;
    String? kodeDiskon = data["diskon"] as String?;

    var p = bioskop.cariPembeli(nama)!;

    output += "\n\n👤 ${p.nama} - ${t.nama} (${t.film.judul})";

    List<String> berhasil = [];
    int total = 0;

    for (var kode in kursiDipilih) {
      if (t.pesanKursi(kode)) {
        var k = t.cariKursi(kode)!;
        berhasil.add(kode);
        total += k.harga;
        output += "\n   ✅ Kursi $kode berhasil";
      } else {
        output += "\n   ❌ Kursi $kode gagal (sudah dipesan)";
      }
    }

    if (berhasil.isNotEmpty) {
      int hargaAwal = total;
      int diskonTerpakai = 0;
      String diskonPakai = "-";

      if (kodeDiskon != null) {
        var diskon = bioskop.cariDiskon(kodeDiskon);
        if (diskon != null) {
          int totalSetelahDiskon = diskon.hitungDiskon(total);
          diskonTerpakai = total - totalSetelahDiskon;
          total = totalSetelahDiskon;
          diskonPakai = kodeDiskon;
        }
      }

      var tiket = Tiket(
        id: "TIX${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}",
        nama: p.nama,
        film: t.film.judul,
        teater: t.nama,
        jam: t.jam,
        kursi: berhasil.join(", "),
        total: total,
        hargaAwal: hargaAwal,
        kodeDiskon: diskonPakai,
        diskonTerpakai: diskonTerpakai,
      );
      p.beli(tiket);

      if (diskonTerpakai > 0) {
        output += "\n   🎫 Diskon $diskonPakai: hemat Rp $diskonTerpakai";
      }
    }
  }

  // DEMO BATAL KURSI
  output += "\n\n==========================================";
  output += "\n         🔄 DEMO BATAL KURSI";
  output += "\n==========================================";

  output += "\n\n📍 Batalkan kursi A1 di Teater 1...";
  if (t1.batalKursi("A1")) {
    output += "\n   ✅ Kursi A1 berhasil dibatalkan!";
  } else {
    output += "\n   ❌ Gagal membatalkan kursi A1";
  }

  output += "\n\n📍 Batalkan kursi Z9 di Teater 1...";
  if (t1.batalKursi("Z9")) {
    output += "\n   ✅ Kursi Z9 berhasil dibatalkan!";
  } else {
    output += "\n   ❌ Kursi Z9 tidak ditemukan atau tidak sedang dipesan";
  }

  // CETAK SEMUA TIKET
  output += "\n\n==========================================";
  output += "\n         🎟️ SEMUA TIKET";
  output += "\n==========================================";

  for (var p in pembeli) {
    for (var t in p.tiket) {
      output += t.cetak();
    }
  }

  // DAFTAR FILM PER PEMBELI
  output += "\n\n==========================================";
  output += "\n         📽️ DAFTAR FILM PER PEMBELI";
  output += "\n==========================================";

  for (var p in pembeli) {
    output += "\n${p.daftarFilm()}";
  }

  // LAPORAN PEMBELI
  output += "\n\n==========================================";
  output += "\n         👥 LAPORAN PEMBELI";
  output += "\n==========================================";

  for (var p in pembeli) {
    output += "\n${p.info()}";
  }

  // LAPORAN TEATER
  output += "\n\n==========================================";
  output += "\n         📊 LAPORAN PENJUALAN";
  output += "\n==========================================";

  int totalTiket = 0;
  int totalPendapatan = 0;

  for (var t in semuaTeater) {
    output += t.info();
    totalTiket += t.terjual;
    totalPendapatan += t.pendapatan;
  }

  output += "\n\n📌 TOTAL KESELURUHAN:";
  output += "\n   Tiket terjual: $totalTiket tiket";
  output += "\n   Total pendapatan: Rp $totalPendapatan";
  
  int totalHemat = 0;
  for (var p in pembeli) {
    totalHemat += p.totalHemat;
  }
  if (totalHemat > 0) {
    output += "\n   Total hemat diskon: Rp $totalHemat";
  }

  output += "\n\n==========================================";
  output += "\n       🎬 TERIMA KASIH!";
  output += "\n==========================================\n";

  print(output);
}

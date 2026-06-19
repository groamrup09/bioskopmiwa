// ==================== Pemesanan tiket bioskop online ====================
// Nama: Azriel Miracle Yuandre & Esti Anggraini
// Kelas: SI2A

class Film {
  final String judul, genre;
  final int harga, rating;
  const Film(this.judul, this.harga, this.rating, this.genre);
}

class Kursi {
  final String kode;
  final int harga;
  bool dipesan;
  Kursi(this.kode, this.harga, {this.dipesan = false});
}

class Teater {
  final String nama, jam;
  final Film film;
  final List<Kursi> kursi;
  Teater(this.nama, this.film, this.jam) : kursi = _buatKursi();
  
  static List<Kursi> _buatKursi() {
    final list = <Kursi>[];
    for (final b in ['A','B','C','D','E','F']) {
      for (var i = 1; i <= 8; i++) {
        list.add(Kursi('$b$i', (b == 'A' || b == 'B') ? 45000 : 75000));
      }
    }
    return list;
  }
}

class Tiket {
  final String nama, film, teater, jam, kursi;
  final int total;
  const Tiket(this.nama, this.film, this.teater, this.jam, this.kursi, this.total);
}

// ===================================================================================
// 2. REPOSITORY (menyimpan dan mencari data)
// ===================================================================================
class Bioskop {
  final List<Film> film = [];
  final List<Teater> teater = [];
  final List<Tiket> tiket = [];
  final List<String> pembeli = [];

  Teater? cariTeater(String nama) => 
      teater.cast<Teater?>().firstWhere((t) => t!.nama == nama, orElse: () => null);
  
  Kursi? cariKursi(Teater t, String kode) =>
      t.kursi.cast<Kursi?>().firstWhere((k) => k!.kode == kode, orElse: () => null);
}

// ===================================================================================
// 3. SERVICE (logika bisnis - 1 method = 1 fungsi)
// ===================================================================================
class PemesananService {
  final Bioskop data;
  PemesananService(this.data);

  // Fungsi: pesan kursi
  Tiket? pesan(String nama, Teater teater, List<String> kodeKursi) {
    // Kumpulkan kursi yang tersedia
    final dipesan = <Kursi>[];
    for (final kode in kodeKursi) {
      final kursi = data.cariKursi(teater, kode);
      if (kursi != null && !kursi.dipesan) dipesan.add(kursi);
    }
    if (dipesan.isEmpty) return null;

    // Tandai dipesan
    int total = 0;
    for (final k in dipesan) {
      k.dipesan = true;
      total += k.harga;
    }
    data.pembeli.add(nama);

    // Buat & simpan tiket
    final tiket = Tiket(nama, teater.film.judul, teater.nama, teater.jam,
                        dipesan.map((k) => k.kode).join(', '), total);
    data.tiket.add(tiket);
    return tiket;
  }

  // Fungsi: batal kursi
  bool batal(Teater teater, String kode) {
    final kursi = data.cariKursi(teater, kode);
    if (kursi != null && kursi.dipesan) {
      kursi.dipesan = false;
      return true;
    }
    return false;
  }
}

// ===================================================================================
// 4. VIEW/LAPORAN (hanya format output)
// ===================================================================================
class Laporan {
  static String film(List<Film> daftar) => daftar.map((f) => 
      "🎬 ${f.judul} | ${f.genre} | ⭐${f.rating}/5 | Rp${f.harga}").join('\n');

  static String tiket(Tiket t) => 
      "\n┌─────────────────────────────────┐\n"
      "│        🎟️ TIKET BIOSKOP        │\n"
      "├─────────────────────────────────┤\n"
      "│ Nama  : ${t.nama}\n"
      "│ Film  : ${t.film}\n"
      "│ Jam   : ${t.jam} | ${t.teater}\n"
      "│ Kursi : ${t.kursi}\n"
      "│ Total : Rp${t.total}\n"
      "└─────────────────────────────────┘";

  static String ringkasan(Bioskop data) {
    int jual = data.teater.fold(0, (s, t) => s + t.kursi.where((k) => k.dipesan).length);
    int dana = data.teater.fold(0, (s, t) => s + t.kursi.where((k) => k.dipesan).fold(0, (a, k) => a + k.harga));
    return "📊 Total: $jual tiket | Rp$dana";
  }
}

// ===================================================================================
// 5. MAIN (orkestrasi - menjalankan program)
// ===================================================================================
void main() {
  // Data film
  final film = [
    const Film("Avengers: Endgame", 50000, 5, "Action"),
    const Film("Oppenheimer", 60000, 5, "Drama"),
    const Film("Inside Out 2", 45000, 4, "Animation"),
  ];

  // Data teater
  final t1 = Teater("Teater 1", film[0], "19:30");
  final t2 = Teater("Teater 2", film[1], "21:00");
  final t3 = Teater("Teater 3", film[2], "15:00");

  // Setup
  final bioskop = Bioskop();
  bioskop.film.addAll(film);
  bioskop.teater.addAll([t1, t2, t3]);
  final service = PemesananService(bioskop);

  // Output
  print("=" * 50);
  print("   🎬 CINEBOOK - SISTEM TIKET SEDERHANA");
  print("=" * 50);
  print("\n📽️ FILM:\n${Laporan.film(film)}");
  
  // Pemesanan (10 data)
  print("\n📋 PEMESANAN:");
  final pesanan = [
    ["Azriel", t1, ["A1","A2"]],
    ["Esti",   t1, ["A3"]],
    ["Ratu",   t2, ["C1","C2"]],
    ["Alicia", t2, ["C3"]],
    ["Budi",   t1, ["B1"]],
    ["Siti",   t2, ["D1","D2"]],
    ["Andi",   t3, ["A1","A2"]],
    ["Dewi",   t3, ["A3"]],
    ["Rizky",  t1, ["B2"]],
    ["Maya",   t2, ["E1"]],
  ];

  for (final p in pesanan) {
    final hasil = service.pesan(p[0] as String, p[1] as Teater, p[2] as List<String>);
    if (hasil != null) {
      print("   ✅ ${p[0]}: ${p[2]} - ${p[1].film.judul} (Rp${hasil.total})");
    } else {
      print("   ❌ ${p[0]}: Gagal memesan ${p[2]}");
    }
  }

  // Tampilkan tiket
  print("\n🎟️ TIKET:");
  for (final t in bioskop.tiket) {
    print(Laporan.tiket(t));
  }

  // Batal kursi
  print("\n🔄 BATAL: A1 di Teater 1");
  print("   ${service.batal(t1, 'A1') ? '✅ Berhasil' : '❌ Gagal'}");

  // Ringkasan
  print("\n${Laporan.ringkasan(bioskop)}");
  print("\n🎬 TERIMA KASIH!");
}

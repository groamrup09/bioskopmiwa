// ==================== CINEBOOK - SI2A ====================
// Nama: Azriel Miracle Yuandre & Esti Anggraini

class Film {
  final int _id;
  final String _judul;
  final int _harga;
  final int _rating;
  final String _genre;

  const Film(this._id, this._judul, this._harga, this._rating, this._genre);

  int get id => _id;
  String get judul => _judul;
  int get harga => _harga;
  int get rating => _rating;
  String get genre => _genre;

  String info() => "🎬 $_judul | $_genre | ⭐$_rating/5 | Rp$_harga";
}

class Studio {
  final int _id;
  final String _nama;
  final double _multiplier;

  const Studio(this._id, this._nama, this._multiplier);

  int get id => _id;
  String get nama => _nama;
  double get multiplier => _multiplier;

  String info() => "🏢 $_nama (${_multiplier}x)";
}

class Kursi {
  final String _kode;
  final String _tipe;
  final int _harga;
  bool _dipesan;

  Kursi(this._kode, this._harga, this._tipe, {bool dipesan = false}) : _dipesan = dipesan;

  String get kode => _kode;
  String get tipe => _tipe;
  int get harga => _harga;
  bool get dipesan => _dipesan;

  void pesan() => _dipesan = true;
  void batalPesan() => _dipesan = false;
}

class Pembeli {
  final String _nama;
  final List<Tiket> _tiketList = [];

  Pembeli(this._nama);

  String get nama => _nama;
  List<Tiket> get tiketList => List.unmodifiable(_tiketList);

  void beliTiket(Tiket t) => _tiketList.add(t);
}

class Tiket {
  final String _id;
  final String _namaPembeli;
  final String _judulFilm;
  final String _namaStudio;
  final String _kodeKursi;
  final int _total;
  final int _hargaAwal;
  final String _tanggal;

  const Tiket(
    this._id,
    this._namaPembeli,
    this._judulFilm,
    this._namaStudio,
    this._kodeKursi,
    this._total,
    this._hargaAwal,
    this._tanggal,
  );

  String get id => _id;
  String get namaPembeli => _namaPembeli;
  String get judulFilm => _judulFilm;
  String get namaStudio => _namaStudio;
  String get kodeKursi => _kodeKursi;
  int get total => _total;
  int get hargaAwal => _hargaAwal;
  String get tanggal => _tanggal;

  String cetak() => """
┌─────────────────────────────────┐
│        🎟️ TIKET BIOSKOP        │
├─────────────────────────────────┤
│ ID:$_id | Nama:$_namaPembeli
│ Film:$_judulFilm | Studio:$_namaStudio
│ Kursi:$_kodeKursi | Tgl:$_tanggal
│ Harga Awal: Rp$_hargaAwal
│ TOTAL: Rp$_total
└─────────────────────────────────┘
""";
}

class CineBookSystem {
  final List<Film> _filmList = [];
  final List<Studio> _studioList = [];
  final List<Kursi> _kursiList = [];
  final List<Pembeli> _pembeliList = [];

  CineBookSystem() {
    _initData();
  }

  void _initData() {
    _filmList.addAll([
      const Film(1, "Avengers: Endgame", 50000, 5, "Action"),
      const Film(2, "Oppenheimer", 60000, 5, "Drama"),
      const Film(3, "Inside Out 2", 45000, 4, "Animation"),
    ]);

    _studioList.addAll([
      const Studio(1, "Teater 1 (Reguler)", 1.0),
      const Studio(2, "Teater 2 (VIP)", 1.5),
      const Studio(3, "Teater 3 (IMAX)", 2.0),
    ]);

    for (final b in ['A', 'B', 'C', 'D', 'E', 'F']) {
      for (var i = 1; i <= 8; i++) {
        _kursiList.add(
          Kursi(
            '$b$i',
            (b == 'A' || b == 'B') ? 45000 : 75000,
            (b == 'A' || b == 'B') ? 'Reguler' : 'VIP',
          ),
        );
      }
    }

    _pembeliList.addAll([
      Pembeli("Azriel"),
      Pembeli("Esti"),
      Pembeli("Ratu"),
      Pembeli("Alicia"),
      Pembeli("Budi"),
      Pembeli("Siti"),
      Pembeli("Andi"),
      Pembeli("Dewi"),
      Pembeli("Rizky"),
      Pembeli("Maya"),
    ]);
  }

  List<Film> get films => List.unmodifiable(_filmList);
  List<Studio> get studios => List.unmodifiable(_studioList);
  List<Kursi> get kursi => List.unmodifiable(_kursiList);
  List<Pembeli> get pembeli => List.unmodifiable(_pembeliList);

  void printDaftarFilm() {
    print("\n📽️ FILM:");
    for (final f in _filmList) {
      print(f.info());
    }
  }

  bool prosesBooking({
    required String namaPembeli,
    required int filmIndex,
    required int studioIndex,
    required List<String> kodeKursiList,
    required String ticketId,
  }) {
    final pembeliObj = _pembeliList.firstWhere(
      (x) => x.nama == namaPembeli,
      orElse: () => throw Exception("Pembeli tidak ditemukan: $namaPembeli"),
    );

    if (filmIndex < 0 || filmIndex >= _filmList.length) return false;
    if (studioIndex < 0 || studioIndex >= _studioList.length) return false;

    final filmObj = _filmList[filmIndex];
    final studioObj = _studioList[studioIndex];

    final dipesanList = <Kursi>[];
    for (final k in kodeKursiList) {
      final ks = _kursiList.firstWhere(
        (x) => x.kode == k,
        orElse: () => throw Exception("Kursi $k tidak ditemukan"),
      );
      if (!ks.dipesan) {
        dipesanList.add(ks);
      }
    }

    if (dipesanList.isEmpty || dipesanList.length != kodeKursiList.length) {
      print("   ❌ $namaPembeli: Gagal (kursi sudah dipesan)");
      return false;
    }

    // Hitung harga awal: (harga film + harga kursi) untuk setiap tiket
    int hargaAwal = 0;
    for (final k in dipesanList) {
      hargaAwal += filmObj.harga + k.harga;
    }

    // Terapkan multiplier studio
    int totalAkhir = (hargaAwal * studioObj.multiplier).round();

    for (final k in dipesanList) {
      k.pesan();
    }

    final tiket = Tiket(
      ticketId,
      pembeliObj.nama,
      filmObj.judul,
      studioObj.nama,
      dipesanList.map((k) => k.kode).join(', '),
      totalAkhir,
      hargaAwal,
      DateTime.now().toString().substring(0, 10),
    );

    pembeliObj.beliTiket(tiket);
    print("   ✅ $namaPembeli: ${filmObj.judul} - ${tiket.kodeKursi} (Rp$totalAkhir)");
    return true;
  }

  void cetakSemuaTiket() {
    print("\n🎟️ TIKET:");
    for (final p in _pembeliList) {
      for (final t in p.tiketList) {
        print(t.cetak());
      }
    }
  }

  void cetakStatistik() {
    int totalTiket = 0;
    num totalDana = 0;
    int totalPembeliAktif = 0;

    for (final p in _pembeliList) {
      if (p.tiketList.isNotEmpty) {
        totalPembeliAktif++;
        totalTiket += p.tiketList.length;
        for (final t in p.tiketList) {
          totalDana += t.total;
        }
      }
    }

    print("\n📊 STATISTIK:");
    print("Total tiket terjual: $totalTiket");
    print("Total pendapatan: Rp$totalDana");
    print("Total pembeli aktif: $totalPembeliAktif");
  }
}

void main() {
  print("=" * 50);
  print("   🎬 CINEBOOK - SISTEM TIKET BIOSKOP (OOP SOLID)");
  print("=" * 50);

  final system = CineBookSystem();
  system.printDaftarFilm();

  print("\n📋 PEMESANAN:");

  final pesanan = [
    ["Azriel", 0, 0, "19:30", ["A1", "A2"]],
    ["Esti", 0, 0, "19:30", ["A3"]],
    ["Ratu", 1, 1, "21:00", ["C1", "C2"]],
    ["Alicia", 1, 1, "21:00", ["C3"]],
    ["Budi", 0, 0, "19:30", ["B1"]],
    ["Siti", 1, 1, "21:00", ["D1", "D2"]],
    ["Andi", 2, 2, "15:00", ["A1", "A2"]],
    ["Dewi", 2, 2, "15:00", ["A3"]],
    ["Rizky", 0, 0, "19:30", ["B2"]],
    ["Maya", 1, 1, "21:00", ["E1"]],
  ];

  int counter = 1;
  for (final p in pesanan) {
    final nama = p[0] as String;
    final filmIndex = p[1] as int;
    final studioIndex = p[2] as int;
    final kodeKursi = List<String>.from(p[4] as List);

    final ticketId = 'TIX${counter.toString().padLeft(3, '0')}';
    
    final sukses = system.prosesBooking(
      namaPembeli: nama,
      filmIndex: filmIndex,
      studioIndex: studioIndex,
      kodeKursiList: kodeKursi,
      ticketId: ticketId,
    );

    if (sukses) {
      counter++;
    }
  }

  system.cetakSemuaTiket();
  system.cetakStatistik();

  print("\n🎬 TERIMA KASIH!");
}

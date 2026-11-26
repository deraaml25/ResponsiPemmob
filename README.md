# Cuaca Kita 🌦️

Aplikasi prakiraan cuaca modern dan estetis berbasis Flutter & Dart yang mengintegrasikan data cuaca real-time dan prakiraan 7 hari dari **Open-Meteo API**. Dibangun dengan arsitektur **Model-View-ViewModel (MVVM)**, state management **Provider**, persistensi data lokal **SharedPreferences**, serta desain antarmuka modern yang mengadopsi gaya **Glassmorphism**, kartu kota berwarna dinamis per kondisi cuaca, animasi awan mengambang halus (*CloudBackground*), dan palet warna Sand (*Contrast Safe AA*).

---

## 🎨 Target & Konsep Desain Baru

Desain aplikasi ini mengadopsi referensi gaya antarmuka cuaca modern:
1. **Gradasi Layar Dinamis (Weather-Based Atmosphere)**:
   - Warna latar belakang layar utama (*Home Screen*) bertransisi secara halus (~600 ms) menyesuaikan kondisi cuaca saat ini dari kota yang sedang dibuka.
   - Dilengkapi lapisan dekorasi **awan animasi lembut (`CloudBackground`)** yang melayang di latar belakang, serta menghormati aksesibilitas `MediaQuery.disableAnimations`.
2. **Kartu Favorit Berwarna (City Weather Cards)**:
   - Pada layar pencarian (*Search Screen*), daftar lokasi favorit tampil dalam bentuk **kartu berwarna sesuai kondisi cuaca** (tinggi ~98 px, sudut membulat 24 px) lengkap dengan nama kota, deskripsi cuaca Indonesia, suhu besar, dan ikon cuaca besar di kanan bawah.
   - Data cuaca untuk tiap kartu favorit dimuat secara paralel (`Future.wait`) dari Open-Meteo API dengan status terisolasi (*loading / success / error*).
3. **Glassmorphism & Elemen Bulat**:
   - Komponen statistik dan prakiraan harian menggunakan kartu kaca frosted (`GlassCard`) dengan efek blur dan garis batas semi-transparan.
   - Tombol navigasi dan aksi berbentuk bulat sempurna dengan area sentuh minimum 48x48 px (`GlassIconButton`) dan dukungan Semantics/Tooltip.

### Palet Warna Sand Terpusat (`AppColors`)
- **Spring Meadow (`#CAFFA6`)**: Aksen hijau cerah untuk chip peluang hujan dan highlight.
- **Teal Waters (`#204654`)**: Teks utama yang tegas, kontras tinggi (minimal 4.5:1), dan ikon primer.
- **Glacial Sky (`#A9E0F1`)**: Warna biru langit Sand untuk wadah sekunder dan tema default.
- **Morning Mist (`#F7F9E1`)**: Putih gading lembut untuk background terang dan teks di atas warna gelap.

### Pemetaan Warna per Kondisi Cuaca (`WeatherThemeHelper`)
- **Cerah (0, 1)**: Gradasi `#F9D34A` -> `#F29A1B`, teks `Teal Waters` `#204654`
- **Berawan (2, 3)**: Gradasi `#7C58A6` -> `#3F2F82`, teks putih (`#FFFFFF`)
- **Berkabut (45, 48)**: Gradasi `#6F8A94` -> `#46606B`, teks putih (`#FFFFFF`)
- **Gerimis / Hujan (51-67, 80-82)**: Gradasi `#5A7187` -> `#374C61`, teks putih (`#FFFFFF`)
- **Salju (71-77, 85, 86)**: Gradasi `#4A8EEA` -> `#2456C4`, teks putih (`#FFFFFF`)
- **Badai Petir (95-99)**: Gradasi `#4B4A7A` -> `#23224A`, teks putih (`#FFFFFF`)
- **Default / Sand**: Gradasi `#A9E0F1` -> `#F7F9E1`, teks `Teal Waters` `#204654`

---

## ✨ Fitur Utama
1. **Layar Home (Cuaca Utama)**:
   - Sapaan ramah kontekstual waktu (*"Selamat Pagi"*, *"Selamat Siang"*, *"Selamat Sore"*, *"Selamat Malam"*).
   - Nama kota, provinsi/negara, dan tanggal format Indonesia (*"Hari ini, Kamis 26 Nov"*).
   - Ikon cuaca besar (diameter 124 px) di dalam lingkaran transparan bercahaya.
   - Suhu sangat besar (64 px), deskripsi kondisi cuaca Indonesia, serta rentang suhu (*"Tertinggi X° - Terendah Y°"*).
   - Kartu statistik kaca 3 kolom: **Kelembapan**, **Kecepatan Angin (km/j)**, dan **Peluang Hujan**, ditambah 2 kartu sekunder: **Terasa Seperti** dan **Curah Hujan**.
   - Strip prakiraan 7 hari horizontal yang dapat digeser (*DailyForecastStrip*).
   - Fitur **Pull-to-Refresh** untuk memperbarui cuaca secara instan.

2. **Layar Search & Favorit**:
   - Header ramah dengan tombol kembali bulat kaca dan judul *"Cari lokasi"*.
   - Kolom pencarian bergaya kaca dengan mekanisme **Debounce 500 ms**.
   - Tampilan default kolom kosong: **Daftar Kartu Lokasi Favorit Berwarna** yang memuat cuaca real-time dari API.
   - Responsif 2 kolom pada layar tablet/desktop (lebar >= 600 px).
   - Fitur hapus favorit dengan geser kartu ke kiri (*Swipe to Dismiss*) atau tekan tombol hati.

---

## 🛠️ Tech Stack
- **Framework**: [Flutter](https://flutter.dev) (Dart SDK ^3.13)
- **Arsitektur**: Model-View-ViewModel (MVVM)
- **State Management**: [Provider](https://pub.dev/packages/provider) (`ChangeNotifier`)
- **Networking**: [http](https://pub.dev/packages/http) (Open-Meteo Geocoding & Forecast API)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Typography & Theme**: [google_fonts](https://pub.dev/packages/google_fonts) (Plus Jakarta Sans)
- **Date Formatting**: [intl](https://pub.dev/packages/intl)

---

## 📂 Struktur Berkas & Berkas Baru
```text
lib/
├── main.dart                               # Inisialisasi service & MultiProvider
├── core/
│   ├── constants/
│   │   └── view_state.dart                 # Enum ViewState { initial, loading, success, empty, error }
│   ├── exceptions/
│   │   └── app_exception.dart              # Penanganan exception ramah pengguna
│   ├── theme/
│   │   ├── app_theme.dart                  # Palet Sand di AppColors & ThemeData terpusat
│   │   └── weather_theme_helper.dart       # [BARU] Pemetaan gradasi & teks per weather code
│   └── utils/
│       ├── greeting_helper.dart            # [BARU] Sapaan waktu Bahasa Indonesia
│       └── weather_code_helper.dart        # Mapper kode WMO ke teks & ikon cuaca
├── models/
│   ├── location_model.dart                 # Model kota hasil geocoding
│   ├── weather_model.dart                  # Model cuaca terkini & prakiraan 7 hari
│   └── favorite_weather.dart               # [BARU] Model item favorit + cuaca + status
├── services/
│   ├── geocoding_service.dart              # Client API Geocoding Open-Meteo
│   ├── weather_service.dart                # Client API Forecast Open-Meteo
│   └── favorite_storage_service.dart       # SharedPreferences favorit & lokasi terakhir
├── viewmodels/
│   ├── weather_viewmodel.dart              # Mengelola state layar utama
│   ├── search_viewmodel.dart               # Mengelola pencarian kota & debounce 500ms
│   └── favorite_viewmodel.dart             # [DIUBAH] Pengambilan cuaca favorit paralel
└── views/
    ├── home/
    │   └── weather_screen.dart             # [DIUBAH] Layar Home dengan hero layout & gradasi dinamis
    ├── search/
    │   └── search_screen.dart              # [DIUBAH] Layar Search dengan kartu favorit berwarna
    └── widgets/
        ├── cloud_background.dart           # [BARU] Awan melayang lembut di background
        ├── glass_card.dart                 # [BARU] Kartu kaca frosted glassmorphism
        ├── glass_icon_button.dart          # [BARU] Tombol kaca bulat sentuh 48x48
        ├── city_weather_card.dart          # [BARU] Kartu kota favorit berwarna per kondisi cuaca
        ├── stat_row.dart                   # [BARU] Kartu statistik kaca 3 kolom + 2 kartu mini
        ├── daily_forecast_strip.dart       # [BARU] Strip prakiraan 7 hari horizontal
        ├── current_weather_card.dart       # Komponen kartu cuaca alternatif
        ├── forecast_tile.dart              # Komponen baris harian alternatif
        ├── info_tile.dart                  # Komponen tile metrik alternatif
        └── state_widgets.dart              # Loading, ErrorState, dan EmptyState bergaya kaca
```

---

## 🏗️ Penerapan Arsitektur MVVM
Pemisahan tanggung jawab (*Separation of Concerns*) diterapkan secara disiplin:

```
┌────────────────┐          ┌───────────────────┐          ┌─────────────────┐          ┌──────────────┐
│      VIEW      │ ───────> │     VIEWMODEL     │ ───────> │     SERVICE     │ ───────> │  MODEL / API │
│ (Widget / UI)  │ <....... │ (ChangeNotifier)  │ <....... │ (HTTP & Storage)│ <....... │    (JSON)    │
└────────────────┘ (Listen) └───────────────────┘ (Notify) └─────────────────┘          └──────────────┘
```

1. **View**: Hanya menampilkan UI, mendengarkan perubahan data melalui `context.watch<T>()`, dan mengirimkan event interaksi ke ViewModel (`context.read<T>()`). Tidak ada logika HTTP atau kalkulasi data di dalam View.
2. **ViewModel**: Mewarisi `ChangeNotifier`, mengelola state tampilan menggunakan `ViewState` (`initial`, `loading`, `success`, `empty`, `error`), serta memanggil Service untuk mengambil data secara paralel.
3. **Service**: Menangani operasi jaringan I/O murni (Open-Meteo HTTP GET dengan batas waktu 10 detik) dan persistensi SharedPreferences.
4. **Model**: Entitas data murni (`LocationModel`, `WeatherData`, `FavoriteWeather`).

---

## 📸 Tangkapan Layar Aplikasi (Screenshots Placeholder)

| Home (Cerah) | Home (Hujan) | Home (Berawan) | Search & Kartu Favorit | State Error / Offline |
|:---:|:---:|:---:|:---:|:---:|
| *(Screenshot Cerah)* | *(Screenshot Hujan)* | *(Screenshot Berawan)* | *(Screenshot Search & Favorit)* | *(Screenshot Error)* |
| Gradasi hangat `#F9D34A` | Gradasi sejuk `#5A7187` | Gradasi ungu `#7C58A6` | Kartu warna-warni tiap kota | Tombol "Coba Lagi" & pesan ramah |

---

## 🎬 Panduan Skrip Penjelasan Video

### Alur Data Kartu Favorit (Search -> FavoriteViewModel -> WeatherService -> Model -> View):
1. **Layar Dibuka (`SearchScreen`)**:
   - Begitu layar dibuka, `WidgetsBinding.instance.addPostFrameCallback` memicu `favoriteVM.loadFavorites()`.
2. **Pengambilan Lokasi dari Storage (`FavoriteStorageService`)**:
   - `FavoriteViewModel` memuat daftar kota tersimpan dari `SharedPreferences`.
   - List dibungkus ke dalam objek `FavoriteWeather` dengan status awal `ViewState.loading`. Layar langsung me-render kartu kaca dengan indikator pemuatan mini.
3. **Panggilan Paralel ke Server (`WeatherService`)**:
   - Menggunakan `Future.wait`, `FavoriteViewModel` memanggil `weatherService.fetchWeather()` untuk semua kota secara bersamaan tanpa saling memblokir (*non-blocking parallel request*).
4. **Isolasi Error per Kartu**:
   - Jika salah satu kota gagal memuat cuaca (misal karena timeout/jaringan), hanya kartu tersebut yang berubah ke `ViewState.error` dengan tombol *"Coba lagi"*, sementara kota lain tetap tampil normal (`ViewState.success`).
5. **Pemetaan ke Model & Rendering Warna (`CityWeatherCard`)**:
   - Data JSON dari API dipetakan menjadi model `WeatherData`.
   - `CityWeatherCard` membaca `current.weatherCode` dan meminta palet warna dari `WeatherThemeHelper.getPalette(code)`.
   - Kartu langsung berubah warna mengikuti kondisi cuaca terkini (Cerah = oranye matahari, Hujan = biru tua, Berawan = ungu elegan) lengkap dengan suhu besar dan ikon di pojok kanan bawah.

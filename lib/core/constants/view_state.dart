// Enum untuk mengelola status tampilan UI pada arsitektur MVVM
enum ViewState {
  initial, // Keadaan awal sebelum ada aksi atau pemuatan data
  loading, // Sedang memuat data dari API atau local storage
  success, // Data berhasil didapatkan dan siap ditampilkan
  empty,   // Permintaan berhasil namun data kosong (misal: kota tidak ditemukan)
  error,   // Terjadi kesalahan jaringan, timeout, atau parsing data
}

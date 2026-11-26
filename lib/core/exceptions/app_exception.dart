/// Kelas custom exception untuk pesan kesalahan ramah pengguna dalam Bahasa Indonesia
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

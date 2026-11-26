/// Helper untuk memberikan sapaan ramah dalam Bahasa Indonesia berdasarkan waktu lokal
class GreetingHelper {
  static String getGreeting([DateTime? time]) {
    final now = time ?? DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final timeInMinutes = hour * 60 + minute;

    if (timeInMinutes >= 4 * 60 && timeInMinutes < 11 * 60) {
      return 'Selamat Pagi';
    } else if (timeInMinutes >= 11 * 60 && timeInMinutes < 15 * 60) {
      return 'Selamat Siang';
    } else if (timeInMinutes >= 15 * 60 && timeInMinutes < 18 * 60 + 30) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}

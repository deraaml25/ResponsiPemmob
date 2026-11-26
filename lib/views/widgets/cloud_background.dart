import 'package:flutter/material.dart';

/// Widget dekorasi awan melayang pelan di atas gradasi cuaca
/// Menghormati pengaturan aksesibilitas MediaQuery.disableAnimations
class CloudBackground extends StatefulWidget {
  final Widget child;

  const CloudBackground({
    super.key,
    required this.child,
  });

  @override
  State<CloudBackground> createState() => _CloudBackgroundState();
}

class _CloudBackgroundState extends State<CloudBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animasi melayang lambat & terus-menerus
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Stack(
      children: [
        // Lapisan Awan Melayang di Latar Belakang
        Positioned.fill(
          child: disableAnimations
              ? const _StaticClouds()
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return _AnimatedClouds(progress: _controller.value);
                  },
                ),
        ),

        // Konten Layar di Atas Awan
        widget.child,
      ],
    );
  }
}

/// Awan statis jika animasi dinonaktifkan oleh sistem
class _StaticClouds extends StatelessWidget {
  const _StaticClouds();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _CloudPainter(offsets: const [0.1, 0.45, 0.8]),
      ),
    );
  }
}

/// Awan yang melayang halus secara horizontal
class _AnimatedClouds extends StatelessWidget {
  final double progress;

  const _AnimatedClouds({required this.progress});

  @override
  Widget build(BuildContext context) {
    final double offset1 = (progress * 1.0) % 1.0;
    final double offset2 = (progress * 0.7 + 0.35) % 1.0;
    final double offset3 = (progress * 0.4 + 0.7) % 1.0;

    return IgnorePointer(
      child: CustomPaint(
        painter: _CloudPainter(offsets: [offset1, offset2, offset3]),
      ),
    );
  }
}

/// CustomPainter untuk menggambar bentuk awan lembut dengan transparansi
class _CloudPainter extends CustomPainter {
  final List<double> offsets;

  _CloudPainter({required this.offsets});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    // Awan 1 (Atas Kiri -> Kanan)
    if (offsets.isNotEmpty) {
      final double x1 = (offsets[0] * (size.width + 160)) - 80;
      final double y1 = size.height * 0.12;
      _drawCloudShape(canvas, Offset(x1, y1), 55, paint);
    }

    // Awan 2 (Tengah)
    if (offsets.length > 1) {
      final double x2 = (offsets[1] * (size.width + 200)) - 100;
      final double y2 = size.height * 0.28;
      _drawCloudShape(canvas, Offset(x2, y2), 70, paint);
    }

    // Awan 3 (Bawah)
    if (offsets.length > 2) {
      final double x3 = (offsets[2] * (size.width + 180)) - 90;
      final double y3 = size.height * 0.48;
      _drawCloudShape(canvas, Offset(x3, y3), 60, paint);
    }
  }

  void _drawCloudShape(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center.translate(-radius * 0.55, radius * 0.2), radius * 0.65, paint);
    canvas.drawCircle(center.translate(radius * 0.6, radius * 0.15), radius * 0.7, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, radius * 0.4),
          width: radius * 2.2,
          height: radius * 0.7,
        ),
        Radius.circular(radius * 0.35),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => true;
}

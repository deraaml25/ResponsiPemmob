import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Tombol ikon bulat bergaya kaca (Glassmorphism)
/// Memiliki area sentuh minimum 48x48 px dan mendukung Semantics / Tooltip
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.size = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Center(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundColor ?? AppColors.glassWhite,
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: size,
                        color: iconColor ?? AppColors.tealWaters,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

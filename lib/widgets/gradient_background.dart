import 'package:auroria/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -90,
            right: -70,
            child: _Glow(color: AppColors.pinkGlow, size: 280),
          ),
          const Positioned(
            bottom: -110,
            left: -90,
            child: _Glow(color: AppColors.cyanGlow, size: 320),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, const Color(0x00000000)],
        ),
      ),
    );
  }
}
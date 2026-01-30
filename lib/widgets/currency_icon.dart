import 'package:flutter/material.dart';

// Helper widget для загрузки иконок с fallback
class CurrencyIcon extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final double size;
  final double backgroundOpacity;

  const CurrencyIcon({
    required this.imagePath,
    required this.backgroundColor,
    this.size = 50,
    this.backgroundOpacity = 0.1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: size - 16,
          height: size - 16,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback если изображение не найдено
            return Container(
              width: size - 16,
              height: size - 16,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size / 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
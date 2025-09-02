import 'package:flutter/material.dart';
import 'package:sobrius_app/core/app_colors.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient gradient;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient = AppColors.buttonGradient, // Gradiente padrão
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 3), // Sombra para dar profundidade
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? AppColors.darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButton extends StatelessWidget {
  final String assetIcon; // path untuk icon svg
  final String label; // text yanga da pada button
  final Color backgroundColor; 
  final Color foregroundColor;
  final VoidCallback onPressed;

  const SocialAuthButton({super.key, required this.assetIcon, required this.label, required this.backgroundColor, required this.foregroundColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(assetIcon, height: 24, width: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(
          color: backgroundColor == Colors.white ? Colors.grey : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
    );
  }
}
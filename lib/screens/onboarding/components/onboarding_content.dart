import 'package:flutter/material.dart';
import 'package:peekit_app/utils/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar (posisi agak tengah dan proporsional)
          SizedBox(
            height: size.height * 0.33,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 70),

          // Bagian teks
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

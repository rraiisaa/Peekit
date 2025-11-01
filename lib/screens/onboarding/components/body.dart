import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/data/onboarding_data.dart';
import 'package:peekit_app/screens/onboarding/components/onboarding_content.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/utils/constants.dart';
import 'package:peekit_app/routes/app_pages.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian tengah (gambar + teks)
            SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onBoardingData.length,
                itemBuilder: (context, index) => OnboardingContent(
                  image: onBoardingData[index].image,
                  title: onBoardingData[index].title,
                  description: onBoardingData[index].description,
                ),
              ),
            ),

            // Bagian bawah (dots + tombol)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardingData.length,
                      (index) => _dotsIndicator(index: index),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Tombol Next / Start
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.055,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (currentPage == onBoardingData.length - 1) {
                          Get.offAllNamed(Routes.LOGIN);
                        } else {
                          _pageController.animateToPage(
                            currentPage + 1,
                            duration: animationDuration,
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(
                        currentPage == onBoardingData.length - 1
                            ? "Start"
                            : "Next",
                        style: TextStyle(
                          color: AppColors.textAdded,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _dotsIndicator({required int index}) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: currentPage == index
            ? AppColors.primary
            : AppColors.textSecondary,
      ),
      width: currentPage == index ? 20 : 7,
      height: 5,
      duration: animationDuration,
    );
  }
}

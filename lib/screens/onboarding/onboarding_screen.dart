import 'package:flutter/material.dart';
import 'package:peekit_app/screens/onboarding/components/body.dart';
import 'package:peekit_app/utils/size_config.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body()
    );
  }
}
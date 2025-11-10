import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/shared_preferences.dart';
import '../../../model/on_boarding.dart';
import '../../../utils/constants/image_strings.dart';
import '../widgets/custom_dots_indicator.dart';
import '../widgets/gradient_container.dart';
import '../widgets/on_boarding_button.dart';
import '../widgets/on_boarding_card.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(onboardingList[_currentIndex].bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientContainer(
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingList.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    return OnboardingCard(onboarding: onboardingList[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomDotsIndicator(
                dotsCount: onboardingList.length,
                position: _currentIndex.toDouble(),
              ),
              const SizedBox(height: 30),
              OnBoardingButton(
                onTap: () {
                  if (_currentIndex != onboardingList.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                  } else {
                    Get.offAll(() => Container());
                    MyGetXStorage.isFirstTime = false;
                  }
                },
                text: _currentIndex == onboardingList.length - 1 ? '' : '',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

List<Onboarding> onboardingList = [
  Onboarding(
    bgImage: ImageStrings.authBackground,
    title: '',
    info: '',
  ),
  Onboarding(
    bgImage: ImageStrings.authBackground,
    title: '',
    info: '',
  ),
  Onboarding(
    bgImage: ImageStrings.authBackground,
    title: '',
    info: '',
  ),
  Onboarding(
    bgImage: ImageStrings.authBackground,
    title: '',
    info: '',
  ),
];

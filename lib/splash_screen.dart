import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
import 'services/deep_link_service.dart';
import 'services/version_check_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() async {
    const nextPage = BottomNavPage();

    // Navigate to the main page first
   await  Navigator.pushReplacement(
      context,
      PageTransition(type: PageTransitionType.fade, child: nextPage),
    );

    // Mark the app as fully initialized after navigation completes
    // This ensures the UI is ready and toasts can be displayed
    await Future.delayed(const Duration(milliseconds: 500));
    await DeepLinkService.markAppAsInitialized();

    // Check for app updates after the app is fully initialized
    await Future.delayed(const Duration(milliseconds: 1000));
    await VersionCheckService.checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logos/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

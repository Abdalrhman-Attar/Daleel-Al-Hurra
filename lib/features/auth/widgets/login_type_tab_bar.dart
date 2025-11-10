import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/translation_service.dart';

class LoginTypeTabBar extends StatelessWidget {
  const LoginTypeTabBar({
    super.key,
    required this.controller,
  });

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildTabBarItem(
                  Get.find<TranslationService>().tr('phone number'),
                  controller.isPhoneNumberSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarItem(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.toggleType();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.black
                  : Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

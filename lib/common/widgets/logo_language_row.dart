import 'package:flutter/material.dart';

import 'app_logo.dart';
import 'language_drop_down.dart';

class LogoLanguageRow extends StatelessWidget {
  const LogoLanguageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          const AppLogo(height: 120),
          const Spacer(),
          LanguageDropDown(),
        ],
      ),
    );
  }
}

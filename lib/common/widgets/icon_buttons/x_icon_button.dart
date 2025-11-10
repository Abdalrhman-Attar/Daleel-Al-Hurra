import 'package:flutter/material.dart';

class XIconButton extends StatelessWidget {
  const XIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close_rounded, size: 30, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

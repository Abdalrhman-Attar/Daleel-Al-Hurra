import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.text,
    required this.icon,
    required this.child,
    this.press,
  });

  final String text;
  final Widget icon;
  final Widget child;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        text,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      child,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

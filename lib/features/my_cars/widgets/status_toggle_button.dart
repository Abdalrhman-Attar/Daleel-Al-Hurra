import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';

class StatusToggleButton extends StatelessWidget {
  const StatusToggleButton({
    super.key,
    required this.isActive,
    required this.onToggle,
    this.isLoading = false,
  });

  final bool isActive;
  final VoidCallback onToggle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: isLoading ? null : onToggle,
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LoadingShimmer(),
                )
              : Icon(
                  isActive ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                  color: isActive ? Colors.green : Colors.grey,
                ),
        ),
      ),
    );
  }
}

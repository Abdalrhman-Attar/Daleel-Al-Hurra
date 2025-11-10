import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../../main.dart';

class CustomAdvanceSwitch extends StatefulWidget {
  final double radius;
  final double thumbRadius;
  final Widget? activeChild;
  final Widget? inactiveChild;
  final ValueNotifier<bool>? controller;
  final Function(bool)? onChanged;
  final bool? initialValue;

  const CustomAdvanceSwitch({
    super.key,
    this.radius = 40,
    this.thumbRadius = 100,
    this.activeChild,
    this.inactiveChild,
    this.controller,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomAdvanceSwitch> createState() => _CustomAdvanceSwitchState();
}

class _CustomAdvanceSwitchState extends State<CustomAdvanceSwitch> {
  late final ValueNotifier<bool> _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? ValueNotifier<bool>(widget.initialValue ?? false);
    _controller.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(CustomAdvanceSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller value if the initial value changes
    if (widget.initialValue != null &&
        widget.initialValue != _controller.value) {
      _controller.value = widget.initialValue!;
    }
  }

  void _handleChange() {
    widget.onChanged?.call(_controller.value);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedSwitch(
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).colorScheme.secondary,
      activeChild: widget.activeChild ?? Text(tr('on')),
      inactiveChild: widget.inactiveChild ?? Text(tr('off')),
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      width: 80,
      height: 36,
      initialValue: _controller.value,
      thumb: Container(
        margin: const EdgeInsets.all(5),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.thumbRadius),
        ),
      ),
      controller: _controller,
    );
  }
}

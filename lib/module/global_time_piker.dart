import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class GlobalTimePicker extends StatefulWidget {
  final String? label;
  final String hint;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool enabled;
  final String? errorText;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;
  final String? identifier;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final Widget Function(BuildContext, Widget?)? builder;
  final String? Function(TimeOfDay?)? validator;
  final double maxHeight;
  final bool use24HourFormat;
  final TimePickerEntryMode timePickerEntryMode;

  const GlobalTimePicker({
    super.key,
    this.label,
    required this.hint,
    this.selectedTime,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.infoLabel,
    this.onInfoLabelTap,
    this.identifier,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.builder,
    this.validator,
    this.maxHeight = 300,
    this.use24HourFormat = false,
    this.timePickerEntryMode = TimePickerEntryMode.dial,
  });

  @override
  State<GlobalTimePicker> createState() => _GlobalTimePickerState();
}

class _GlobalTimePickerState extends State<GlobalTimePicker> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _timePickerKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _open = false;
  bool _focused = false;
  bool _showAbove = false;

  late TimeOfDay _currentTime;

  // Apple-style picker controllers
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();

    _currentTime = widget.selectedTime ?? TimeOfDay.now();
    _initializeControllers();

    // Listen for scroll events to close picker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollable = Scrollable.of(context);
      scrollable.position.isScrollingNotifier.addListener(() {
        if (scrollable.position.isScrollingNotifier.value && _open) {
          _removeOverlay();
        }
      });
    });
  }

  void _initializeControllers() {
    if (widget.use24HourFormat) {
      _hourController =
          FixedExtentScrollController(initialItem: _currentTime.hour);
      _minuteController =
          FixedExtentScrollController(initialItem: _currentTime.minute);
      _periodController =
          FixedExtentScrollController(initialItem: 0); // Not used for 24h
    } else {
      final hour12 =
          _currentTime.hourOfPeriod == 0 ? 12 : _currentTime.hourOfPeriod;
      _hourController = FixedExtentScrollController(initialItem: hour12 - 1);
      _minuteController =
          FixedExtentScrollController(initialItem: _currentTime.minute);
      _periodController = FixedExtentScrollController(
        initialItem: _currentTime.period == DayPeriod.am ? 0 : 1,
      );
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  List<String> _getHoursList() {
    if (widget.use24HourFormat) {
      return List.generate(24, (index) => index.toString().padLeft(2, '0'));
    } else {
      return List.generate(12, (index) => (index + 1).toString());
    }
  }

  List<String> _getMinutesList() {
    return List.generate(60, (index) => index.toString().padLeft(2, '0'));
  }

  List<String> _getPeriodsList() {
    return ['AM', 'PM'];
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _calculatePosition();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _open = true;
      _focused = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _open = false;
        _focused = false;
      });
    }
  }

  void _calculatePosition() {
    final rb = _timePickerKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) return;

    final pos = rb.localToGlobal(Offset.zero);
    final dropdownHeight = rb.size.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final spaceAbove = pos.dy;
    final spaceBelow = screenHeight - keyboardHeight - pos.dy - dropdownHeight;

    _showAbove = spaceAbove > spaceBelow && spaceAbove > widget.maxHeight + 50;
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(builder: (context) {
      final rb =
          _timePickerKey.currentContext?.findRenderObject() as RenderBox?;
      final height = rb?.size.height ?? 0;
      final width = rb?.size.width ?? 300;

      return GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: _showAbove
                  ? Offset(0, -widget.maxHeight - 8)
                  : Offset(0, height + 8),
              child: Material(
                elevation: 8,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: width,
                  height: widget.maxHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _buildAppleStylePicker(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAppleStylePicker() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _removeOverlay,
                child: Text(
                  widget.cancelText ?? S.current.cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    S.current.selectTime,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  _buildTimePickerIcon(),
                ],
              ),
              TextButton(
                onPressed: () {
                  widget.onChanged?.call(_currentTime);
                  _removeOverlay();
                },
                child: Text(
                  widget.confirmText ?? S.current.done,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Picker wheels
        Expanded(
          child: Row(
            children: [
              // Hour picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: _hourController,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    if (widget.use24HourFormat) {
                      _updateTime(hour: index);
                    } else {
                      final hour12 = index + 1;
                      final hour24 = _currentTime.period == DayPeriod.am
                          ? (hour12 == 12 ? 0 : hour12)
                          : (hour12 == 12 ? 12 : hour12 + 12);
                      _updateTime(hour: hour24);
                    }
                  },
                  children: _getHoursList()
                      .map((hour) => Center(
                            child: Text(
                              hour,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // Separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              // Minute picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: _minuteController,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    _updateTime(minute: index);
                  },
                  children: _getMinutesList()
                      .map((minute) => Center(
                            child: Text(
                              minute,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // AM/PM picker (only for 12-hour format)
              if (!widget.use24HourFormat)
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _periodController,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      final period = index == 0 ? DayPeriod.am : DayPeriod.pm;
                      final currentHour12 = _currentTime.hourOfPeriod == 0
                          ? 12
                          : _currentTime.hourOfPeriod;
                      final newHour24 = period == DayPeriod.am
                          ? (currentHour12 == 12 ? 0 : currentHour12)
                          : (currentHour12 == 12 ? 12 : currentHour12 + 12);
                      _updateTime(hour: newHour24);
                    },
                    children: _getPeriodsList()
                        .map((period) => Center(
                              child: Text(
                                period,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateTime({int? hour, int? minute}) {
    final newHour = hour ?? _currentTime.hour;
    final newMinute = minute ?? _currentTime.minute;

    setState(() {
      _currentTime = TimeOfDay(hour: newHour, minute: newMinute);
    });

    _overlayEntry?.markNeedsBuild();
  }

  Future<void> _showFlutterTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay.now(),
      initialEntryMode: widget.timePickerEntryMode,
      helpText: widget.helpText,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      builder: widget.builder,
    );

    if (picked != null) {
      setState(() {
        _currentTime = picked;
      });
      widget.onChanged?.call(picked);
    }
  }

  Widget _buildHeader(BuildContext context) {
    if (widget.label == null && widget.infoLabel == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.label != null)
            Expanded(
              child: Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          if (widget.infoLabel != null) _buildInfoIcon(),
        ],
      ),
    );
  }

  Widget _buildInfoIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onInfoLabelTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.info_outline,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTimePickerIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.enabled ? _showFlutterTimePicker : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.access_time,
          size: 22,
          color: widget.enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return widget.hint;

    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour12:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = widget.selectedTime != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        key: _timePickerKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          GestureDetector(
            onTap: widget.enabled ? _toggleDropdown : null,
            child: MouseRegion(
              cursor: widget.enabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.forbidden,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.errorText != null
                        ? colorScheme.error
                        : _focused
                            ? colorScheme.primary
                            : Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.5),
                    width: _focused ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: widget.enabled
                      ? colorScheme.surface
                      : colorScheme.surface.withValues(alpha: 0.6),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatTime(widget.selectedTime),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasValue
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      color: widget.enabled
                          ? colorScheme.onSurface.withValues(alpha: 0.6)
                          : colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                widget.errorText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

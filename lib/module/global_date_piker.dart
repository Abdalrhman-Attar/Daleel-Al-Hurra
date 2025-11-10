import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global_text_field.dart';

class GlobalDatePicker extends StatefulWidget {
  final String? label;
  final String hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? errorText;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;
  final DatePickerEntryMode datePickerEntryMode;
  final String? identifier;
  final DatePickerMode initialDatePickerMode;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final Locale? locale;
  final TextDirection? textDirection;
  final Widget Function(BuildContext, Widget?)? builder;
  final String? Function(DateTime?)? validator;
  final double maxHeight;

  const GlobalDatePicker({
    super.key,
    this.label,
    required this.hint,
    this.selectedDate,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.errorText,
    this.infoLabel,
    this.onInfoLabelTap,
    this.datePickerEntryMode = DatePickerEntryMode.calendar,
    this.identifier,
    this.initialDatePickerMode = DatePickerMode.day,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.textDirection,
    this.builder,
    this.validator,
    this.maxHeight = 300,
  });

  @override
  State<GlobalDatePicker> createState() => _GlobalDatePickerState();
}

class _GlobalDatePickerState extends State<GlobalDatePicker> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _datePickerKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _open = false;
  bool _showAbove = false;

  late DateTime _currentDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  // Apple-style picker controllers
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _currentDate = widget.selectedDate ?? now;
    _firstDate = widget.firstDate ?? DateTime(now.year - 100);
    _lastDate = widget.lastDate ?? DateTime(now.year + 100);

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
    final years = _getYearsList();
    final currentYearIndex = years.indexOf(_currentDate.year);

    _dayController =
        FixedExtentScrollController(initialItem: _currentDate.day - 1);
    _monthController =
        FixedExtentScrollController(initialItem: _currentDate.month - 1);
    _yearController = FixedExtentScrollController(
      initialItem: currentYearIndex >= 0 ? currentYearIndex : 0,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  List<int> _getYearsList() {
    return List.generate(
      _lastDate.year - _firstDate.year + 1,
      (index) => _firstDate.year + index,
    );
  }

  List<String> _getMonthsList() {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
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
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _open = false;
      });
    }
  }

  void _calculatePosition() {
    final rb = _datePickerKey.currentContext?.findRenderObject() as RenderBox?;
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
          _datePickerKey.currentContext?.findRenderObject() as RenderBox?;
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
                  widget.cancelText ?? 'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Select Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  _buildDatePickerIcon(),
                ],
              ),
              TextButton(
                onPressed: () {
                  widget.onChanged?.call(_currentDate);
                  _removeOverlay();
                },
                child: Text(
                  widget.confirmText ?? 'Done',
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
              // Month picker
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  scrollController: _monthController,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    _updateDate(month: index + 1);
                  },
                  children: _getMonthsList()
                      .map((month) => Center(
                            child: Text(
                              month,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // Day picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: _dayController,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    _updateDate(day: index + 1);
                  },
                  children: List.generate(
                    _getDaysInMonth(_currentDate.year, _currentDate.month),
                    (index) => Center(
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),

              // Year picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: _yearController,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    final years = _getYearsList();
                    _updateDate(year: years[index]);
                  },
                  children: _getYearsList()
                      .map((year) => Center(
                            child: Text(
                              '$year',
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

  void _updateDate({int? year, int? month, int? day}) {
    final newYear = year ?? _currentDate.year;
    final newMonth = month ?? _currentDate.month;
    var newDay = day ?? _currentDate.day;

    // Ensure day is valid for the new month/year
    final daysInNewMonth = _getDaysInMonth(newYear, newMonth);
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    setState(() {
      _currentDate = DateTime(newYear, newMonth, newDay);
    });

    // Update controllers if needed
    if (month != null) {
      final daysInMonth =
          _getDaysInMonth(_currentDate.year, _currentDate.month);
      if (_currentDate.day > daysInMonth) {
        _dayController.jumpToItem(daysInMonth - 1);
      }
    }

    _overlayEntry?.markNeedsBuild();
  }

  Future<void> _showFlutterDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialEntryMode: widget.datePickerEntryMode,
      initialDatePickerMode: widget.initialDatePickerMode,
      helpText: widget.helpText,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      locale: widget.locale,

      //  use24hFormat: widget.use24HourFormat,
      textDirection: widget.textDirection,
      builder: widget.builder,
    );

    if (picked != null) {
      setState(() {
        _currentDate = picked;
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

  Widget _buildDatePickerIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.enabled ? _showFlutterDatePicker : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.calendar_today,
          size: 22,
          color: widget.enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return widget.hint;
    return '${_getMonthsList()[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = widget.selectedDate != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        key: _datePickerKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          GlobalTextFormField(
            hint: widget.hint,
            enabled: widget.enabled,
            readOnly: true,
            onTap: _toggleDropdown,
            controller: TextEditingController(
                text: widget.selectedDate == null
                    ? null
                    : _formatDate(widget.selectedDate)),
            //validator: widget.validator,
            textColor: hasValue
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.6),
            errorText: widget.errorText,
            suffixIcon: Icons.date_range,
            onSuffixIconTap: widget.enabled ? _toggleDropdown : null,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/translation_service.dart';
import '../utils/constants/colors.dart';
import 'global_text_field.dart';

class DropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final Widget? trailing;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
  });
}

class GlobalDropdown<T> extends StatefulWidget {
  final List<DropdownItem<T>> items;
  final T? selectedValue;
  final List<T>? selectedValues;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onMultiChanged;
  final String hint;
  final String? label;
  final String? searchIdentifier;
  final bool enableSearch;
  final bool multiSelect;
  final double maxHeight;
  final bool enabled;
  final String? errorText;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedItemColor;

  // New properties to match GlobalTextFormField styling
  final BorderRadius? borderRadius;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final bool enableBlur;
  final Color? iconColor;

  const GlobalDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    this.selectedValues,
    this.onChanged,
    this.onMultiChanged,
    this.hint = 'Select an option',
    this.label,
    this.searchIdentifier,
    this.enableSearch = false,
    this.multiSelect = false,
    this.maxHeight = 250,
    this.enabled = true,
    this.errorText,
    this.infoLabel,
    this.onInfoLabelTap,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.selectedItemColor,
    this.borderRadius,
    this.height,
    this.contentPadding,
    this.fillColor,
    this.filled = false,
    this.enableBlur = false,
    this.iconColor,
  })  : assert(multiSelect == (onMultiChanged != null), 'Must provide onMultiChanged for multiSelect'),
        assert(!multiSelect == (onChanged != null), 'Must provide onChanged for singleSelect');

  @override
  State<GlobalDropdown<T>> createState() => _GlobalDropdownState<T>();
}

class _GlobalDropdownState<T> extends State<GlobalDropdown<T>> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey _dropdownKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool _open = false;
  bool _focused = false;
  bool _showAbove = false;
  bool _isDisposing = false;
  double _currentKeyboardHeight = 0;
  double _dropdownHeight = 0;
  Offset _dropdownPosition = Offset.zero;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  late List<DropdownItem<T>> _filteredItems;
  late List<T> _multiSelected;
  T? _singleSelected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _filteredItems = List.from(widget.items);
    _multiSelected = widget.selectedValues != null ? List.from(widget.selectedValues!) : <T>[];
    _singleSelected = widget.selectedValue;

    // Validate initial selected values
    if (!widget.multiSelect && _singleSelected != null && widget.items.isNotEmpty) {
      final exists = widget.items.any((item) => item.value == _singleSelected);
      if (!exists) {
        _singleSelected = null;
      }
    }

    if (widget.multiSelect && _multiSelected.isNotEmpty && widget.items.isNotEmpty) {
      _multiSelected.removeWhere((value) => !widget.items.any((item) => item.value == value));
    }

    // Add listener to search controller with safety check
    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      if (_open && _searchFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _repositionOverlay();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollable = Scrollable.of(context);
      scrollable.position.isScrollingNotifier.addListener(() {
        if (scrollable.position.isScrollingNotifier.value && _open) {
          _removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposing = true;
    _removeOverlay();
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final newKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (_currentKeyboardHeight != newKeyboardHeight) {
      _currentKeyboardHeight = newKeyboardHeight;
      if (_open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _repositionOverlay();
        });
      }
    }
  }

  @override
  void didUpdateWidget(GlobalDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!mounted) return;

    // Update internal state when selectedValue changes
    if (widget.selectedValue != oldWidget.selectedValue) {
      _singleSelected = widget.selectedValue;
    }

    // Update internal state when selectedValues changes
    if (widget.selectedValues != oldWidget.selectedValues) {
      _multiSelected = widget.selectedValues != null ? List.from(widget.selectedValues!) : <T>[];
    }

    // Validate that selected values exist in current items
    if (!widget.multiSelect && _singleSelected != null && widget.items.isNotEmpty) {
      final exists = widget.items.any((item) => item.value == _singleSelected);
      if (!exists) {
        _singleSelected = null; // Reset if selected value no longer exists
      }
    }

    if (widget.multiSelect && _multiSelected.isNotEmpty && widget.items.isNotEmpty) {
      _multiSelected.removeWhere((value) => !widget.items.any((item) => item.value == value));
    }

    // Update filtered items when items change
    if (widget.items != oldWidget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  void _onSearchChanged() {
    if (!mounted) return;
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = q.isEmpty ? List.from(widget.items) : widget.items.where((item) => item.label.toLowerCase().contains(q)).toList();
    });
    _overlayEntry?.markNeedsBuild();
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
    _currentKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    _calculatePosition();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        _open = true;
        _focused = true;
      });
    }

    _animationController.forward();
  }

// Remove the synchronous setState call from the dispose block
  void _removeOverlay() {
    if (!_isDisposing) {
      _animationController.reverse().then((_) {
        // This check is in the right place, it prevents setState on disposed objects
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) {
          setState(() {
            _open = false;
            _focused = false;
          });
        }
      });
    } else {
      // If widget is being disposed, just remove overlay immediately.
      // DO NOT call setState in the dispose path.
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    _searchController.clear();
    _filteredItems = List.from(widget.items);
  }

  Color _getThemeColor(BuildContext context, {bool isPrimary = false}) {
    try {
      if (mounted) {
        final theme = Theme.of(context);
        return isPrimary ? theme.colorScheme.primary : theme.colorScheme.onSurface;
      }
    } catch (e) {
      // Fallback colors if theme access fails
    }
    return isPrimary ? Colors.blue : Colors.black;
  }

  void _repositionOverlay() {
    _calculatePosition();
    _overlayEntry?.markNeedsBuild();
  }

  void _calculatePosition() {
    final renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _dropdownPosition = renderBox.localToGlobal(Offset.zero);
    _dropdownHeight = renderBox.size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableScreenHeight = screenHeight - keyboardHeight;

    final spaceAbove = _dropdownPosition.dy;
    final spaceBelow = availableScreenHeight - _dropdownPosition.dy - _dropdownHeight;

    final searchFieldHeight = widget.enableSearch ? 60.0 : 0.0;
    final footerHeight = widget.multiSelect ? 60.0 : 0.0;
    const minItemHeight = 48.0;
    final minRequiredHeight = searchFieldHeight + minItemHeight * 2 + footerHeight;

    // Improved positioning logic with better handling of limited space
    if (spaceBelow >= minRequiredHeight) {
      _showAbove = false;
    } else if (spaceAbove >= minRequiredHeight) {
      _showAbove = true;
    } else {
      // When neither side has enough space, prefer the side with more room
      // But also consider if the smaller space is still usable (at least 80px)
      if (spaceBelow >= 80 && spaceAbove >= 80) {
        _showAbove = spaceAbove > spaceBelow;
      } else if (spaceBelow >= 80) {
        _showAbove = false;
      } else if (spaceAbove >= 80) {
        _showAbove = true;
      } else {
        // Both sides have very little space, prefer below but use what's available
        _showAbove = false;
      }
    }
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        final renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) {
          return const SizedBox.shrink();
        }

        final dropdownWidth = renderBox.size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final availableScreenHeight = screenHeight - keyboardHeight;

        double availableHeight;
        if (_showAbove) {
          availableHeight = _dropdownPosition.dy - 8;
        } else {
          availableHeight = availableScreenHeight - _dropdownPosition.dy - _dropdownHeight - 8;
        }

        // Calculate effective max height with better handling for limited space
        double effectiveMaxHeight;
        if (availableHeight < widget.maxHeight) {
          // When space is limited, be more flexible with minimum height
          final minHeight = availableHeight < 120 ? availableHeight * 0.8 : 100.0;
          effectiveMaxHeight = availableHeight.clamp(minHeight, widget.maxHeight);
        } else {
          effectiveMaxHeight = widget.maxHeight;
        }

        // Ensure we never exceed available height (accounting for padding)
        effectiveMaxHeight = effectiveMaxHeight.clamp(0.0, availableHeight - 16);

        final Offset overlayOffset;
        if (_showAbove) {
          overlayOffset = Offset(0, -effectiveMaxHeight - 8);
        } else {
          overlayOffset = Offset(0, _dropdownHeight + 8);
        }

        return GestureDetector(
          onTap: _removeOverlay,
          behavior: HitTestBehavior.translucent,
          child: Stack(children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: overlayOffset,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: _showAbove ? Alignment.bottomCenter : Alignment.topCenter,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Material(
                        elevation: 4,
                        shadowColor: Colors.black12,
                        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                        child: Container(
                          width: dropdownWidth,
                          decoration: BoxDecoration(
                            color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
                            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.borderColor ?? Theme.of(context).dividerColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: effectiveMaxHeight,
                              minWidth: dropdownWidth,
                              minHeight: 48.0, // Minimum height to prevent too small dropdowns
                            ),
                            child: _buildDropdownContent(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ]),
        );
      },
    );
  }

  Widget _buildDropdownContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (widget.enableSearch) _buildSearchField(),
      Flexible(
        fit: FlexFit.loose, // Allow the list to take available space but not force it
        child: _filteredItems.isEmpty
            ? _buildNoResults()
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: false, // Let the parent container control the height
                itemCount: _filteredItems.length,
                itemBuilder: (ctx, i) {
                  final item = _filteredItems[i];
                  if (widget.multiSelect) {
                    final sel = _multiSelected.contains(item.value);
                    return _buildMultiItem(
                      item,
                      sel,
                      isFirst: i == 0,
                      isLast: i == _filteredItems.length - 1,
                    );
                  } else {
                    final sel = _singleSelected == item.value;
                    return _buildSingleItem(
                      item,
                      sel,
                      isFirst: i == 0,
                      isLast: i == _filteredItems.length - 1,
                    );
                  }
                },
              ),
      ),
      if (widget.multiSelect && _multiSelected.isNotEmpty) _buildFooter(),
    ]);
  }

  Widget _buildSearchField() {
    final translationService = Get.find<TranslationService>();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GlobalTextFormField(
        identifier: widget.searchIdentifier,
        hint: translationService.tr('search'),
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (_) => _onSearchChanged(),
        enabled: widget.enabled,
        textColor: MyColors.textPrimary,
        borderRadius: widget.borderRadius,
        height: widget.height,
        contentPadding: widget.contentPadding,
        fillColor: widget.fillColor,
        filled: widget.filled,
        onTap: () {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_open) _repositionOverlay();
          });
        },
      ),
    );
  }

  Widget _buildNoResults() {
    final translationService = Get.find<TranslationService>();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Icon(Icons.search_off, size: 32, color: widget.textColor ?? _getThemeColor(context, isPrimary: false)),
        const SizedBox(height: 8),
        Text(translationService.tr('no results found'),
            style: TextStyle(
              color: widget.textColor ?? _getThemeColor(context, isPrimary: false),
            )),
      ]),
    );
  }

  Widget _buildSingleItem(DropdownItem<T> item, bool sel, {bool isFirst = false, bool isLast = false}) {
    return InkWell(
      onTap: () {
        if (!mounted) return;
        if (mounted) {
          setState(() => _singleSelected = item.value);
        }
        widget.onChanged!(item.value);
        _removeOverlay();
      },
      borderRadius: isFirst
          ? const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            )
          : isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                )
              : BorderRadius.circular(0),
      child: _itemContainer(
        sel,
        Row(
          children: [
            if (item.icon != null) ...[item.icon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: sel ? (widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)) : (widget.textColor ?? _getThemeColor(context, isPrimary: false)),
                  fontWeight: sel ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (item.trailing != null) ...[
              const SizedBox(width: 8),
              item.trailing!,
            ],
            if (sel) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, size: 16, color: widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)),
            ],
          ],
        ),
        isFirst: isFirst,
        isLast: isLast,
      ),
    );
  }

  Widget _buildMultiItem(DropdownItem<T> item, bool sel, {bool isFirst = false, bool isLast = false}) {
    return InkWell(
      onTap: () {
        if (mounted) {
          setState(() {
            if (sel) {
              _multiSelected.remove(item.value);
            } else {
              _multiSelected.add(item.value);
            }
          });
          widget.onMultiChanged!(_multiSelected);
          _overlayEntry?.markNeedsBuild();
        }
      },
      borderRadius: isFirst
          ? const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            )
          : isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                )
              : BorderRadius.circular(0),
      child: _itemContainer(
        sel,
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: sel ? (widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)) : Colors.transparent,
                border: Border.all(
                  color: sel ? (widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)) : (widget.textColor ?? _getThemeColor(context, isPrimary: false)),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: sel ? Icon(Icons.check, size: 12, color: widget.backgroundColor ?? Colors.white) : null,
            ),
            const SizedBox(width: 12),
            if (item.icon != null) ...[item.icon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(item.label,
                  style: TextStyle(
                    color: sel ? (widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)) : (widget.textColor ?? _getThemeColor(context, isPrimary: false)),
                    fontWeight: sel ? FontWeight.w500 : FontWeight.normal,
                  )),
            ),
            if (item.trailing != null) ...[
              const SizedBox(width: 8),
              item.trailing!,
            ],
          ],
        ),
        isFirst: isFirst,
        isLast: isLast,
      ),
    );
  }

  Widget _itemContainer(bool sel, Widget child, {bool isFirst = false, bool isLast = false}) => Container(
        decoration: BoxDecoration(
          color: sel ? (widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true)).withValues(alpha: 0.08) : null,
          border: sel
              ? Border(
                  left: BorderSide(
                    color: widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true),
                    width: 2,
                  ),
                )
              : null,
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                )
              : isLast
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    )
                  : BorderRadius.circular(0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      );

  Widget _buildFooter() {
    final translationService = Get.find<TranslationService>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: widget.borderColor ?? _getThemeColor(context, isPrimary: false).withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${translationService.tr('selected')} ${_multiSelected.length}',
              style: TextStyle(
                color: widget.textColor ?? _getThemeColor(context, isPrimary: false),
              )),
          TextButton(
            onPressed: _removeOverlay,
            child: Text(translationService.tr('done'), style: TextStyle(color: widget.textColor ?? _getThemeColor(context, isPrimary: true))),
          ),
        ],
      ),
    );
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: widget.textColor ?? _getThemeColor(context, isPrimary: false),
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
          color: widget.selectedItemColor ?? _getThemeColor(context, isPrimary: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getThemeColor(context, isPrimary: true);
    const errorColor = Colors.red;
    const surfaceColor = Colors.white;
    const onSurfaceColor = Colors.black;

    // Safety check - if items list is empty, show only the header
    if (widget.items.isEmpty) {
      return _buildHeader(context);
    }

    final hasVal = widget.multiSelect ? _multiSelected.isNotEmpty : _singleSelected != null;
    String display;
    if (widget.multiSelect) {
      if (_multiSelected.isEmpty) {
        display = widget.hint;
      } else {
        final labs = _multiSelected.map((v) => widget.items.firstWhere((i) => i.value == v, orElse: () => DropdownItem(value: v, label: widget.hint)).label).toList();
        display = labs.length <= 2 ? labs.join(', ') : '${labs.take(2).join(', ')} (+${labs.length - 2} more)';
      }
    } else {
      display = _singleSelected != null ? widget.items.firstWhere((i) => i.value == _singleSelected, orElse: () => DropdownItem(value: _singleSelected as T, label: widget.hint)).label : widget.hint;
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        key: _dropdownKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          GestureDetector(
            onTap: _toggleDropdown,
            child: MouseRegion(
              cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
              child: SizedBox(
                height: widget.height,
                child: Stack(
                  children: [
                    if (widget.enableBlur)
                      ClipRRect(
                        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: widget.height ?? 48,
                            decoration: BoxDecoration(
                              color: widget.filled ? (widget.fillColor ?? Colors.white) : Colors.transparent,
                              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      height: widget.height ?? 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.errorText != null
                              ? errorColor
                              : _focused
                                  ? (widget.borderColor ?? primaryColor)
                                  : (widget.borderColor ?? _getThemeColor(context, isPrimary: false).withValues(alpha: 0.5)),
                          width: _focused ? 1.5 : 1,
                        ),
                        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                        color: widget.enabled ? (widget.filled ? (widget.fillColor ?? Colors.white) : (widget.backgroundColor ?? MyColors.transparent)) : (widget.filled ? (widget.fillColor ?? Colors.white).withValues(alpha: 0.6) : (widget.backgroundColor ?? surfaceColor.withValues(alpha: 0.6))),
                      ),
                      padding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              display,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: hasVal ? (widget.textColor ?? onSurfaceColor) : (widget.textColor ?? onSurfaceColor.withValues(alpha: 0.6)),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _open ? 0.5 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: Icon(Icons.keyboard_arrow_down, color: widget.enabled ? (widget.iconColor ?? widget.textColor ?? onSurfaceColor.withValues(alpha: 0.6)) : (widget.iconColor ?? widget.textColor ?? onSurfaceColor.withValues(alpha: 0.3))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(widget.errorText!, style: const TextStyle(color: errorColor)),
            ),
        ],
      ),
    );
  }
}

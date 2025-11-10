import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/enums.dart';
import 'global_image.dart';

class ChipData {
  final String label;
  final String value;
  final bool isSelected;
  final String image;

  ChipData(
      {required this.label,
      required this.value,
      required this.isSelected,
      required this.image});
}

class GlobalSingleSelectChip extends StatelessWidget {
  const GlobalSingleSelectChip({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onSelectionChanged,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.textColor,
    this.selectedTextColor,
    this.borderColor,
    this.selectedBorderColor,
    this.elevation = 1, // Reduced elevation for a more modern look
    this.padding = const EdgeInsets.symmetric(
        horizontal: 14, vertical: 4), // Increased padding
    this.spacing = 4, // Increased spacing between chips
    this.runSpacing = 8, // Increased vertical spacing between rows
  });

  final String label;
  final List<ChipData> items;
  final String? selectedItem;
  final Function(String?) onSelectionChanged;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double elevation;
  final EdgeInsets padding;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColors.grey.withValues(alpha:0.1)),
        boxShadow: [
          BoxShadow(
            color: MyColors.grey.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 12.0,
                left: 4.0), // Added left padding and increased bottom spacing
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Made label slightly bolder
                color: textColor ?? MyColors.textPrimary,
                letterSpacing:
                    0.2, // Added slight letter spacing for better readability
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: items.map((item) {
              final isSelected = selectedItem == item.value;
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.image.isNotEmpty) ...[
                      GlobalImage(
                        url: item.image,
                        type: ImageType.network,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14, // Explicit font size
                        color: isSelected
                            ? (selectedTextColor ?? Colors.white)
                            : (textColor ?? MyColors.textPrimary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight
                                .w500, // Made unselected text medium weight
                        letterSpacing: 0.1, // Slight letter spacing
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onSelectionChanged(item.value);
                  } else {
                    onSelectionChanged(null);
                  }
                },
                backgroundColor: backgroundColor ??
                    Colors.grey[50], // Lighter default background
                selectedColor: selectedBackgroundColor ?? MyColors.primary,
                labelPadding: const EdgeInsets.all(0), // Added label padding
                side: BorderSide(
                  color: isSelected
                      ? (selectedBorderColor ?? MyColors.primary)
                      : (borderColor ?? Colors.grey[300]!),
                  width: 1.2, // Slightly thicker border
                ),

                elevation: elevation,
                pressElevation: 2, // Added press elevation for better feedback
                padding: padding,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // More compact tap target
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Increased border radius
                ),
                showCheckmark: false, // Removed checkmark for cleaner look
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class GlobalMultiSelectChip extends StatelessWidget {
  const GlobalMultiSelectChip({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.textColor,
    this.selectedTextColor,
    this.borderColor,
    this.selectedBorderColor,
    this.elevation = 1, // Reduced elevation for a more modern look
    this.padding = const EdgeInsets.symmetric(
        horizontal: 14, vertical: 4), // Increased padding
    this.spacing = 4, // Increased spacing between chips
    this.runSpacing = 8, // Increased vertical spacing between rows
  });

  final String label;
  final List<ChipData> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double elevation;
  final EdgeInsets padding;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColors.grey.withValues(alpha:0.1)),
        boxShadow: [
          BoxShadow(
            color: MyColors.grey.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 12.0,
                left: 4.0), // Added left padding and increased bottom spacing
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Made label slightly bolder
                color: textColor ?? MyColors.textPrimary,
                letterSpacing:
                    0.2, // Added slight letter spacing for better readability
              ),
            ),
          ),
          Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item.value);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.image.isNotEmpty) ...[
                      GlobalImage(
                        url: item.image,
                        type: ImageType.network,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14, // Explicit font size
                        color: isSelected
                            ? (selectedTextColor ?? Colors.white)
                            : (textColor ?? MyColors.textPrimary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight
                                .w500, // Made unselected text medium weight
                        letterSpacing: 0.1, // Slight letter spacing
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  var newSelection = List<String>.from(selectedItems);
                  if (selected) {
                    newSelection.add(item.value);
                  } else {
                    newSelection.remove(item.value);
                  }
                  onSelectionChanged(newSelection);
                },
                backgroundColor: backgroundColor ??
                    Colors.grey[50], // Lighter default background
                selectedColor: selectedBackgroundColor ?? MyColors.primary,
                labelPadding: const EdgeInsets.all(0), // Added label padding
                side: BorderSide(
                  color: isSelected
                      ? (selectedBorderColor ?? MyColors.primary)
                      : (borderColor ?? Colors.grey[300]!),
                  width: 1.2, // Slightly thicker border
                ),

                elevation: elevation,
                pressElevation: 2, // Added press elevation for better feedback
                padding: padding,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // More compact tap target
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Increased border radius
                ),
                showCheckmark: false, // Removed checkmark for cleaner look
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

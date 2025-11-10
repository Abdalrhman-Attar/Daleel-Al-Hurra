import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'section_title.dart';

class SectionTitleWithFilter extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterChanged;

  const SectionTitleWithFilter({
    super.key,
    required this.title,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(title),
        const SizedBox(height: Sizes.spaceBetweenItems),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: filters.map((filter) {
              final isSelected = filter == selectedFilter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => onFilterChanged(filter),
                  selectedColor: MyColors.primary,
                  backgroundColor: MyColors.cardBackground,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

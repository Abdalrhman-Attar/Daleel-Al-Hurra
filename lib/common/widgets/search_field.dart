import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../module/dynamic_icon_viewer.dart';
import '../../module/global_icon_button.dart';
import '../../module/global_text_field.dart';
import '../../services/translation_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/my_icons.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    this.hint,
    required this.onSearch,
    required this.onChange,
    required this.onFilter,
  });

  final TextEditingController controller;
  final String? hint;
  final VoidCallback onSearch;
  final VoidCallback onChange;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return GlobalTextFormField(
      //   height: 62,
      hint: hint ??
          translationService.tr('search'), // Use localized string for hint
      controller: controller,
      onChanged: (_) => onChange(),
      onFieldSubmitted: (_) => onSearch(),
      prefixIcon: const Padding(
        padding: EdgeInsets.all(12.0),
        child: DynamicIconViewer(
          filePath: MyIcons.search,
          size: 24,
        ),
      ),
      borderRadius: BorderRadius.circular(15),
      textColor: MyColors.textPrimary,
      suffixIconTapable: true,
      suffixIconWidget: onFilter != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlobalIconButton(
                icon: MyIcons.filter,
                iconColor: Colors.white,
                iconSize: 25,
                buttonSize: 40,
                backgroundColor: MyColors.primary,
                borderRadius: BorderRadius.circular(8),
                onPressed: onFilter,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlobalIconButton(
                icon: MyIcons.filter,
                iconColor: Colors.transparent,
                iconSize: 25,
                buttonSize: 40,
                backgroundColor: MyColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/locale/locale.dart';
import '../../model/general/language/language.dart';
import '../../module/global_drop_down.dart';
import '../../module/global_image.dart';
import '../../services/languages_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/enums.dart';

class LanguageDropDown extends StatelessWidget {
  LanguageDropDown({super.key, this.withPadding = true, this.isEndRow = false});

  final bool withPadding;
  final bool isEndRow;
  final LanguagesService languagesService = Get.find<LanguagesService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: 200,
        margin: EdgeInsets.symmetric(
            vertical: withPadding ? 20 : 0, horizontal: 20),
        child: GlobalDropdown(
          backgroundColor: MyColors.background.withValues(alpha: 0.4),
          textColor: MyColors.textPrimary,
          items: languagesService.languages
              .map(
                (language) => DropdownItem<Language>(
                  value: language,
                  label: language.name ?? '',
                  icon: GlobalImage(
                    type: ImageType.network,
                    url: language.flag,
                    width: 20,
                    height: 20,
                  ),
                ),
              )
              .toList(),
          selectedValue: Get.find<LocaleController>().currentLanguage,
          onChanged: (language) {
            if (language != null) {
              Get.find<LocaleController>().changeLanguage(language);
            }
          },
          multiSelect: false,
        ),
      ),
    );
  }
}

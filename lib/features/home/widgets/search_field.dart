import 'package:flutter/material.dart';

import '../../../module/global_text_field.dart';
import '../../search/views/search_page.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to search page when the field is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      child: AbsorbPointer(
        // AbsorbPointer is similar to IgnorePointer but visually indicates it's disabled
        child: GlobalTextFormField(
          //height: 30,
          hint: '',
          controller: TextEditingController(),
          keyboardType: TextInputType.text,
          enabled:
              true, // Visually enabled but AbsorbPointer prevents interaction
          maxLength: 50,

          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (value) {},
          onSuffixIconTap: () {},
          onTap: () =>
              {}, // Empty onTap as AbsorbPointer will prevent this anyway
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../model/general/page_model/page_model.dart';
import '../../../utils/constants/colors.dart';

class FullPage extends StatelessWidget {
  final PageModel page;
  const FullPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          page.title ?? '',
          style: TextStyle(
            color: MyColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 00),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Html(data: page.content ?? ''),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

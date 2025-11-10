import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/theme/widget_themes/title_text_style.dart';
import '../controllers/dealers_controller.dart';
import '../widgets/dealer_card_stack.dart';

class DealersPage extends StatefulWidget {
  const DealersPage({super.key});

  @override
  State<DealersPage> createState() => _DealersPageState();
}

class _DealersPageState extends State<DealersPage> {
  final DealersController dealersController = Get.put(DealersController());
  final GlobalKey _cardStackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dealersController.fetchDealers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24, left: 24, bottom: 0),
              child: Column(
                children: [
                  Text(
                    tr('Explore Dealers'),
                    style: Theme.of(context).brightness == Brightness.dark
                        ? MyTitleTextStyle.darkSectionTitleLarge
                        : MyTitleTextStyle.lightSectionTitleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('Discover Trusted Car Dealers'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? MyColors.textSecondaryDark
                              : MyColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Obx(() {
              // Handle loading state
              if (dealersController.isLoading) {
                return const Center(child: DealerCardShimmer());
              }

              // Handle empty state
              if (dealersController.dealers.isEmpty) {
                return Center(child: Text(tr('no data found')));
              }

              // Handle data state with safety check
              return Center(
                child: DealerCardStack(
                  key: _cardStackKey,
                  dealers: dealersController.dealers,
                  onStackEmpty: () {
                    // Optional: Handle when stack is empty
                    debugPrint('All dealers have been explored!');
                  },
                  onForward: (index, info) {
                    // Optional: Handle swipe logic
                    debugPrint('Swiped dealer at index: $index');
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../features/brands/views/brands_page.dart';
import '../../../../features/dealers/views/dealers_page.dart';
import '../../../../features/home/views/home_page.dart';
import '../../../../features/search/views/search_page.dart';
import '../../../../features/settings/views/settings_page.dart';
import '../../../../main.dart';
import '../../../../module/dynamic_icon_viewer.dart';
import '../../../../module/global_dialog.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/fonts.dart';
import '../../../../utils/constants/my_icons.dart';
import '../../../../utils/constants/sizes.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> with WidgetsBindingObserver {
  // Initialize the controller
  final BottomNavController controller = Get.put(BottomNavController());

  // Initialize the navigator keys
  final GlobalKey<NavigatorState> homeNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> brandsNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> searchNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> dealersNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> settingsNavKey = GlobalKey<NavigatorState>();

  // Cache translation labels to avoid calling tr() on every build
  late final List<String> labels;

  @override
  void initState() {
    super.initState();
    // Initialize labels once to avoid calling tr() on every build
    labels = [
      tr('Home'),
      tr('Brands'),
      tr('Search'),
      tr('Dealers'),
      tr('Settings'),
    ];
  }

  // Track the current active navigatorKey for nested navigation handling
  GlobalKey<NavigatorState> get _currentNavigatorKey {
    switch (controller.selectedIndex.value) {
      case 0:
        return homeNavKey;
      case 1:
        return brandsNavKey;
      case 2:
        return searchNavKey;
      case 3:
        return dealersNavKey;
      case 4:
        return settingsNavKey;
      default:
        return homeNavKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Theme.of(context).scaffoldBackgroundColor : Colors.black,
        body: Stack(
          children: [
            Obx(
              () => IndexedStack(
                index: controller.selectedIndex.value,
                children: [
                  Navigator(
                    key: homeNavKey,
                    onGenerateRoute: (routeSettings) => MaterialPageRoute(
                      builder: (context) => const HomePage(),
                      settings: routeSettings,
                    ),
                  ),
                  Navigator(
                    key: brandsNavKey,
                    onGenerateRoute: (routeSettings) => MaterialPageRoute(
                      builder: (context) => const BrandsPage(),
                      settings: routeSettings,
                    ),
                  ),
                  Navigator(
                    key: searchNavKey,
                    onGenerateRoute: (routeSettings) => MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                      settings: routeSettings,
                    ),
                  ),
                  Navigator(
                    key: dealersNavKey,
                    onGenerateRoute: (routeSettings) => MaterialPageRoute(
                      builder: (context) => const DealersPage(),
                      settings: routeSettings,
                    ),
                  ),
                  Navigator(
                    key: settingsNavKey,
                    onGenerateRoute: (routeSettings) => MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                      settings: routeSettings,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom * 0.5,
                ),
                decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.xl)),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        final isSelected = controller.selectedIndex.value == index;
                        final icons = [
                          [MyIcons.homeOutline, MyIcons.home],
                          [MyIcons.brandsOutline, MyIcons.brands],
                          [MyIcons.searchOutline, MyIcons.search],
                          [MyIcons.dealersOutline, MyIcons.dealers],
                          [MyIcons.settingsOutline, MyIcons.settings],
                        ];

                        return Expanded(
                          child: Card(
                            color: MyColors.transparent,
                            surfaceTintColor: MyColors.transparent,
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                if (controller.selectedIndex.value != index) {
                                  controller.selectedIndex.value = index;
                                }
                                _popToFirst(index);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DynamicIconViewer(
                                      filePath: icons[index][isSelected ? 1 : 0],
                                      size: 30,
                                      color: isSelected ? MyColors.primary : MyColors.grey600,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      labels[index],
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                                        color: isSelected ? MyColors.grey900 : MyColors.grey600,
                                        fontFamily: MyFonts.getFontFamily(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _popToFirst(int index) {
    final navKeys = [
      homeNavKey,
      brandsNavKey,
      searchNavKey,
      dealersNavKey,
      settingsNavKey,
    ];

    final navKey = navKeys[index];

    navKey.currentState?.popUntil((route) => route.isFirst);
  }

  Future<void> _handleBackButton() async {
    final navigatorKey = _currentNavigatorKey;
    final navigator = navigatorKey.currentState;

    if (navigator == null) return;

    // Check if the current navigator can pop
    if (navigator.canPop()) {
      // If we can pop the current navigator, do it
      navigator.pop();
    } else {
      // If we can't pop the current navigator
      if (controller.selectedIndex.value != 0) {
        // If we're not on the home tab, go to the home tab
        controller.selectedIndex.value = 0;
      } else {
        // If we're on the home tab and can't pop, show exit dialog
        final shouldExit = await _showExitConfirmationDialog();
        if (shouldExit == true) {
          await SystemNavigator.pop();
        }
      }
    }
  }

  Future<bool?> _showExitConfirmationDialog() async {
    bool? result;
    await GlobalDialog.show(
      context: context,
      title: tr('exit app'),
      message: tr('exit app confirmation'),
      confirmText: tr('exit'),
      cancelText: tr('cancel'),
      onConfirm: () => result = true,
      onCancel: () => result = false,
      barrierDismissible: false,
      dialogType: DialogType.confirmation,
    );
    return result;
  }
}

class BottomNavController extends GetxController {
  // Observable variables
  final RxInt selectedIndex = 0.obs;
  // Track if we're in a sub-page for each navigator
  final RxList<bool> _hasSubPages = <bool>[].obs;

  List<bool> get hasSubPages => _hasSubPages;

  // Method to change the selected tab
  void changeTab(int index) => selectedIndex.value = index;
}

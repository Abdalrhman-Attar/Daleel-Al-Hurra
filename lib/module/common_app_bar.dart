// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../common/controllers.dart';
// import '../common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
// import '../common/widgets/layouts/side_menu_layout/side_menu_page.dart';
// import '../features/explore/controllers/map_list_view_controller.dart';
// import '../features/notifications/views/notifications_page.dart';
// import '../generated/l10n.dart';
// import '../utils/constants/colors.dart';
// import '../utils/constants/my_icons.dart';
// import 'global_icon_button.dart';

// enum AppBarMode {
//   mode1, // logo center, notif left, profile right
//   mode2, // back button left, title center
//   mode3, // map / list view toggle  title center profile
// }

// class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final AppBarMode? mode;
//   final VoidCallback? onLeadingTap;
//   final List<VoidCallback>? onActionsTap;
//   final String? title;
//   final Widget? customCenter;
//   final bool withBottom;
//   final Widget? searchField;
//   final Widget? customBottom;
//   final double bottomHeight;
//   final Widget? appBar;
//   final BorderRadiusGeometry borderRadius;

//   const CommonAppBar({
//     super.key,
//     this.mode = AppBarMode.mode1,
//     this.onLeadingTap,
//     this.onActionsTap,
//     this.title,
//     this.customCenter,
//     this.withBottom = false,
//     this.searchField,
//     this.customBottom,
//     this.bottomHeight = 70.0,
//     this.appBar,
//     this.borderRadius = const BorderRadius.only(
//       bottomLeft: Radius.circular(20),
//       bottomRight: Radius.circular(20),
//     ),
//   });

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight + (withBottom ? bottomHeight : 0));

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius,
//       child: switch (mode) {
//         AppBarMode.mode1 => AppBar(
//             elevation: 0,
//             // leading: Padding(
//             //   padding: const EdgeInsets.all(4.0),
//             //   child: GlobalIconButton(
//             //     icon: MyIcons.famiconsNotifications,
//             //     onPressed: () {
//             //       // Handle notification tap
//             //     },
//             //     iconColor: MyColors.iconPrimary,
//             //   ),
//             // ),
//             backgroundColor: MyColors.background,
//             surfaceTintColor: MyColors.background,
//             title: customCenter ??
//                 Text(
//                   title ?? S.current.visitAmman,
//                   style: const TextStyle(fontSize: 22),
//                 ),
//             centerTitle: true,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: [
//                     GlobalIconButton(
//                       icon: MyIcons.famiconsNotifications,
//                       borderRadius: BorderRadius.circular(50.0),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const NotificationsPage(),
//                           ),
//                         );
//                       },
//                       iconColor: MyColors.iconPrimary,
//                       buttonSize: 35.0,
//                       iconSize: 25.0,
//                     ),
//                     const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.search,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     const SizedBox(width: 4),
//                     GlobalIconButton(
//                       iconData: Icons.menu,
//                       borderRadius: BorderRadius.circular(50.0),
//                       onPressed: () {
//                         Get.put(SideMenuController()).toggleMenu();
//                       },
//                       iconColor: MyColors.iconPrimary,
//                       buttonSize: 35.0,
//                       iconSize: 25.0,
//                     ),
//                     // GlobalIconButton(
//                     //   iconData: Icons.notifications_none,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     // const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.person_rounded,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     // const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.search,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     // const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.favorite,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     // const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.language_rounded,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {
//                     //     var languageCode = Get.locale?.languageCode ?? 'en';
//                     //     if (languageCode == 'en') {
//                     //       Controllers.locale.setLocale(const Locale('ar'));
//                     //     } else {
//                     //       Controllers.locale.setLocale(const Locale('en'));
//                     //     }
//                     //   },
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//             bottom: withBottom ? _buildBottom() : null,
//           ),
//         AppBarMode.mode2 => AppBar(
//             elevation: 0,
//             leading: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: GlobalIconButton(
//                 icon: MyIcons.famiconsArrowBackOutline,
//                 onPressed: () => Navigator.of(context).pop(),
//                 iconColor: MyColors.iconPrimary,
//               ),
//             ),
//             backgroundColor: MyColors.background,
//             surfaceTintColor: MyColors.background,
//             title: Text(
//               title ?? '',
//               style: const TextStyle(fontSize: 22),
//             ),
//             centerTitle: true,
//             bottom: withBottom ? _buildBottom() : null,
//           ),
//         AppBarMode.mode3 => AppBar(
//             elevation: 0,
//             backgroundColor: MyColors.background,
//             surfaceTintColor: MyColors.background,
//             title: customCenter ??
//                 Text(
//                   title ?? '',
//                   style: const TextStyle(fontSize: 22),
//                 ),
//             leading: Obx(() {
//               final mapListController = Get.put(MapListViewController());
//               final isMapView = mapListController.isMapView;
//               return GlobalIconButton(
//                 icon: isMapView ? MyIcons.materialSymbolsListRounded : MyIcons.solarMapBold,
//                 borderRadius: BorderRadius.circular(50.0),
//                 onPressed: mapListController.toggleView,
//                 iconColor: MyColors.iconPrimary,
//                 buttonSize: 35.0,
//                 iconSize: 25.0,
//               );
//             }),
//             centerTitle: true,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: [
//                     GlobalIconButton(
//                       icon: MyIcons.famiconsNotifications,
//                       borderRadius: BorderRadius.circular(50.0),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const NotificationsPage(),
//                           ),
//                         );
//                       },
//                       iconColor: MyColors.iconPrimary,
//                       buttonSize: 35.0,
//                       iconSize: 25.0,
//                     ),
//                     const SizedBox(width: 4),
//                     // GlobalIconButton(
//                     //   iconData: Icons.search,
//                     //   borderRadius: BorderRadius.circular(50.0),
//                     //   onPressed: () {},
//                     //   iconColor: MyColors.iconPrimary,
//                     //   buttonSize: 35.0,
//                     //   iconSize: 25.0,
//                     // ),
//                     const SizedBox(width: 4),
//                     GlobalIconButton(
//                       iconData: Icons.menu,
//                       borderRadius: BorderRadius.circular(50.0),
//                       onPressed: () {
//                         Get.put(SideMenuController()).toggleMenu();
//                       },
//                       iconColor: MyColors.iconPrimary,
//                       buttonSize: 35.0,
//                       iconSize: 25.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             // actions: [
//             //   GlobalIconButton(
//             //     icon: MyIcons.iconamoonProfileFill,
//             //     onPressed: () {
//             //       // Handle notification tap
//             //     },
//             //     iconColor: MyColors.iconPrimary,
//             //   ),
//             // ],
//             bottom: withBottom ? _buildBottom() : null,
//           ),
//         _ => appBar ?? AppBar()
//       },
//     );
//   }

//   PreferredSize _buildBottom() {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(bottomHeight),
//       child: Padding(
//         padding: EdgeInsets.only(bottom: customBottom != null ? 0 : 8.0),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: customBottom != null ? 0 : 12.0),
//           child: searchField == null ? customBottom ?? const SizedBox.shrink() : searchField!,
//         ),
//       ),
//     );
//   }
// }

// class LanguageSwitchButton extends StatelessWidget {
//   const LanguageSwitchButton({super.key});

//   // Grab your controller (make sure you've put it into Get.put() somewhere, e.g. in main())

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isRtl = Controllers.locale.getIsRtl();
//       return GlobalIconButton(
//         // You can swap these IconData for flag SVGs via `icon: 'assets/flags/ar.svg'` etc.
//         iconData: Icons.language,
//         tooltip: isRtl ? 'English' : 'عربي',
//         onPressed: () {
//           // Flip between 'ar' and 'en'
//           Controllers.locale.changeLanguage(isRtl ? 'en' : 'ar');
//           // refresh the app to apply the new language
//           Get.offAll(() => const BottomNavPage());
//         },
//       );
//     });
//   }
// }

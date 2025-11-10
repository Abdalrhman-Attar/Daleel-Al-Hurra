import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/language_drop_down.dart';
import '../../../common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../module/global_dialog.dart';
import '../../../module/global_image.dart';
import '../../../splash_screen.dart';
import '../../../stores/secure_store.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../auth/views/on_boarding_page.dart';
import '../../my_cars/view/my_cars_page.dart';
import '../../profile/views/profile_page.dart';
import '../controllers/pages_controller.dart';
import 'full_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PagesController pagesController = Get.put(PagesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pagesController.fetchPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Get.find<SecureStore>().authToken.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('settings'),
          style: TextStyle(
            color: MyColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section (if logged in)
            if (isLoggedIn) ...[
              _buildSectionHeader(tr('account'), context),
              const SizedBox(height: 12),
              _buildMenuCard([
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: tr('account information'),
                  subtitle: tr('manage your profile'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.directions_car_outlined,
                  title: tr('my cars'),
                  subtitle: tr('view and manage vehicles'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyCarsPage()),
                  ),
                ),
              ]),
              const SizedBox(height: 32),
            ],

            // Dynamic Pages Section
            Obx(() {
              if (pagesController.isLoading) {
                return _buildLoadingSection();
              }

              if (pagesController.isError) {
                return _buildErrorSection();
              }

              if (pagesController.pages.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(tr('information'), context),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                      pagesController.pages
                          .map((page) => _buildMenuItem(
                                context,
                                customIcon: GlobalImage(
                                  type: ImageType.network,
                                  url: page.image ?? '',
                                  width: 24,
                                  height: 24,
                                ),
                                title: page.title ?? '',
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => FullPage(page: page)),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }

              return const SizedBox.shrink();
            }),

            // Settings Section
            _buildSectionHeader(tr('preferences'), context),
            const SizedBox(height: 12),
            _buildMenuCard([
              _buildLanguageSelector(context),
              //_buildThemeSwitcher(context),
            ]),
            const SizedBox(height: 32),

            // Authentication Section
            _buildSectionHeader(tr('account'), context),
            const SizedBox(height: 12),
            _buildMenuCard([
              isLoggedIn
                  ? _buildMenuItem(
                      context,
                      icon: Icons.logout_outlined,
                      title: tr('logout'),
                      subtitle: tr('sign out of your account'),
                      isDestructive: true,
                      onTap: () => _showLogoutDialog(context),
                    )
                  : _buildMenuItem(
                      context,
                      icon: Icons.login_outlined,
                      title: tr('login signup as dealer'),
                      subtitle: tr('access dealer features'),
                      onTap: () => Get.to(() => const OnboardingPage()),
                    ),
            ]),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;

          return Column(
            children: [
              child,
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  indent: 60,
                  color: Colors.grey[300]?.withValues(alpha: 0.5),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    IconData? icon,
    Widget? customIcon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDestructive ? Colors.red.withValues(alpha: 0.1) : theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: customIcon ??
                      Icon(
                        icon,
                        color: isDestructive ? Colors.red[600] : theme.primaryColor,
                        size: 22,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDestructive ? Colors.red[600] : MyColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.language_outlined,
              color: Theme.of(context).primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('language'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: MyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tr('choose your preferred language'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: LanguageDropDown(
              withPadding: false,
              isEndRow: false,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildThemeSwitcher(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //     child: Row(
  //       children: [
  //         Text(tr('theme'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MyColors.textPrimary)),
  //         const Spacer(),
  //         CustomAdvanceSwitch(
  //           activeChild: Text(tr('light'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MyColors.textPrimary)),
  //           inactiveChild: Text(tr('dark'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MyColors.textPrimary)),
  //           controller: ValueNotifier<bool>(Get.find<ThemeController>().themeMode.value == ThemeMode.light),
  //           onChanged: (value) {
  //             Get.find<ThemeController>().toggleTheme();
  //           },
  //           initialValue: Get.find<ThemeController>().themeMode.value == ThemeMode.light,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLoadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(tr('information'), context),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: LoadingShimmer()),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildErrorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(tr('information'), context),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tr('error loading pages'),
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showLogoutConfirmationDialog(context);
    if (result == true) {
      Get.find<BottomNavController>().changeTab(0);
      Get.find<SecureStore>().clearAuthToken();
      await Get.offAll(() => const SplashScreen());
    }
  }
}

Future<bool?> showLogoutConfirmationDialog(BuildContext context) async {
  bool? result;
  await GlobalDialog.show(
    context: context,
    title: tr('logout'),
    message: tr('logout confirmation'),
    confirmText: tr('logout'),
    cancelText: tr('cancel'),
    onConfirm: () => result = true,
    onCancel: () => result = false,
    barrierDismissible: false,
    dialogType: DialogType.confirmation,
  );
  return result;
}

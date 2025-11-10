import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../main.dart';
import '../utils/constants/colors.dart';
import 'global_icon_button.dart';

class GlobalBottomSheet {
  static void show({
    required Widget title,
    required Widget content,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    bool enableResize = false,
    double? minHeight,
    double? maxHeight,
    Widget? headerIcon,
    List<Widget>? actions = const [],
    bool useScrollView = true, // New parameter to control scrolling
  }) {
    var context = navigatorKey.currentContext;

    final screenHeight = MediaQuery.of(context!).size.height;

    final finalMinHeight = minHeight ?? screenHeight * 0.2;
    final finalMaxHeight = maxHeight ?? screenHeight * 0.9;

    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          enableDrag: enableDrag,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                  top: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (headerIcon != null)
                      headerIcon
                    else
                      const SizedBox.shrink(),
                    Expanded(
                      child: title,
                    ),
                    if (actions != null && actions.isNotEmpty) ...actions,
                    GlobalIconButton(
                      iconData: Icons.close,
                      borderRadius: BorderRadius.circular(50),
                      iconSize: 24,
                      buttonSize: 45,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Container(
                height: height,
                constraints: BoxConstraints(
                  maxHeight: finalMaxHeight,
                  minHeight: finalMinHeight,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: useScrollView
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(0),
                        child: content,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(0),
                        child: content,
                      ),
              ),
            ],
          ),
        ),
      ],
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
      enableDrag: enableDrag,
      barrierDismissible: isDismissible,
    );
  }
}

class GlobalTopSheet {
  static void show({
    required String title,
    required Widget content,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    Widget? headerIcon,
    List<Widget>? actions = const [],
    EdgeInsets? contentPadding,
    VoidCallback? onDismissed,
  }) {
    final context = navigatorKey.currentContext!;
    final screenHeight = MediaQuery.of(context).size.height;
    final topSheetHeight =
        height ?? screenHeight * 0.45; // Slightly taller default
    final safePadding = MediaQuery.of(context).padding;

    showGeneralDialog(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: 'Dismiss',
      barrierColor:
          Colors.black.withValues(alpha: 0.3), // Slightly darker barrier
      transitionDuration:
          const Duration(milliseconds: 350), // Smoother animation
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: topSheetHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20), // Slightly more rounded
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Status bar spacing
                  SizedBox(height: safePadding.top),

                  // Header
                  Container(
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 20,
                      right: 12,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Header icon with better spacing
                        if (headerIcon != null) ...[
                          headerIcon,
                          const SizedBox(width: 12),
                        ],

                        // Title with better typography
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Action buttons with better spacing
                        if (actions != null && actions.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          ...actions.map((action) => Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: action,
                              )),
                          const SizedBox(width: 8),
                        ],

                        // Close button with haptic feedback
                        GlobalIconButton(
                          iconData: Icons.close,
                          borderRadius: BorderRadius.circular(50),
                          iconSize: 24,
                          buttonSize: 35,
                          onPressed: () {
                            if (enableDrag) {
                              HapticFeedback.lightImpact();
                            }
                            Navigator.of(context).pop();
                            onDismissed?.call();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content area with better scrolling behavior
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20), // Match header radius
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          padding: contentPadding ?? const EdgeInsets.all(0),
                          physics:
                              const BouncingScrollPhysics(), // Better scroll feel
                          child: content,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        // Enhanced animation with bounce effect
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.fastLinearToSlowEaseIn, // Bouncy animation
          )),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    ).then((_) {
      // Call onDismissed when dialog is closed
      onDismissed?.call();
    });
  }
}

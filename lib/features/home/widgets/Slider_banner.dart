import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants/fonts.dart';
import '../../../common/widgets/shimmer/banner_slider_shimmer.dart';
import '../../../main.dart';
import '../../../utils/constants/colors.dart';
import '../controllers/slider_controller.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({super.key});

  @override
  State<SliderBanner> createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  final SliderController controller = Get.put(SliderController());
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller.fetchSliders().then((_) {
      if (controller.sliders.isNotEmpty) {
        _startAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (controller.sliders.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || controller.sliders.isEmpty) return;
      final next =
          ((_pageController.page ?? 0).round() + 1) % controller.sliders.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const BannerSliderShimmer();
      }

      if (controller.isError) {
        return SizedBox(
          height: 180,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tr('error_occurred')),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => controller.fetchSliders(),
                  child: Text(tr('retry')),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.sliders.isEmpty) {
        return SizedBox(
          height: 180,
          child: Center(child: Text(tr('no_data_found'))),
        );
      }

      return Column(
        children: [
          SizedBox(
            height: 180,
            child: Stack(children: [
              PageView.builder(
                controller: _pageController,
                itemCount: controller.sliders.length,
                itemBuilder: (context, index) {
                  final item = controller.sliders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.image ?? '',
                            fit: BoxFit.cover,
                          ),
                          Container(
                              decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          )),
                          Positioned(
                            bottom: 15,
                            left: 10,
                            right: 10,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: MyFonts.getFontFamily(),
                                  ),
                                ),
                                Text(
                                  item.subtitle ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: MyFonts.getFontFamily(),
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: controller.sliders.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: MyColors.textPrimaryDark,
                      dotColor: MyColors.textDisabledLight,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      );
    });
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'global_shimmer.dart';

class GlobalImage extends StatelessWidget {
  final String? url;
  final String? assetPath;
  final File? file;
  final Uint8List? bytes;
  final ImageType type;
  final BoxFit fit;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxBorder? border;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? overlayColor;
  final BlendMode overlayBlendMode;
  final Gradient? gradientOverlay;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;

  const GlobalImage({
    super.key,
    this.url,
    this.assetPath,
    this.file,
    this.bytes,
    required this.type,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.border,
    this.borderRadius = Sizes.md,
    this.backgroundColor,
    this.overlayColor,
    this.overlayBlendMode = BlendMode.srcATop,
    this.gradientOverlay,
    this.gradientBegin = Alignment.topCenter,
    this.gradientEnd = Alignment.bottomCenter,
    this.placeholder,
    this.errorWidget,
    this.onTap,
  }) : assert(
          (type == ImageType.network && url != null) || (type == ImageType.asset && assetPath != null) || (type == ImageType.file && file != null) || (type == ImageType.memory && bytes != null),
          'Corresponding data must be provided for the selected ImageType',
        );

  @override
  Widget build(BuildContext context) {
    Widget imageContainer = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: _buildImageContent(),
      ),
    );

    // If no onTap, return the image normally
    if (onTap == null) {
      return imageContainer;
    }

    // If onTap is provided, use Stack with InkWell on top
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Stack(
        children: [
          // Image container without margin (since it's applied to parent)
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: _buildImageContent(),
            ),
          ),
          // InkWell overlay on top
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    Widget imageWidget;

    switch (type) {
      case ImageType.network:
        imageWidget = _buildNetworkImage();
        break;
      case ImageType.asset:
        imageWidget = _buildAssetImage();
        break;
      case ImageType.file:
        imageWidget = _buildFileImage();
        break;
      case ImageType.memory:
        imageWidget = _buildMemoryImage();
        break;
    }

    // Apply overlays
    imageWidget = _applyOverlays(imageWidget);

    return imageWidget;
  }

  Widget _applyOverlays(Widget imageWidget) {
    var result = imageWidget;

    // Apply color overlay if provided
    if (overlayColor != null) {
      result = ColorFiltered(
        colorFilter: ColorFilter.mode(
          overlayColor!,
          overlayBlendMode,
        ),
        child: result,
      );
    }

    // Apply gradient overlay if provided
    if (gradientOverlay != null) {
      result = Stack(
        fit: StackFit.expand,
        children: [
          result,
          Container(
            decoration: BoxDecoration(
              gradient: gradientOverlay,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ],
      );
    }

    return result;
  }

  Widget _buildNetworkImage() {
    if (url == null || url!.isEmpty) {
      return _buildErrorWidget();
    }

    // Check if the URL is a video file
    if (!HelperFunctions().isValidImageUrl(url!)) {
      debugPrint('Attempting to load video file as image: $url');
      return _buildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: url!,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, _) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, _, __) {
        // Log the error for debugging
        debugPrint('Failed to load network image: $url');
        return _buildErrorWidget();
      },
      // Add additional options to handle problematic images
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (compatible; Flutter)',
      },
    );
  }

  Widget _buildAssetImage() {
    if (assetPath == null || assetPath!.isEmpty) {
      return _buildErrorWidget();
    }

    try {
      return Image.asset(
        assetPath!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Log the error for debugging
          debugPrint('Failed to load asset image: $assetPath, error: $error');
          return _buildErrorWidget();
        },
      );
    } catch (e) {
      debugPrint('Exception loading asset image: $assetPath, error: $e');
      return _buildErrorWidget();
    }
  }

  Widget _buildFileImage() {
    if (file == null || !file!.existsSync()) {
      return _buildErrorWidget();
    }

    try {
      return Image.file(
        file!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Log the error for debugging
          debugPrint('Failed to load file image: ${file!.path}, error: $error');
          return _buildErrorWidget();
        },
      );
    } catch (e) {
      debugPrint('Exception loading file image: ${file!.path}, error: $e');
      return _buildErrorWidget();
    }
  }

  Widget _buildMemoryImage() {
    if (bytes == null || bytes!.isEmpty) {
      return _buildErrorWidget();
    }

    try {
      return Image.memory(
        bytes!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Log the error for debugging
          debugPrint('Failed to load memory image, error: $error');
          return _buildErrorWidget();
        },
      );
    } catch (e) {
      debugPrint('Exception loading memory image, error: $e');
      return _buildErrorWidget();
    }
  }

  Widget _buildPlaceholder() {
    final placeholderWidth = width != null ? width! - (padding?.horizontal ?? 0) : null;
    final placeholderHeight = height != null ? height! - (padding?.vertical ?? 0) : null;

    return GlobalShimmer.placeholder(
      width: placeholderWidth ?? 56,
      height: placeholderHeight ?? 56,
      borderRadius: BorderRadius.circular(borderRadius * 0.8),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          color: backgroundColor ?? Colors.grey.shade100,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 32,
              color: Colors.grey,
            ),
          ),
        );
  }
}

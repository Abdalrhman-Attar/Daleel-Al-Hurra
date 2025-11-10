import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import 'global_shimmer.dart';

class GlobalAnimatedImage extends StatefulWidget {
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

  // Animation-specific properties
  final bool autoPlay;
  final bool repeat;
  final Duration? animationDuration;
  final AnimationController? controller;
  final bool enableAnimation;
  final FilterQuality filterQuality;

  const GlobalAnimatedImage({
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
    this.autoPlay = true,
    this.repeat = true,
    this.animationDuration,
    this.controller,
    this.enableAnimation = true,
    this.filterQuality = FilterQuality.low,
  }) : assert(
          (type == ImageType.network && url != null) ||
              (type == ImageType.asset && assetPath != null) ||
              (type == ImageType.file && file != null) ||
              (type == ImageType.memory && bytes != null),
          'Corresponding data must be provided for the selected ImageType',
        );

  @override
  State<GlobalAnimatedImage> createState() => _GlobalAnimatedImageState();
}

class _GlobalAnimatedImageState extends State<GlobalAnimatedImage>
    with TickerProviderStateMixin {
  AnimationController? _internalController;
  AnimationController? _fadeController;
  Animation<double>? _fadeAnimation;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    ));

    // Initialize internal animation controller if not provided
    if (widget.controller == null && widget.enableAnimation) {
      _internalController = AnimationController(
        duration: widget.animationDuration ?? const Duration(seconds: 1),
        vsync: this,
      );

      if (widget.autoPlay) {
        if (widget.repeat) {
          _internalController!.repeat();
        } else {
          _internalController!.forward();
        }
      }
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    _fadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContainer = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.border,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: _buildImageContent(),
      ),
    );

    // If no onTap, return the image normally
    if (widget.onTap == null) {
      return imageContainer;
    }

    // If onTap is provided, use Stack with InkWell on top
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: Stack(
        children: [
          // Image container without margin (since it's applied to parent)
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              border: widget.border,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: _buildImageContent(),
            ),
          ),
          // InkWell overlay on top
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    Widget imageWidget;

    switch (widget.type) {
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

    // Apply fade animation
    if (_fadeAnimation != null) {
      imageWidget = FadeTransition(
        opacity: _fadeAnimation!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _applyOverlays(Widget imageWidget) {
    var result = imageWidget;

    // Apply color overlay if provided
    if (widget.overlayColor != null) {
      result = ColorFiltered(
        colorFilter: ColorFilter.mode(
          widget.overlayColor!,
          widget.overlayBlendMode,
        ),
        child: result,
      );
    }

    // Apply gradient overlay if provided
    if (widget.gradientOverlay != null) {
      result = Stack(
        fit: StackFit.expand,
        children: [
          result,
          Container(
            decoration: BoxDecoration(
              gradient: widget.gradientOverlay,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ],
      );
    }

    return result;
  }

  Widget _buildNetworkImage() {
    if (widget.url == null || widget.url!.isEmpty) {
      return _buildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: widget.url!,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      filterQuality: widget.filterQuality,
      placeholder: (context, _) => widget.placeholder ?? _buildPlaceholder(),
      errorWidget: (context, _, __) => _buildErrorWidget(),
      imageBuilder: (context, imageProvider) {
        _onImageLoaded();
        return _buildAnimatedImage(
          Image(
            image: imageProvider,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            filterQuality: widget.filterQuality,
          ),
        );
      },
    );
  }

  Widget _buildAssetImage() {
    if (widget.assetPath == null || widget.assetPath!.isEmpty) {
      return _buildErrorWidget();
    }

    try {
      final image = Image.asset(
        widget.assetPath!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        filterQuality: widget.filterQuality,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            _onImageLoaded();
            return _buildAnimatedImage(child);
          }
          if (frame == null) {
            return widget.placeholder ?? _buildPlaceholder();
          }
          _onImageLoaded();
          return _buildAnimatedImage(child);
        },
      );

      return image;
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildFileImage() {
    if (widget.file == null || !widget.file!.existsSync()) {
      return _buildErrorWidget();
    }

    try {
      final image = Image.file(
        widget.file!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        filterQuality: widget.filterQuality,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            _onImageLoaded();
            return _buildAnimatedImage(child);
          }
          if (frame == null) {
            return widget.placeholder ?? _buildPlaceholder();
          }
          _onImageLoaded();
          return _buildAnimatedImage(child);
        },
      );

      return image;
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildMemoryImage() {
    if (widget.bytes == null || widget.bytes!.isEmpty) {
      return _buildErrorWidget();
    }

    try {
      final image = Image.memory(
        widget.bytes!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        filterQuality: widget.filterQuality,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            _onImageLoaded();
            return _buildAnimatedImage(child);
          }
          if (frame == null) {
            return widget.placeholder ?? _buildPlaceholder();
          }
          _onImageLoaded();
          return _buildAnimatedImage(child);
        },
      );

      return image;
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildAnimatedImage(Widget child) {
    if (!widget.enableAnimation) {
      return child;
    }

    final controller = widget.controller ?? _internalController;
    if (controller == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return child;
      },
    );
  }

  void _onImageLoaded() {
    if (!_hasError && _fadeController != null) {
      _fadeController!.forward();
    }
  }

  Widget _buildPlaceholder() {
    final placeholderWidth = widget.width != null
        ? widget.width! - (widget.padding?.horizontal ?? 0)
        : null;
    final placeholderHeight = widget.height != null
        ? widget.height! - (widget.padding?.vertical ?? 0)
        : null;

    return GlobalShimmer.placeholder(
      width: placeholderWidth ?? 56,
      height: placeholderHeight ?? 56,
      borderRadius: BorderRadius.circular(widget.borderRadius * 0.8),
    );
  }

  Widget _buildErrorWidget() {
    _hasError = true;
    return widget.errorWidget ??
        Container(
          color: widget.backgroundColor ?? Colors.grey.shade100,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 32,
              color: Colors.grey,
            ),
          ),
        );
  }

  // Public methods to control animation
  void play() {
    final controller = widget.controller ?? _internalController;
    if (controller != null && widget.enableAnimation) {
      if (widget.repeat) {
        controller.repeat();
      } else {
        controller.forward();
      }
    }
  }

  void pause() {
    final controller = widget.controller ?? _internalController;
    if (controller != null) {
      controller.stop();
    }
  }

  void stop() {
    final controller = widget.controller ?? _internalController;
    if (controller != null) {
      controller.reset();
    }
  }

  void restart() {
    final controller = widget.controller ?? _internalController;
    if (controller != null) {
      controller.reset();
      if (widget.repeat) {
        controller.repeat();
      } else {
        controller.forward();
      }
    }
  }
}

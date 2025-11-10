import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    this.applyImageRadius = true,
    this.border,
    this.borderRadius = Sizes.md,
    this.fit,
    this.image,
    this.file,
    required this.imageType,
    this.overlayColor,
    this.backgroundColor,
    this.memoryImage,
    this.width = 56,
    this.height = 56,
    this.padding = Sizes.sm,
    this.margin,
  });

  final bool applyImageRadius;
  final BoxBorder? border;
  final double borderRadius;
  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;
  final double? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin != null ? EdgeInsets.all(margin!) : null,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = _buildCachedNetworkImage();
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

    return ClipRRect(
      borderRadius: applyImageRadius
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.zero,
      child: imageWidget,
    );
  }

  Widget _buildCachedNetworkImage() {
    if (image != null && image!.isNotEmpty) {
      return CachedNetworkImage(
        fit: fit,
        color: overlayColor,
        imageUrl: image!,
        placeholder: (context, url) => const Center(child: LoadingShimmer()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return const Icon(Icons.broken_image);
    }
  }

  Widget _buildMemoryImage() => memoryImage != null
      ? Image.memory(memoryImage!, fit: fit, color: overlayColor)
      : const Icon(Icons.broken_image);

  Widget _buildAssetImage() => image != null && image!.isNotEmpty
      ? Image.asset(image!, fit: fit, color: overlayColor)
      : const Icon(Icons.broken_image);

  Widget _buildFileImage() => file != null
      ? Image.file(file!, fit: fit, color: overlayColor)
      : const Icon(Icons.broken_image);
}

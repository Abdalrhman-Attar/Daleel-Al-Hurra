import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
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
  });

  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white),
        borderRadius: BorderRadius.circular(width >= height ? width : height),
      ),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;

    switch (imageType) {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(width >= height ? width : height),
      child: imageWidget,
    );
  }

  Widget _buildNetworkImage() {
    if (image != null) {
      return CachedNetworkImage(
        fit: fit,
        color: overlayColor,
        imageUrl: image!,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const Center(child: LoadingShimmer()),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      return Image(
        fit: fit,
        image: MemoryImage(memoryImage!),
        color: overlayColor,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildAssetImage() {
    if (image != null) {
      return Image(
        fit: fit,
        image: AssetImage(image!),
        color: overlayColor,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildFileImage() {
    if (file != null) {
      return Image(
        fit: fit,
        image: FileImage(file!),
        color: overlayColor,
      );
    } else {
      return const SizedBox();
    }
  }
}

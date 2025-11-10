import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../utils/constants/colors.dart';

class SelectableBrandsGrid extends StatelessWidget {
  const SelectableBrandsGrid({
    super.key,
    required this.allBrands,
    required this.selectedBrands,
    required this.onBrandTap,
  });

  final List<CarBrand> allBrands;
  final List<CarBrand> selectedBrands;
  final Function(CarBrand brand) onBrandTap;

  bool isBrandSelected(CarBrand brand) {
    return selectedBrands.any((selectedBrand) => selectedBrand.id == brand.id);
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridView(allBrands, context);
  }

  Widget _buildGridView(List<CarBrand> brands, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: brands.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => _buildBrandCard(brands[index], context),
    );
  }

  Widget _buildBrandCard(CarBrand brand, BuildContext context) {
    const imageSize = 50.0;
    const fontSize = 12.0;
    final isSelected = isBrandSelected(brand);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onBrandTap(brand),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: isSelected ? 1.0 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildBrandImage(brand, imageSize),
                    if (!isSelected)
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    if (isSelected)
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildBrandName(brand, fontSize, isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandImage(CarBrand brand, double size) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColors.cardBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildImage(brand, size),
      ),
    );
  }

  Widget _buildImage(CarBrand brand, double size) {
    final imageUrl = brand.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholderImage(size);
    }

    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholderImage(size),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(size),
      );
    }
  }

  Widget _buildPlaceholderImage(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.directions_car,
        size: size * 0.4,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: LoadingShimmer(),
        ),
      ),
    );
  }

  Widget _buildBrandName(CarBrand brand, double fontSize, bool isSelected) {
    return Text(
      brand.name ?? 'Unknown',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: isSelected ? Colors.grey[800] : Colors.grey[600],
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

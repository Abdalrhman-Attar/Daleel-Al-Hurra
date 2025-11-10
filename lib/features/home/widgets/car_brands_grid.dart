import 'package:flutter/material.dart';

import '../../../model/cars/car_brand/car_brand.dart';
import '../../../module/global_image.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../brand_models/views/brand_models_page.dart';

class CarBrandsGrid extends StatelessWidget {
  const CarBrandsGrid({
    super.key,
    required this.brands,
    this.gridThreshold = 4,
    this.maxDisplayCount,
    this.crossAxisCount = 2,
    this.dealerId,
  });

  final List<CarBrand> brands;
  final int gridThreshold;
  final int? maxDisplayCount;
  final int crossAxisCount;
  final int? dealerId;

  @override
  Widget build(BuildContext context) {
    final displayBrands = maxDisplayCount != null ? brands.take(maxDisplayCount!).toList() : brands;

    return displayBrands.length > gridThreshold ? _buildGridView(displayBrands) : _buildListView(displayBrands, context);
  }

  Widget _buildGridView(List<CarBrand> brands) {
    // Calculate optimal grid dimensions
    final itemCount = brands.length;
    final height = _calculateGridHeight(crossAxisCount, itemCount);

    return SizedBox(
      height: height,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: itemCount,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) => _buildBrandCard(
          brands[index],
          context,
        ),
      ),
    );
  }

  Widget _buildListView(List<CarBrand> brands, BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: brands.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            right: index == brands.length - 1 ? 0 : 12,
          ),
          child: _buildBrandCard(brands[index], context),
        ),
      ),
    );
  }

  Widget _buildBrandCard(CarBrand brand, BuildContext context) {
    const imageSize = 50.0;
    const fontSize = 14.0;
    const minWidth = 70.0; // Minimum width to prevent layout issues
    const maxWidth = 100.0; // Maximum width for better appearance

    // Calculate width based on available space and number of brands
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 32; // Account for horizontal padding
    final brandCount = brands.isNotEmpty ? brands.length : 1; // Prevent division by zero
    final calculatedWidth = (availableWidth / brandCount) - 16;
    final cardWidth = calculatedWidth.clamp(minWidth, maxWidth);

    return SizedBox(
      width: cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrandModelsPage(brand: brand, dealerId: dealerId),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBrandImage(brand, imageSize),
                const SizedBox(height: 8),
                _buildBrandName(brand, fontSize),
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

    return GlobalImage(
      type: ImageType.network,
      url: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
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

  Widget _buildBrandName(CarBrand brand, double fontSize) {
    return Text(
      brand.name ?? '',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  double _calculateGridHeight(int crossAxisCount, int itemCount) {
    const baseItemHeight = 100.0;
    const spacing = 16.0;
    return (baseItemHeight * crossAxisCount) + (spacing * (crossAxisCount - 1));
  }
}

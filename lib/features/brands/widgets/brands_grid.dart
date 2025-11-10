import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../utils/constants/colors.dart';
import '../../brand_models/views/brand_models_page.dart';

class BrandsGrid extends StatelessWidget {
  const BrandsGrid({
    super.key,
    required this.brands,
  });
  final List<CarBrand> brands;
  @override
  Widget build(BuildContext context) {
    return _buildGridView(brands, context);
  }

  Widget _buildGridView(List<CarBrand> brands, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: brands.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 110,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) => _buildBrandCard(brands[index], context),
    );
  }

  Widget _buildBrandCard(CarBrand brand, BuildContext context) {
    const imageSize = 50.0;
    const fontSize = 14.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrandModelsPage(brand: brand),
          ),
        ),
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

    // Check if it's a network image or asset
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

  Widget _buildBrandName(CarBrand brand, double fontSize) {
    return Text(
      brand.name ?? 'Unknown',
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
}

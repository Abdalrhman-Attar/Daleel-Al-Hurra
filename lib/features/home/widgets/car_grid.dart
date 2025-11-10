import 'package:flutter/material.dart';

import '../../../model/cars/car/car.dart';
import 'car_card.dart';

class CarGrid extends StatelessWidget {
  const CarGrid({
    super.key,
    required this.filteredCars,
    this.isMyCars = false,
  });

  final List<Car> filteredCars;
  final bool isMyCars;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredCars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.48,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, i) =>
            CarCard(car: filteredCars[i], isMyCars: isMyCars),
      ),
    );
  }
}

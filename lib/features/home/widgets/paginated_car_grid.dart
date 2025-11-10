import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../model/cars/car/car.dart';
import 'car_card.dart';

class PaginatedCarGrid extends StatefulWidget {
  const PaginatedCarGrid({
    super.key,
    required this.filteredCars,
    this.isMyCars = false,
    required this.hasMoreData,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.scrollController,
  });

  final List<Car> filteredCars;
  final bool isMyCars;
  final bool hasMoreData;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final ScrollController? scrollController;

  @override
  State<PaginatedCarGrid> createState() => _PaginatedCarGridState();
}

class _PaginatedCarGridState extends State<PaginatedCarGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PaginatedCarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      _scrollController = widget.scrollController ?? ScrollController();
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      widget.scrollController?.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        widget.hasMoreData &&
        !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Car Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 4),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.filteredCars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.48,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, i) => CarCard(
              car: widget.filteredCars[i],
              isMyCars: widget.isMyCars,
            ),
          ),
        ),

        // Loading indicator for pagination
        if (widget.isLoadingMore)
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: LoadingShimmer(),
            ),
          ),

        // No more data indicator
        if (!widget.hasMoreData && widget.filteredCars.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No more cars to load',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../common/widgets/search_field.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../module/global_drop_down.dart';
import '../../../module/global_multi_select_chip.dart';
import '../../../module/global_sheet.dart';
import '../../../module/global_slider_range.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../brands/widgets/brands_grid.dart';
import '../../dealers/widgets/dealer_card_stack.dart';
import '../../home/widgets/car_grid.dart';
import '../controllers/search_controller.dart';

enum SearchType { all, car, dealer, brand }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final SearchController searchController = Get.put(SearchController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.fetchCars();
      searchController.fetchDealers();
      searchController.fetchBrands();
    });
  }

  void _handleTabChange() {
    if (!mounted) return;

    // Ensure we're in a valid state before handling tab change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        // Update the current tab index
        switch (_tabController.index) {
          case 0:
            searchController.fetchCars();
            break;
          case 1:
            searchController.fetchDealers();
            break;
          case 2:
            searchController.fetchBrands();
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel any pending operations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _tabController.dispose();
      }
    });
    super.dispose();
  }

  void _showFilterBottomSheet() {
    searchController.fetchAllData();
    GlobalBottomSheet.show(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr('filter'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 10),

                // Essential Filters Section
                GlobalMultiSelectChip(
                  label: tr('car categories'),
                  items: searchController.allCarCategories.map((e) => ChipData(label: e.name ?? '', value: e.id.toString(), isSelected: false, image: '')).toList(),
                  selectedItems: searchController.selectedCategories.map((e) => e.id.toString()).toList(),
                  onSelectionChanged: (value) async {
                    searchController.selectedCategories = searchController.allCarCategories.where((e) => value.contains(e.id.toString())).toList();
                    await searchController.fetchCars();
                  },
                ),
                const SizedBox(height: 12),

                // Brands
                GlobalMultiSelectChip(
                  label: tr('brands'),
                  items: searchController.allBrands.map((e) => ChipData(label: e.name ?? '', value: e.id.toString(), isSelected: false, image: e.imageUrl ?? '')).toList(),
                  selectedItems: searchController.selectedBrands.map((e) => e.id.toString()).toList(),
                  onSelectionChanged: (value) async {
                    searchController.selectedBrandModels.clear();
                    searchController.selectedBrands = searchController.allBrands.where((e) => value.contains(e.id.toString())).toList();
                    await searchController.fetchBrandModels(searchController.selectedBrands);
                    await searchController.fetchCars();
                  },
                ),

                if (searchController.selectedBrands.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  searchController.isLoading
                      ? const BrandGridShimmer(itemCount: 3)
                      : searchController.selectedBrands.isNotEmpty
                          ? GlobalMultiSelectChip(
                              label: tr('brand models'),
                              items: searchController.allBrandModels.map((e) => ChipData(label: e.name ?? '', value: e.id.toString(), isSelected: false, image: '')).toList(),
                              selectedItems: searchController.selectedBrandModels.map((e) => e.id.toString()).toList(),
                              onSelectionChanged: (value) async {
                                searchController.selectedBrandModels = searchController.allBrandModels.where((e) => value.contains(e.id.toString())).toList();
                                await searchController.fetchCars();
                              },
                            )
                          : const SizedBox(),
                ],

                const SizedBox(height: 12),
                // Price Range
                GlobalSliderRange(
                  label: tr('price'),
                  min: 0,
                  max: 1000000,
                  values: RangeValues(searchController.priceMin.value ?? 0, searchController.priceMax.value ?? 1000000),
                  divisions: 1000000,
                  onChanged: (value) async {
                    searchController.priceMin.value = value.start;
                    searchController.priceMax.value = value.end;
                    await searchController.fetchCars();
                  },
                ),
                const SizedBox(height: 12),

                // Year Range
                GlobalSliderRange(
                  label: tr('year'),
                  min: 2010.toDouble(),
                  max: DateTime.now().year.toDouble(),
                  values: RangeValues(
                    (searchController.yearFrom.value?.toDouble() ?? 2010.toDouble()).clamp(2010.toDouble(), DateTime.now().year.toDouble()),
                    (searchController.yearTo.value?.toDouble() ?? DateTime.now().year.toDouble()).clamp(2010.toDouble(), DateTime.now().year.toDouble()),
                  ),
                  divisions: DateTime.now().year.toInt() - 2010,
                  onChanged: (value) async {
                    searchController.yearFrom.value = value.start.toInt();
                    searchController.yearTo.value = value.end.toInt();
                    await searchController.fetchCars();
                  },
                ),

                const SizedBox(height: 16),

                // Sort By
                GlobalDropdown<String>(
                  label: tr('sort by'),
                  hint: tr('select sorting preference'),
                  items: sortAndOrderBy.entries
                      .map((e) => DropdownItem<String>(
                            value: e.key,
                            label: e.value,
                          ))
                      .toList(),
                  selectedValue: searchController.selectedSortAndOrderBy.value,
                  onChanged: (value) async {
                    searchController.selectedSortAndOrderBy.value = value;
                    await searchController.fetchCars();
                  },
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),

                const SizedBox(height: 16),

                // Advanced Filters Section (Collapsible)
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: MyColors.grey.withValues(alpha: 0.1).withAlpha(25)),
                    ),
                    child: Column(
                      children: [
                        // Header with expand/collapse button
                        InkWell(
                          onTap: () {
                            searchController.isAdvancedFiltersExpanded = !searchController.isAdvancedFiltersExpanded;
                          },
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr('advanced filters'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.textPrimary,
                                  ),
                                ),
                                Icon(
                                  searchController.isAdvancedFiltersExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: MyColors.primary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Advanced Filters Content (only show when expanded)
                        if (searchController.isAdvancedFiltersExpanded) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: MyColors.grey.withValues(alpha: 0.1).withAlpha(25)),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Car Body Type
                                GlobalMultiSelectChip(
                                  label: tr('car body types'),
                                  items: searchController.allBodyTypes.map((e) => ChipData(label: e.name ?? '', value: e.id.toString(), isSelected: false, image: '')).toList(),
                                  selectedItems: searchController.selectedBodyTypes.map((e) => e.id.toString()).toList(),
                                  onSelectionChanged: (value) async {
                                    searchController.selectedBodyTypes = searchController.allBodyTypes.where((e) => value.contains(e.id.toString())).toList();
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Condition
                                GlobalMultiSelectChip(
                                  label: tr('condition'),
                                  items: conditions.map((e) => ChipData(label: tr(e), value: e, isSelected: false, image: '')).toList(),
                                  selectedItems: searchController.condition,
                                  onSelectionChanged: (value) async {
                                    searchController.condition.assignAll(value);
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Transmission
                                GlobalMultiSelectChip(
                                  label: tr('transmission'),
                                  items: transmissions.map((e) => ChipData(label: tr(e), value: e, isSelected: false, image: '')).toList(),
                                  selectedItems: searchController.transmission,
                                  onSelectionChanged: (value) async {
                                    searchController.transmission.assignAll(value);
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Fuel Type
                                GlobalMultiSelectChip(
                                  label: tr('fuel type'),
                                  items: fuelTypes.map((e) => ChipData(label: tr(e), value: e, isSelected: false, image: '')).toList(),
                                  selectedItems: searchController.fuelType,
                                  onSelectionChanged: (value) async {
                                    searchController.fuelType.assignAll(value);
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Drivetrain
                                GlobalMultiSelectChip(
                                  label: tr('drivetrain'),
                                  items: drivetrains.map((e) => ChipData(label: tr(e), value: e, isSelected: false, image: '')).toList(),
                                  selectedItems: searchController.drivetrain,
                                  onSelectionChanged: (value) async {
                                    searchController.drivetrain.assignAll(value);
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Mileage
                                GlobalSliderRange(
                                  label: tr('mileage km'),
                                  min: 0,
                                  max: 50000,
                                  values: RangeValues(
                                    (searchController.mileageMin.value?.toDouble() ?? 0.toDouble()).clamp(0.toDouble(), 50000.toDouble()),
                                    (searchController.mileageMax.value?.toDouble() ?? 50000).clamp(0, 50000),
                                  ),
                                  divisions: 50000,
                                  onChanged: (value) async {
                                    searchController.mileageMin.value = value.start.toInt();
                                    searchController.mileageMax.value = value.end.toInt();
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Engine CC
                                GlobalSliderRange(
                                  label: tr('engine cc'),
                                  min: 0,
                                  max: 10000,
                                  values: RangeValues(
                                    (searchController.engineCcMin.value?.toDouble() ?? 0.toDouble()).clamp(0.toDouble(), 10000.toDouble()),
                                    (searchController.engineCcMax.value?.toDouble() ?? 10000).clamp(0, 10000),
                                  ),
                                  divisions: 10000,
                                  onChanged: (value) async {
                                    searchController.engineCcMin.value = value.start.toInt();
                                    searchController.engineCcMax.value = value.end.toInt();
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Horsepower
                                GlobalSliderRange(
                                  label: tr('horsepower'),
                                  min: 0,
                                  max: 1000,
                                  values: RangeValues(
                                    (searchController.horsepowerMin.value?.toDouble() ?? 0.toDouble()).clamp(0.toDouble(), 1000.toDouble()),
                                    (searchController.horsepowerMax.value?.toDouble() ?? 1000).clamp(0, 1000),
                                  ),
                                  divisions: 1000,
                                  onChanged: (value) async {
                                    searchController.horsepowerMin.value = value.start.toInt();
                                    searchController.horsepowerMax.value = value.end.toInt();
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Doors
                                GlobalSlider(
                                  label: tr('doors'),
                                  min: 1,
                                  max: 10,
                                  value: searchController.doors.value?.toDouble() ?? 1,
                                  divisions: 10,
                                  onChanged: (value) async {
                                    searchController.doors.value = value.toInt();
                                    await searchController.fetchCars();
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Seats
                                GlobalSlider(
                                  label: tr('seats'),
                                  min: 1,
                                  max: 10,
                                  value: searchController.seats.value?.toDouble() ?? 1,
                                  divisions: 10,
                                  onChanged: (value) async {
                                    searchController.seats.value = value.toInt();
                                    await searchController.fetchCars();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
      enableDrag: true,
      enableResize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: MyColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  title: const AppBarLogo(),
                  centerTitle: true,
                  backgroundColor: MyColors.background,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Obx(
                            () => SearchField(
                              onFilter: _tabController.index == 0 ? _showFilterBottomSheet : null,
                              controller: _tabController.index == 0
                                  ? searchController.query.value
                                  : _tabController.index == 1
                                      ? searchController.dealerName.value
                                      : searchController.brandName.value,
                              hint: tr('search'),
                              onChange: () async {
                                if (_tabController.index == 0) {
                                  await searchController.fetchCars();
                                } else if (_tabController.index == 1) {
                                  await searchController.fetchDealers();
                                } else if (_tabController.index == 2) {
                                  await searchController.fetchBrands();
                                }
                              },
                              onSearch: () async {
                                if (_tabController.index == 0) {
                                  await searchController.fetchCars();
                                } else if (_tabController.index == 1) {
                                  await searchController.fetchDealers();
                                } else if (_tabController.index == 2) {
                                  await searchController.fetchBrands();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => TabBar(
                            controller: _tabController,
                            labelColor: MyColors.primary,
                            unselectedLabelColor: MyColors.grey600,
                            unselectedLabelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyFonts.getFontFamily(),
                            ),
                            indicatorColor: MyColors.primary,
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              fontFamily: MyFonts.getFontFamily(),
                            ),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                            tabs: [
                              Tab(text: '${tr('cars')} (${searchController.carsCount})'),
                              Tab(text: '${tr('dealers')} (${searchController.dealersCount})'),
                              Tab(text: '${tr('brands')} (${searchController.brandsCount})'),
                            ],
                          ),
                        ),

                        // Filter Summary (only show when there are active filters)
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () async {
                await searchController.fetchCars();
                await searchController.fetchDealers();
                await searchController.fetchBrands();
              },
              child: _buildTabView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return PageStorage(
      key: const PageStorageKey<String>('search_page_tabs'),
      bucket: PageStorageBucket(),
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          KeyedSubtree(
            key: const ValueKey('cars_tab'),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  searchController.loadMoreCars();
                }
                return true;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Obx(() => _buildFilterSummary()),
                    const SizedBox(height: 10),
                    _buildCarsList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey('dealers_tab'),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildDealersList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey('brands_tab'),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildBrandsList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarsList() {
    return Obx(
      () {
        if (!mounted) return const SizedBox();

        if (searchController.isLoading) {
          return const CarGridShimmer();
        }

        if (searchController.cars.isEmpty) {
          return _buildEmptyState('No cars found');
        }

        return Column(
          children: [
            CarGrid(
              key: ValueKey('car_grid_${_tabController.index}'),
              filteredCars: searchController.cars,
            ),
            // Loading indicator for pagination
            if (searchController.isLoadingMore)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: LoadingShimmer(),
                ),
              ),
            // No more data indicator
            if (!searchController.hasMorePages && searchController.cars.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No more cars to load',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDealersList() {
    return Obx(
      () {
        if (!mounted) return const SizedBox();

        if (searchController.isLoading) {
          return const CarGridShimmer();
        }

        if (searchController.dealers.isEmpty) {
          return _buildEmptyState('No dealers found');
        }

        return DealerCardStack(
          key: ValueKey('dealer_stack_${_tabController.index}'),
          dealers: searchController.dealers,
          onStackEmpty: () {
            if (!mounted) return;
            // Optional: Handle when stack is empty
            debugPrint('All dealers have been explored!');
          },
          onForward: (index, info) {
            if (!mounted) return;
            // Optional: Handle swipe logic
            debugPrint('Swiped dealer at index: $index');
          },
        );
      },
    );
  }

  Widget _buildBrandsList() {
    return Obx(
      () {
        if (!mounted) return const SizedBox();

        if (searchController.isLoading) {
          return const CarGridShimmer();
        }

        if (searchController.brands.isEmpty) {
          return _buildEmptyState('No brands found');
        }

        return BrandsGrid(key: ValueKey('brands_grid_${_tabController.index}'), brands: searchController.brands);
      },
    );
  }

  Widget _buildFilterSummary() {
    // Only show summary if we're on the cars tab
    if (_tabController.index != 0) return const SizedBox.shrink();

    var activeFilters = <String>[];

    // Check categories
    if (searchController.selectedCategories.isNotEmpty) {
      final categoryNames = searchController.selectedCategories.map((cat) => cat.name ?? '').where((name) => name.isNotEmpty).take(2).join(', ');
      if (categoryNames.isNotEmpty) {
        activeFilters.add('📂 $categoryNames${searchController.selectedCategories.length > 2 ? ' +${searchController.selectedCategories.length - 2}' : ''}');
      }
    }

    // Check brands
    if (searchController.selectedBrands.isNotEmpty) {
      final brandNames = searchController.selectedBrands.map((brand) => brand.name ?? '').where((name) => name.isNotEmpty).take(2).join(', ');
      if (brandNames.isNotEmpty) {
        activeFilters.add('🏷️ $brandNames${searchController.selectedBrands.length > 2 ? ' +${searchController.selectedBrands.length - 2}' : ''}');
      }
    }

    // Check brand models
    if (searchController.selectedBrandModels.isNotEmpty) {
      final modelNames = searchController.selectedBrandModels.map((model) => model.name ?? '').where((name) => name.isNotEmpty).take(2).join(', ');
      if (modelNames.isNotEmpty) {
        activeFilters.add('🚗 $modelNames${searchController.selectedBrandModels.length > 2 ? ' +${searchController.selectedBrandModels.length - 2}' : ''}');
      }
    }

    // Check price range (only if different from defaults)
    final minPrice = searchController.priceMin.value ?? 0;
    final maxPrice = searchController.priceMax.value ?? 1000000;
    if (minPrice > 0 || maxPrice < 1000000) {
      final priceText = minPrice == 0
          ? 'Up to \$${maxPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
          : maxPrice == 1000000
              ? 'From \$${minPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
              : '\$${minPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} - \$${maxPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
      activeFilters.add('💰 $priceText');
    }

    // Check year range (only if different from defaults)
    final minYear = searchController.yearFrom.value ?? 2010;
    final maxYear = searchController.yearTo.value ?? DateTime.now().year;
    if (minYear > 2010 || maxYear < DateTime.now().year) {
      final yearText = minYear == 2010
          ? 'Up to $maxYear'
          : maxYear == DateTime.now().year
              ? 'From $minYear'
              : '$minYear - $maxYear';
      activeFilters.add('📅 $yearText');
    }

    // Check sort order
    if (searchController.selectedSortAndOrderBy.value != null) {
      final sortLabel = sortAndOrderBy[searchController.selectedSortAndOrderBy.value] ?? '';
      if (sortLabel.isNotEmpty) {
        activeFilters.add('🔄 $sortLabel');
      }
    }

    // Check advanced filters (only if expanded and has selections)
    if (searchController.isAdvancedFiltersExpanded) {
      var advancedItems = <String>[];

      if (searchController.selectedBodyTypes.isNotEmpty) {
        advancedItems.add('${searchController.selectedBodyTypes.length} body type(s)');
      }
      if (searchController.condition.isNotEmpty) {
        advancedItems.add('${searchController.condition.length} condition(s)');
      }
      if (searchController.transmission.isNotEmpty) {
        advancedItems.add('${searchController.transmission.length} transmission(s)');
      }
      if (searchController.fuelType.isNotEmpty) {
        advancedItems.add('${searchController.fuelType.length} fuel type(s)');
      }
      if (searchController.drivetrain.isNotEmpty) {
        advancedItems.add('${searchController.drivetrain.length} drivetrain(s)');
      }

      // Check mileage (only if different from defaults)
      final minMileage = searchController.mileageMin.value ?? 0;
      final maxMileage = searchController.mileageMax.value ?? 50000;
      if (minMileage > 0 || maxMileage < 50000) {
        advancedItems.add('mileage range');
      }

      // Check engine CC (only if different from defaults)
      final minEngine = searchController.engineCcMin.value ?? 0;
      final maxEngine = searchController.engineCcMax.value ?? 10000;
      if (minEngine > 0 || maxEngine < 10000) {
        advancedItems.add('engine range');
      }

      // Check horsepower (only if different from defaults)
      final minHp = searchController.horsepowerMin.value ?? 0;
      final maxHp = searchController.horsepowerMax.value ?? 1000;
      if (minHp > 0 || maxHp < 1000) {
        advancedItems.add('power range');
      }

      // Check doors (only if different from default)
      final doors = searchController.doors.value ?? 1;
      if (doors != 1) {
        advancedItems.add('$doors door(s)');
      }

      // Check seats (only if different from default)
      final seats = searchController.seats.value ?? 1;
      if (seats != 1) {
        advancedItems.add('$seats seat(s)');
      }

      if (advancedItems.isNotEmpty) {
        activeFilters.add('⚙️ ${advancedItems.take(2).join(', ')}${advancedItems.length > 2 ? ' +${advancedItems.length - 2}' : ''}');
      }
    }

    // Don't show summary if no filters are active
    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: MyColors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 16,
                color: MyColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                tr('active filters'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MyColors.textPrimary,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  // Clear all filters
                  searchController.clearFilters();
                  searchController.fetchCars();
                },
                child: Text(
                  tr('clear all'),
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: activeFilters.map((filter) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MyColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 11,
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

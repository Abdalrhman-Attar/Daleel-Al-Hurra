import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../api/auth/auth_apis.dart';
import '../../../common/widgets/search_field.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../module/global_drop_down.dart';
import '../../../module/global_multi_select_chip.dart';
import '../../../module/global_sheet.dart';
import '../../../module/global_slider_range.dart';
import '../../../module/toast.dart';
import '../../../stores/user_data_store.dart';
import '../../../utils/constants/colors.dart';
import '../../home/widgets/car_grid.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/my_cars_controller.dart';
import 'add_car_page.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> with TickerProviderStateMixin {
  final MyCarsController searchController = Get.put(MyCarsController());
  late TabController _tabController;
  bool? _accountStatus; // null = loading, true = active, false = inactive

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await  searchController.fetchCars();
      await _checkAccountStatus();
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
            searchController.fetchMyActiveCars();
            break;
          case 1:
            searchController.fetchMyInactiveCars();
            break;
        }
      });
    });
  }

  Future<void> _checkAccountStatus() async {
    try {
      final authApis = AuthApis();
      final response = await authApis.info();

      if (response.isSuccess && response.data?.user?.status != null) {
        setState(() {
          _accountStatus = response.data!.user!.status!;
        });
      } else {
        // Default to active if API call fails
        setState(() {
          _accountStatus = true;
        });
      }
    } catch (e) {
      // Default to active if API call fails
      setState(() {
        _accountStatus = true;
      });
    }
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

                // Car Category
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
                      border: Border.all(color: MyColors.grey.withValues(alpha: 0.1)),
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
                                top: BorderSide(color: MyColors.grey.withValues(alpha: 0.1)),
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
    return Obx(() {
      final userDataStore = Get.find<UserDataStore>();
      final isAccountActive = userDataStore.status;

      return Stack(
        children: [
          // Main page content
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: MyColors.background,
              body: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      title: Text(
                        tr('my cars'),
                        style: TextStyle(
                          color: MyColors.textPrimary,
                          fontSize: 18,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: MyColors.background,
                      elevation: 0,
                      actions: isAccountActive
                          ? [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddCarPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ]
                          : null,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(120),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Obx(
                                () => SearchField(
                                  onFilter: _showFilterBottomSheet,
                                  controller: searchController.query.value,
                                  hint: tr('search'),
                                  onChange: () async => await searchController.fetchCars(),
                                  onSearch: () async => await searchController.fetchCars(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => TabBar(
                                controller: _tabController,
                                labelColor: MyColors.primary,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: MyColors.primary,
                                tabs: [
                                  Tab(text: '${tr('active cars')} (${searchController.myActiveCarsCount})'),
                                  Tab(text: '${tr('inactive cars')} (${searchController.myInactiveCarsCount})'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: RefreshIndicator(
                  onRefresh: () async {
                    await searchController.fetchCars();
                  },
                  child: _buildTabView(),
                ),
              ),
            ),
          ),

          // Account activation overlay
          if (_accountStatus == false) _buildAccountActivationOverlay(context),
        ],
      );
    });
  }

  Widget _buildTabView() {
    return PageStorage(
      key: const PageStorageKey<String>('search_page_tabs'),
      bucket: PageStorageBucket(),
      child: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          KeyedSubtree(
            key: const ValueKey('cars_tab'),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  searchController.loadMoreActiveCars();
                }
                return true;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildFilterSummary(),
                    const SizedBox(height: 10),
                    _buildActiveCarsList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey('inactive_cars_tab'),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  searchController.loadMoreInactiveCars();
                }
                return true;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildFilterSummary(),
                    const SizedBox(height: 10),
                    _buildInactiveCarsList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCarsList() {
    return Obx(
      () {
        if (!mounted) return const SizedBox();

        if (searchController.isLoading && searchController.myActiveCars.isEmpty) {
          return const CarGridShimmer();
        }

        if (searchController.myActiveCars.isEmpty && !searchController.isLoading) {
          return _buildEmptyState(tr('no cars found'));
        }

        return Column(
          children: [
            CarGrid(
              filteredCars: searchController.myActiveCars,
              isMyCars: true,
            ),
            // Loading indicator for pagination
            if (searchController.isLoadingMoreActiveCars)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: LoadingShimmer(),
                ),
              ),
            // No more data indicator
            if (!searchController.hasMoreActiveCars && searchController.myActiveCars.isNotEmpty)
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

  Widget _buildInactiveCarsList() {
    return Obx(
      () {
        if (!mounted) return const SizedBox();

        if (searchController.isLoading && searchController.myInactiveCars.isEmpty) {
          return const CarGridShimmer();
        }

        if (searchController.myInactiveCars.isEmpty && !searchController.isLoading) {
          return _buildEmptyState(tr('no cars found'));
        }

        return Column(
          children: [
            CarGrid(
              filteredCars: searchController.myInactiveCars,
              isMyCars: true,
            ),
            // Loading indicator for pagination
            if (searchController.isLoadingMoreInactiveCars)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: LoadingShimmer(),
                ),
              ),
            // No more data indicator
            if (!searchController.hasMoreInactiveCars && searchController.myInactiveCars.isNotEmpty)
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

  Widget _buildFilterSummary() {
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

  Widget _buildAccountActivationOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: MyColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MyColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_circle,
                  size: 48,
                  color: MyColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                tr('Account Activation Required'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Message
              Text(
                tr('to begin adding cars please contact the admin to activate your account.'),
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Contact buttons
              Row(
                children: [
                  // Phone button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchPhoneCall('+962785228818'),
                      icon: const Icon(Icons.phone),
                      label: Text(tr('call')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // WhatsApp button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchWhatsApp('+962785228818'),
                      icon: const Icon(Icons.message),
                      label: Text(tr('whatsapp')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    debugPrint('📱 Launching WhatsApp for: $phoneNumber');

    try {
      // Clean phone number and format for Jordan
      var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      debugPrint('🧹 Cleaned number: $cleanNumber');

      // Format Jordanian phone number
      var formattedNumber = _formatJordanianNumber(cleanNumber);
      debugPrint('🇯🇴 Formatted Jordanian number: $formattedNumber');

      // For Android, try direct launch first (bypass canLaunchUrl check)
      try {
        debugPrint('🚀 Trying direct WhatsApp launch...');
        final whatsappUri = Uri.parse('whatsapp://send?phone=$formattedNumber');
        await url_launcher.launchUrl(whatsappUri, mode: url_launcher.LaunchMode.externalApplication);
        debugPrint('✅ WhatsApp launched directly!');
        return;
      } catch (e) {
        debugPrint('💥 Direct launch failed, trying other methods...');
      }

      // Try different WhatsApp URL formats
      var whatsappUrls = <String>[
        'whatsapp://send?phone=$formattedNumber', // WhatsApp URI with formatted number
        'https://wa.me/$formattedNumber', // Web format with formatted number
      ];

      for (var url in whatsappUrls) {
        try {
          final uri = Uri.parse(url);
          debugPrint('🔗 Trying WhatsApp URL: $url');

          // For Android, sometimes canLaunchUrl returns false even when the app can handle it
          // So we'll try to launch and catch any exceptions
          await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);
          debugPrint('🚀 WhatsApp launched with URL: $url');
          return;
        } catch (e) {
          debugPrint('💥 Error with URL $url: $e');
          continue;
        }
      }

      // If all WhatsApp URLs fail, try to open WhatsApp app directly
      debugPrint('📱 Trying to open WhatsApp app directly...');
      try {
        final whatsappAppUri = Uri.parse('whatsapp://');
        await url_launcher.launchUrl(whatsappAppUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('WhatsApp opened. Please search for the contact manually.');
        return;
      } catch (e) {
        debugPrint('💥 WhatsApp app direct launch failed: $e');
      }

      // If WhatsApp is not installed, suggest installing it
      debugPrint('📱 WhatsApp not found, trying to open Play Store...');
      try {
        final playStoreUri = Uri.parse('market://details?id=com.whatsapp');
        await url_launcher.launchUrl(playStoreUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('Please install WhatsApp to chat with this number');
        return;
      } catch (e) {
        debugPrint('💥 Play Store launch failed: $e');
      }

      // Last resort: regular phone call
      debugPrint('📞 Falling back to phone call...');
      try {
        final telUri = Uri.parse('tel:$phoneNumber');
        await url_launcher.launchUrl(telUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('WhatsApp not available, calling instead');
        return;
      } catch (e) {
        debugPrint('💥 Phone call fallback failed: $e');
      }

      // If everything fails
      Toast.e('Could not open WhatsApp. Please make sure it\'s installed and try again.');
    } catch (e) {
      debugPrint('💥 Error launching WhatsApp: $e');
      Toast.e('Error opening WhatsApp');
    }
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
            tr('try adjusting your search or filters'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatJordanianNumber(String phoneNumber) {
    debugPrint('🔢 Formatting number: $phoneNumber');

    // Remove any existing country codes or prefixes
    var clean = phoneNumber.replaceAll(RegExp(r'^(\+962|962|00962)'), '');

    // Remove any non-digit characters
    clean = clean.replaceAll(RegExp(r'[^\d]'), '');

    debugPrint('🧹 Cleaned number: $clean');

    // Check the length and format accordingly
    if (clean.length == 9) {
      // Jordanian mobile numbers are 9 digits (without country code)
      // Format: +962XXXXXXXXX
      var formatted = '+962$clean';
      debugPrint('🇯🇴 Formatted 9-digit number: $formatted');
      return formatted;
    } else if (clean.length == 10 && clean.startsWith('0')) {
      // Numbers that start with 0 (like 0799741516)
      // Remove the leading 0 and add country code
      var formatted = '+962${clean.substring(1)}';
      debugPrint('🇯🇴 Formatted 10-digit number (with 0): $formatted');
      return formatted;
    } else if (clean.length == 12 && clean.startsWith('962')) {
      // Numbers that already have 962 prefix
      var formatted = '+$clean';
      debugPrint('🇯🇴 Formatted 12-digit number (with 962): $formatted');
      return formatted;
    } else if (clean.length == 13 && clean.startsWith('+962')) {
      // Numbers that already have +962 prefix
      debugPrint('🇯🇴 Number already properly formatted: $clean');
      return clean;
    } else {
      // For any other format, assume it's a Jordanian number and add +962
      var formatted = '+962$clean';
      debugPrint('🇯🇴 Default formatting (added +962): $formatted');
      return formatted;
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    debugPrint('📞 Launching phone call for: $phoneNumber');

    try {
      // Format the number for calling (don't add + prefix for tel: URLs)
      var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      var formattedNumber = _formatPhoneNumberForCall(cleanNumber);
      debugPrint('📱 Formatted number for call: $formattedNumber');

      final telUri = Uri.parse('tel:$formattedNumber');
      await url_launcher.launchUrl(telUri, mode: url_launcher.LaunchMode.externalApplication);
      debugPrint('✅ Phone call launched successfully!');
    } catch (e) {
      debugPrint('💥 Error launching phone call: $e');
      Toast.e('Could not make phone call');
    }
  }

  String _formatPhoneNumberForCall(String phoneNumber) {
    // For phone calls, we want the number in international format without the +
    var clean = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (clean.length == 9) {
      // 9 digits - add Jordan country code
      return '962$clean';
    } else if (clean.length == 10 && clean.startsWith('0')) {
      // 10 digits starting with 0 - replace 0 with 962
      return '962${clean.substring(1)}';
    } else if (clean.length == 12 && clean.startsWith('962')) {
      // Already has 962 prefix
      return clean;
    } else if (clean.length == 13 && clean.startsWith('962')) {
      // Has +962 but we remove the + for tel URLs
      return clean;
    } else {
      // Default: assume it's Jordanian and add 962
      return '962$clean';
    }
  }
}

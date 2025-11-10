import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/shimmer/loading_shimmer.dart';
import '../../../main.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car/car.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../model/cars/car_category/car_category.dart';
import '../../../module/global_drop_down.dart';
import '../../../module/global_elevated_button.dart';
import '../../../module/global_image.dart';
import '../../../module/global_text_button.dart';
import '../../../module/global_text_field.dart';
import '../../../module/toast.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/add_car_controller.dart';
import '../controllers/edit_car_controller.dart';

// Step data class
class StepData {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  const StepData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class UpdateCarPage extends StatefulWidget {
  const UpdateCarPage({super.key, required this.car});
  final Car car;

  @override
  State<UpdateCarPage> createState() => _UpdateCarPageState();
}

class _UpdateCarPageState extends State<UpdateCarPage> {
  final EditCarController controller = Get.put(EditCarController());

  // Step management
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Step completion status
  final List<bool> _stepCompleted = [false, false, false, false];

  // Step definitions
  List<StepData> get _steps => [
        StepData(
          title: tr('basic info'),
          subtitle: tr('select brand, model and basic details'),
          icon: Icons.directions_car,
          isCompleted: _stepCompleted[0],
          isActive: _currentStep == 0,
        ),
        StepData(
          title: tr('specifications'),
          subtitle: tr('engine, transmission and technical details'),
          icon: Icons.settings,
          isCompleted: _stepCompleted[1],
          isActive: _currentStep == 1,
        ),
        StepData(
          title: tr('pricing & details'),
          subtitle: tr('price, mileage and additional information'),
          icon: Icons.attach_money,
          isCompleted: _stepCompleted[2],
          isActive: _currentStep == 2,
        ),
        StepData(
          title: tr('media'),
          subtitle: tr('upload photos and videos'),
          icon: Icons.photo_camera,
          isCompleted: _stepCompleted[3],
          isActive: _currentStep == 3,
        ),
      ];

  @override
  void initState() {
    super.initState();
    controller.carId = widget.car.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllData();

      controller.selectedCategory = widget.car.category;
      controller.selectedBrand = widget.car.brand;
      controller.fetchBrandModels([widget.car.brand!]);
      controller.selectedBrandModel = widget.car.brandModel;
      controller.selectedBodyType = widget.car.bodyType;
      controller.titleController.text = widget.car.title ?? '';
      controller.descriptionController.text = widget.car.description ?? '';
      controller.year.text = widget.car.year.toString();
      controller.price.text = widget.car.price.toString();
      controller.mileageKm = widget.car.mileageKm;
      controller.horsepower.text = widget.car.horsepower.toString();
      controller.doors.text = widget.car.doors.toString();
      controller.seats.text = widget.car.seats.toString();
      controller.condition = widget.car.condition!.capitalize;
      controller.transmission = widget.car.transmission!.capitalize;
      controller.fuelType = widget.car.fuelType!.capitalize;
      if (widget.car.drivetrain == 'other') {
        controller.drivetrain = widget.car.drivetrain!.capitalize;
      } else {
        // capitalize each char in drivetrain not just the fisrt
        debugPrint(widget.car.drivetrain!.split('').map((word) => word.capitalize).join(''));
        controller.drivetrain = widget.car.drivetrain!.split('').map((word) => word.capitalize).join('');
      }

      controller.oldCoverImage = widget.car.coverImage;
      controller.oldImages = widget.car.images ?? [];
      controller.oldVideo = widget.car.video;
      controller.oldSelectedColors = widget.car.colors ?? [];

      // Initialize mixed images list
      controller.initializeMixedImages();

      // Initialize colors from old data
      controller.initializeColorsFromOldData();
    });
  }

  // Step validation methods
  bool _validateCurrentStep() {
    var isValid = true;
    var errorMessage = '';

    switch (_currentStep) {
      case 0: // Basic Info Step
        if (controller.selectedCategory == null) {
          isValid = false;
          errorMessage = tr('please select a category');
        } else if (controller.selectedBrand == null) {
          isValid = false;
          errorMessage = tr('please select a brand');
        } else if (controller.selectedBrandModel == null) {
          isValid = false;
          errorMessage = tr('please select a model');
        } else if (controller.selectedBodyType == null) {
          isValid = false;
          errorMessage = tr('please select a body type');
        } else if (controller.titleController.text.trim().isEmpty) {
          isValid = false;
          errorMessage = tr('title is required');
        } else if (controller.descriptionController.text.trim().length < 10) {
          isValid = false;
          errorMessage = tr('description must be at least 10 characters');
        }
        break;

      case 1: // Specifications Step
        if (controller.mileageKm == null || controller.mileageKm!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select mileage');
        } else if (controller.horsepower.text.isEmpty) {
          isValid = false;
          errorMessage = tr('horsepower is required');
        } else if (controller.doors.text.isEmpty) {
          isValid = false;
          errorMessage = tr('doors is required');
        } else if (controller.seats.text.isEmpty) {
          isValid = false;
          errorMessage = tr('seats is required');
        }
        break;

      case 2: // Pricing & Details Step
        if (controller.price.text.isEmpty && controller.downPayment.text.isEmpty) {
          isValid = false;
          errorMessage = tr('price or down payment is required');
        } else if (controller.condition == null || controller.condition!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select condition');
        } else if (controller.transmission == null || controller.transmission!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select transmission');
        } else if (controller.fuelType == null || controller.fuelType!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select fuel type');
        } else if (controller.drivetrain == null || controller.drivetrain!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select drivetrain');
        }
        break;

      case 3: // Media Step
        // Media step is optional, so no validation required
        break;
    }

    if (!isValid && errorMessage.isNotEmpty) {
      Toast.e(errorMessage);
    } else if (isValid) {
      setState(() {
        _stepCompleted[_currentStep] = true;
      });
    }

    return isValid;
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      Toast.e(tr('please fill in all required fields'));
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToStep(int step) {
    if (step < _currentStep || _stepCompleted[step - 1]) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  Future<void> _submitForm() async {
    // Validate all steps before submission
    var allValid = true;
    for (var i = 0; i < _totalSteps; i++) {
      if (!await _validateStep(i)) {
        allValid = false;
        setState(() {
          _currentStep = i;
          _stepCompleted[i] = false;
        });
        break;
      }
    }

    if (allValid) {
      await controller.editCar(context: context);
      if (context.mounted) {
        Get.back();
      }
    } else {
      Toast.e(tr('please complete all required steps'));
    }
  }

  Future<bool> _validateStep(int stepIndex) async {
    var isValid = true;
    var errorMessage = '';

    switch (stepIndex) {
      case 0: // Basic Info Step
        if (controller.selectedCategory == null) {
          isValid = false;
          errorMessage = tr('please select a category');
        } else if (controller.selectedBrand == null) {
          isValid = false;
          errorMessage = tr('please select a brand');
        } else if (controller.selectedBrandModel == null) {
          isValid = false;
          errorMessage = tr('please select a model');
        } else if (controller.selectedBodyType == null) {
          isValid = false;
          errorMessage = tr('please select a body type');
        } else if (controller.titleController.text.trim().isEmpty) {
          isValid = false;
          errorMessage = tr('title is required');
        } else if (controller.descriptionController.text.trim().length < 10) {
          isValid = false;
          errorMessage = tr('description must be at least 10 characters');
        }
        break;

      case 1: // Specifications Step
        if (controller.mileageKm == null || controller.mileageKm!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select mileage');
        } else if (controller.horsepower.text.isEmpty) {
          isValid = false;
          errorMessage = tr('horsepower is required');
        } else if (controller.doors.text.isEmpty) {
          isValid = false;
          errorMessage = tr('doors is required');
        } else if (controller.seats.text.isEmpty) {
          isValid = false;
          errorMessage = tr('seats is required');
        }
        break;

      case 2: // Pricing & Details Step
        if (controller.price.text.isEmpty && controller.downPayment.text.isEmpty) {
          isValid = false;
          errorMessage = tr('price or down payment is required');
        } else if (controller.condition == null || controller.condition!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select condition');
        } else if (controller.transmission == null || controller.transmission!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select transmission');
        } else if (controller.fuelType == null || controller.fuelType!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select fuel type');
        } else if (controller.drivetrain == null || controller.drivetrain!.isEmpty) {
          isValid = false;
          errorMessage = tr('please select drivetrain');
        }
        break;

      case 3: // Media Step
        // Media step is optional, so no validation required
        break;
    }

    if (!isValid && errorMessage.isNotEmpty) {
      Toast.e(errorMessage);
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('update car'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (controller.isLoading) {
              Toast.e(tr('please wait for the form to be submitted'));
            } else {
              Navigator.of(context).pop();
              controller.clearAll();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _currentStep = 0;
                _stepCompleted.fillRange(0, _stepCompleted.length, false);
              });
              controller.clearAll();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: LoadingShimmer());
        }
        return Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: _buildStepContent(),
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(),
            const SizedBox(height: 60),
          ],
        );
      }),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: MyColors.surface,
        border: Border(
          bottom: BorderSide(color: MyColors.grey.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(_totalSteps, (index) {
              final step = _steps[index];
              final isCompleted = step.isCompleted;
              final isActive = step.isActive;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _goToStep(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        // Step circle
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? MyColors.primary
                                : isActive
                                    ? MyColors.primary.withValues(alpha: 0.2)
                                    : MyColors.grey.withValues(alpha: 0.2),
                            border: Border.all(
                              color: isActive ? MyColors.primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, color: MyColors.white, size: 20)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isActive ? MyColors.primary : MyColors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Step title
                        Text(
                          step.title.split(' ')[0], // Shortened title
                          style: TextStyle(
                            fontSize: 16,
                            color: isActive ? MyColors.primary : MyColors.grey,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Current step info
          Row(
            children: [
              Icon(_steps[_currentStep].icon, color: MyColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[_currentStep].title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    Text(
                      _steps[_currentStep].subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: MyColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildSpecificationsStep();
      case 2:
        return _buildPricingDetailsStep();
      case 3:
        return _buildMediaStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.white,
        border: Border(
          top: BorderSide(color: MyColors.grey.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          if (_currentStep > 0)
            Expanded(
              child: GlobalTextButton(
                text: tr('previous'),
                onPressed: _previousStep,
              ),
            )
          else
            const Spacer(),

          if (_currentStep > 0) const SizedBox(width: 12),

          // Next/Submit button
          Expanded(
            flex: 2,
            child: GlobalElevatedButton(
              text: _currentStep == _totalSteps - 1 ? tr('update car') : tr('next'),
              onPressed: _currentStep == _totalSteps - 1 ? _submitForm : _nextStep,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(_steps[0].title),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Category Dropdown
        GlobalDropdown<CarCategory>(
          enableSearch: true,
          items: controller.allCarCategories
              .map((category) => DropdownItem(
                    value: category,
                    label: category.name ?? tr('unknown category'),
                    icon: category.imageUrl != null
                        ? GlobalImage(
                            url: category.imageUrl!,
                            type: ImageType.network,
                            fit: BoxFit.cover,
                            width: 20,
                            height: 20,
                          )
                        : null,
                  ))
              .toList(),
          selectedValue: controller.selectedCategory,
          onChanged: (category) => controller.selectedCategory = category,
          hint: tr('select category'),
          label: tr('category'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Brand Dropdown
        GlobalDropdown<CarBrand>(
          enableSearch: true,
          items: controller.allBrands
              .map((brand) => DropdownItem(
                    value: brand,
                    label: brand.name ?? tr('unknown brand'),
                    icon: brand.imageUrl != null
                        ? GlobalImage(
                            url: brand.imageUrl!,
                            type: ImageType.network,
                            fit: BoxFit.cover,
                            width: 20,
                            height: 20,
                          )
                        : null,
                  ))
              .toList(),
          selectedValue: controller.selectedBrand,
          onChanged: (brand) {
            controller.selectedBrand = brand;
            if (brand != null) {
              controller.fetchBrandModels([brand]);
            }
          },
          hint: tr('select brand'),
          label: tr('brand'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Brand Model Dropdown
        GlobalDropdown<BrandModel>(
          enableSearch: true,
          items: controller.allBrandModels
              .map((model) => DropdownItem(
                    value: model,
                    label: model.name ?? tr('unknown model'),
                  ))
              .toList(),
          selectedValue: controller.selectedBrandModel,
          onChanged: (model) => controller.selectedBrandModel = model,
          hint: tr('select model'),
          label: tr('model'),
          enabled: controller.selectedBrand != null,
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Body Type Dropdown
        GlobalDropdown<CarBodyType>(
          enableSearch: true,
          items: controller.allCarBodyTypes
              .map((bodyType) => DropdownItem(
                    value: bodyType,
                    label: bodyType.name ?? tr('unknown body type'),
                  ))
              .toList(),
          selectedValue: controller.selectedBodyType,
          onChanged: (bodyType) => controller.selectedBodyType = bodyType,
          hint: tr('select body type'),
          label: tr('body type'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Title Field
        GlobalTextFormField(
          identifier: tr('Title'),
          hint: tr('enter car title'),
          controller: controller.titleController,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return tr('title is required');
            }
            return null;
          },
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Description Field
        GlobalTextFormField(
          identifier: tr('description'),
          hint: tr('enter car description'),
          controller: controller.descriptionController,
          textColor: MyColors.textPrimary,
          maxLines: 3,
          height: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return tr('description is required');
            }
            if (value.trim().length < 10) {
              return tr('description must be at least 10 characters');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSpecificationsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(_steps[1].title),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Year Slider
        _buildYearSlider(),
        const SizedBox(height: Sizes.spaceBetweenItems),
        // Mileage Field
        GlobalDropdown<String>(
          enableSearch: true,
          items: mileageKms
              .map((condition) => DropdownItem(
                    value: condition,
                    label: tr(condition),
                  ))
              .toList(),
          selectedValue: controller.mileageKm,
          onChanged: (mileageKm) => controller.mileageKm = mileageKm,
          hint: tr('select mileage'),
          label: tr('mileage'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Horsepower Field
        GlobalTextFormField(
          identifier: tr('horsepower'),
          hint: tr('enter horsepower'),
          controller: controller.horsepower,
          keyboardType: TextInputType.number,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('horsepower is required');
            }
            final hp = int.tryParse(value);
            if (hp == null || hp <= 0 || hp > 2000) {
              return tr('please enter valid horsepower');
            }
            return null;
          },
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Doors Field
        GlobalTextFormField(
          identifier: tr('doors'),
          hint: tr('enter number of doors'),
          controller: controller.doors,
          keyboardType: TextInputType.number,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('doors is required');
            }
            final doors = int.tryParse(value);
            if (doors == null || doors < 1 || doors > 10) {
              return tr('please enter valid number of doors');
            }
            return null;
          },
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Seats Field
        GlobalTextFormField(
          identifier: tr('seats'),
          hint: tr('enter number of seats'),
          controller: controller.seats,
          keyboardType: TextInputType.number,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('seats is required');
            }
            final seats = int.tryParse(value);
            if (seats == null || seats < 1 || seats > 20) {
              return tr('please enter valid number of seats');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPricingDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(_steps[2].title),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Price Field
        GlobalTextFormField(
          identifier: tr('price'),
          hint: tr('enter price'),
          controller: controller.price,
          keyboardType: TextInputType.number,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('price is required');
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return tr('please enter valid price');
            }
            return null;
          },
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),
        GlobalTextFormField(
          identifier: tr('down Payment'),
          hint: tr('enter down payment'),
          controller: controller.downPayment,
          keyboardType: TextInputType.number,
          textColor: MyColors.textPrimary,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('down payment is required');
            }
            final downPayment = double.tryParse(value);
            if (downPayment == null || downPayment <= 0) {
              return tr('please enter valid down payment');
            }
            return null;
          },
        ),

        const SizedBox(height: Sizes.spaceBetweenItems),

        // Condition Dropdown
        GlobalDropdown<String>(
          items: conditions
              .map((condition) => DropdownItem(
                    value: condition,
                    label: tr(condition),
                  ))
              .toList(),
          selectedValue: controller.condition,
          onChanged: (condition) => controller.condition = condition,
          hint: tr('select condition'),
          label: tr('condition'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Transmission Dropdown
        GlobalDropdown<String>(
          items: transmissions
              .map((transmission) => DropdownItem(
                    value: transmission,
                    label: tr(transmission),
                  ))
              .toList(),
          selectedValue: controller.transmission,
          onChanged: (transmission) => controller.transmission = transmission,
          hint: tr('select transmission'),
          label: tr('transmission'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Fuel Type Dropdown
        GlobalDropdown<String>(
          items: fuelTypes
              .map((fuelType) => DropdownItem(
                    value: fuelType,
                    label: tr(fuelType),
                  ))
              .toList(),
          selectedValue: controller.fuelType,
          onChanged: (fuelType) => controller.fuelType = fuelType,
          hint: tr('select fuel type'),
          label: tr('fuel type'),
        ),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Drivetrain Dropdown
        GlobalDropdown<String>(
          items: drivetrains
              .map((drivetrain) => DropdownItem(
                    value: drivetrain,
                    label: tr(drivetrain),
                  ))
              .toList(),
          selectedValue: controller.drivetrain,
          onChanged: (drivetrain) => controller.drivetrain = drivetrain,
          hint: tr('select drivetrain'),
          label: tr('drivetrain'),
        ),
      ],
    );
  }

  Widget _buildMediaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(_steps[3].title),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Cover Image
        _buildCoverImageSection(),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Multiple Images
        _buildMultipleImagesSection(),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Video
        _buildVideoSection(),
        const SizedBox(height: Sizes.spaceBetweenSections),

        _buildSectionTitle(tr('exterior colors')),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Exterior Color Selection
        _buildColorSelectionSection('exterior', tr('exterior')),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Exterior Color Images
        _buildColorImagesSection('exterior', tr('exterior')),
        const SizedBox(height: Sizes.spaceBetweenSections),

        _buildSectionTitle(tr('interior colors')),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Interior Color Selection
        _buildColorSelectionSection('interior', tr('interior')),
        const SizedBox(height: Sizes.spaceBetweenItems),

        // Interior Color Images
        _buildColorImagesSection('interior', tr('interior')),
        const SizedBox(height: Sizes.spaceBetweenSections),
      ],
    );
  }

  Widget _buildStepTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: MyColors.primary,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MyColors.primary,
      ),
    );
  }

  Widget _buildYearSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${tr('year')}: ${controller.year.text}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: double.tryParse(controller.year.text) ?? 2010,
          min: 2010,
          max: DateTime.now().year.toDouble() + 1,
          divisions: DateTime.now().year - 2010 + 1,
          label: controller.year.text.toString(),
          onChanged: (value) => controller.year = TextEditingController(text: value.round().toString()),
        ),
      ],
    );
  }

  Widget _buildCoverImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('cover image'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => controller.pickCoverImage(context),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: controller.coverImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GlobalImage(
                      file: controller.coverImage,
                      type: ImageType.file,
                      fit: BoxFit.cover,
                    ),
                  )
                : controller.oldCoverImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GlobalImage(
                          url: controller.oldCoverImage!,
                          type: ImageType.network,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tr('tap to add cover image'),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('car images'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.pickMultipleImages(context),
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(tr('add images')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (controller.allImages.isEmpty)
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.photo_library,
                  size: 32,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  tr('no images selected'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: controller.allImages.length,
            itemBuilder: (context, index) {
              final item = controller.allImages[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item is File
                        ? GlobalImage(
                            file: item,
                            type: ImageType.file,
                            fit: BoxFit.cover,
                          )
                        : GlobalImage(
                            url: item.toString(),
                            type: ImageType.network,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // Indicator for old vs new images
                  if (item is String)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tr('old'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (item is File)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tr('new'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        final item = controller.allImages[index];
                        if (item is File) {
                          controller.removeImage(index);
                        } else {
                          controller.removeOldImage(item.toString());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('video'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => controller.pickVideo(context),
                  icon: const Icon(Icons.videocam),
                  label: Text(tr('add video')),
                ),
                if (controller.video != null || controller.oldVideo != null)
                  TextButton.icon(
                    onPressed: () => controller.removeVideo(),
                    icon: Icon(Icons.delete, color: MyColors.error),
                    label: Text(tr('remove')),
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (controller.video != null || controller.oldVideo != null)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  controller.video != null
                      ? GlobalImage(
                          file: controller.video,
                          type: ImageType.file,
                          fit: BoxFit.cover,
                        )
                      : GlobalImage(
                          url: controller.oldVideo!,
                          type: ImageType.network,
                          fit: BoxFit.cover,
                        ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.video_library,
                  size: 32,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  tr('no video selected'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildColorSelectionSection(String type, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available ${label.capitalizeFirst} Colors',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.allCarColors.map((color) {
            final isSelected = controller.isColorSelected(color, type);
            return GestureDetector(
              onTap: () => controller.toggleColor(color, type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? MyColors.primary : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? MyColors.primary : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _parseColor(color.colorCode),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      color.name ?? tr('unknown'),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorImagesSection(String type, String label) {
    final typeColors = controller.selectedColors.where((color) => color.type == type).toList();
    if (typeColors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${label.capitalizeFirst} Color Images',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...typeColors.map((color) {
          final colorImages = controller.getColorImages(color);
          final oldColorImages = controller.getAvailableOldColorImages(color);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _parseColor(color.color.colorCode),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${color.color.name ?? tr('unknown')} ${tr('images')}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => controller.pickColorImages(context, color),
                    icon: const Icon(Icons.add_photo_alternate, size: 16),
                    label: Text(tr('add')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (colorImages.isEmpty && oldColorImages.isEmpty)
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      tr('no images for this color'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: colorImages.length + oldColorImages.length,
                  itemBuilder: (context, index) {
                    final isOldImage = index >= colorImages.length;
                    final imageIndex = isOldImage ? index - colorImages.length : index;

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: isOldImage
                              ? GlobalImage(
                                  url: oldColorImages[imageIndex],
                                  type: ImageType.network,
                                  fit: BoxFit.cover,
                                )
                              : GlobalImage(
                                  file: colorImages[imageIndex],
                                  type: ImageType.file,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // Show indicator for old images
                        if (isOldImage)
                          Positioned(
                            top: 2,
                            left: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                tr('old'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (isOldImage) {
                                // Remove old image by URL
                                controller.removeOldColorImage(color, oldColorImages[imageIndex]);
                              } else {
                                controller.removeColorImage(color, index);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null || colorCode.isEmpty) {
      return Colors.grey;
    }

    try {
      if (colorCode.startsWith('#')) {
        return Color(int.parse(colorCode.substring(1), radix: 16) + 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/dealer/dealer.dart';

class MapPageController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxList<Dealer> _dealers = <Dealer>[].obs;
  final RxSet<Marker> _markers = <Marker>{}.obs;

  Completer<GoogleMapController>? mapControllerCompleter;
  GoogleMapController? mapController;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  List<Dealer> get dealers => _dealers;
  Set<Marker> get markers => _markers;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set dealers(List<Dealer> value) => _dealers.value = value;

  // Default camera position (Iraq/Baghdad region)
  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(33.3152, 44.3661), // Baghdad, Iraq
    zoom: 6,
  );

  @override
  void onInit() {
    super.onInit();
    mapControllerCompleter = Completer<GoogleMapController>();
    fetchDealers();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  Future<void> fetchDealers({bool isRefresh = false}) async {
    try {
      isError = false;
      if (!isRefresh) {
        isLoading = true;
      }

      final response = await CarsApis().getDealers();

      if (response.isSuccess) {
        dealers = response.data ?? [];
        _createMarkers();

        // Move camera to show all dealers
        if (dealers.isNotEmpty) {
          _fitBoundsToShowAllDealers();
        }
      } else {
        isError = true;
      }
    } catch (e) {
      Logger().e('Error fetching dealers: $e');
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  void _createMarkers() {
    _markers.clear();

    for (var i = 0; i < dealers.length; i++) {
      final dealer = dealers[i];

      // Parse latitude and longitude
      final lat = double.tryParse(dealer.latitude ?? '');
      final lng = double.tryParse(dealer.longitude ?? '');

      if (lat != null && lng != null) {
        final marker = Marker(
          markerId: MarkerId('dealer_${dealer.id}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: dealer.storeName ?? '${dealer.firstName} ${dealer.lastName}',
            snippet: dealer.address ?? 'Tap to view details',
          ),
          onTap: () => onMarkerTapped(dealer),
        );

        _markers.add(marker);
      }
    }
  }

  void onMarkerTapped(Dealer dealer) {
    // This will be handled in the view to have proper context
    // The view will call this method and navigate
  }

  void _fitBoundsToShowAllDealers() async {
    if (dealers.isEmpty || mapController == null) return;

    // Get all valid coordinates
    final validCoordinates = <LatLng>[];
    for (final dealer in dealers) {
      final lat = double.tryParse(dealer.latitude ?? '');
      final lng = double.tryParse(dealer.longitude ?? '');
      if (lat != null && lng != null) {
        validCoordinates.add(LatLng(lat, lng));
      }
    }

    if (validCoordinates.isEmpty) return;

    // Calculate bounds
    var minLat = validCoordinates.first.latitude;
    var maxLat = validCoordinates.first.latitude;
    var minLng = validCoordinates.first.longitude;
    var maxLng = validCoordinates.first.longitude;

    for (final coord in validCoordinates) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Animate camera to fit bounds
    try {
      final controller = await mapControllerCompleter?.future;
      if (controller != null) {
        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      }
    } catch (e) {
      Logger().e('Error fitting bounds: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapControllerCompleter!.isCompleted) {
      mapControllerCompleter!.complete(controller);
      mapController = controller;

      // If dealers are already loaded, fit bounds
      if (dealers.isNotEmpty) {
        _fitBoundsToShowAllDealers();
      }
    }
  }

  Future<void> moveToDealer(Dealer dealer) async {
    final lat = double.tryParse(dealer.latitude ?? '');
    final lng = double.tryParse(dealer.longitude ?? '');

    if (lat != null && lng != null) {
      final controller = await mapControllerCompleter?.future;
      await controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Future<void> refresh() async {
    await fetchDealers(isRefresh: true);
  }
}

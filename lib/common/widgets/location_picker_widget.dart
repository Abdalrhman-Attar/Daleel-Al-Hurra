import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Removed device location dependency

import '../../main.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(double latitude, double longitude)? onLocationSelected;
  final double? initialLatitude;
  final double? initialLongitude;
  final String? hintText;

  const LocationPickerWidget({
    super.key,
    this.onLocationSelected,
    this.initialLatitude,
    this.initialLongitude,
    this.hintText,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _selectedLocation;
  LatLng _cameraPosition = const LatLng(31.963158, 35.930359); // Stable camera position
  bool _isLoading = true;
  String _locationText = '';
  final Set<Marker> _markers = {}; // Use a separate set for markers to reduce rebuilds

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void didUpdateWidget(covariant LocationPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update camera position if initial coordinates changed
    if (widget.initialLatitude != oldWidget.initialLatitude || widget.initialLongitude != oldWidget.initialLongitude) {
      if (widget.initialLatitude != null && widget.initialLongitude != null) {
        _cameraPosition = LatLng(widget.initialLatitude!, widget.initialLongitude!);
        _selectedLocation = _cameraPosition;
        _locationText = '${widget.initialLatitude!.toStringAsFixed(6)}, ${widget.initialLongitude!.toStringAsFixed(6)}';
        _updateMarkers();
      }
    }
  }

  @override
  void dispose() {
    _markers.clear();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    // No device location access: use provided initial or fallback
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _cameraPosition = _selectedLocation!;
      _locationText = '${widget.initialLatitude!.toStringAsFixed(6)}, ${widget.initialLongitude!.toStringAsFixed(6)}';
    } else {
      _selectedLocation = const LatLng(31.963158, 35.930359);
      _cameraPosition = _selectedLocation!;
      _locationText = '31.963158, 35.930359';
    }
    _updateMarkers();
    if (mounted) setState(() => _isLoading = false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('location error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('ok')),
          ),
        ],
      ),
    );
  }

  void _updateMarkers() {
    _markers.clear();
    if (_selectedLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation!,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
    }
  }

  void _onMapTap(LatLng position) {
    // Prevent unnecessary updates if the position hasn't changed significantly
    if (_selectedLocation != null) {
      final distance = _calculateDistance(_selectedLocation!, position);
      if (distance < 1.0) {
        // Less than 1 meter difference
        return; // Don't update for small movements
      }
    }

    _selectedLocation = position;
    _locationText = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    _updateMarkers();

    // Only update the UI for the text, not the entire map
    if (mounted) {
      setState(() {}); // Minimal rebuild for text update only
    }

    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(position.latitude, position.longitude);
    }
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double earthRadius = 6371000; // Earth radius in meters
    final dLat = (pos2.latitude - pos1.latitude) * (math.pi / 180);
    final dLon = (pos2.longitude - pos1.longitude) * (math.pi / 180);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(pos1.latitude * (math.pi / 180)) * math.cos(pos2.latitude * (math.pi / 180)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  void _onConfirmLocation() {
    if (_selectedLocation != null && widget.onLocationSelected != null) {
      widget.onLocationSelected!(_selectedLocation!.latitude, _selectedLocation!.longitude);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85, // Take up most of the screen
      child: Column(
        children: [
          // Current location display - compact version
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationText.isNotEmpty ? _locationText : tr('tap on map to select location'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Map - takes up most of the space
          Expanded(
            flex: 1, // Give map maximum space
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RepaintBoundary(
                    // Isolate map from parent rebuilds
                    child: GoogleMap(
                      key: const ValueKey('location_picker_map'), // Stable key to prevent unnecessary rebuilds
                      initialCameraPosition: CameraPosition(
                        target: _cameraPosition,
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onTap: _onMapTap,
                      markers: Set.from(_markers), // Create a new set to trigger marker updates
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      // Important: Allow map to handle its own gestures
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      // Optimize performance - disable features that cause redraws
                      compassEnabled: false, // Disable compass to reduce redraws
                      mapToolbarEnabled: false, // Disable toolbar
                      buildingsEnabled: false, // Disable buildings for better performance
                      trafficEnabled: false, // Disable traffic for better performance
                    ),
                  ),
          ),

          // Confirm button - fixed at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedLocation != null ? _onConfirmLocation : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(tr('confirm location')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

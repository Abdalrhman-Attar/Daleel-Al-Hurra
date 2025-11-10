import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/cars/cars_apis.dart';
import '../features/car_details/views/car_details_page.dart';
import '../features/dealer_details/views/dealer_details_page.dart';
import '../module/toast.dart';

enum DeepLinkType { car, dealer, unknown }

class DeepLinkData {
  final DeepLinkType type;
  final String id;

  DeepLinkData({required this.type, required this.id});

  factory DeepLinkData.fromUri(Uri uri) {
    debugPrint('🔗 ===== PARSING DEEP LINK =====');
    debugPrint('🔗 Full URI: $uri');
    debugPrint('🔗 Scheme: "${uri.scheme}"');
    debugPrint('🔗 Host: "${uri.host}"');
    debugPrint('🔗 Path: "${uri.path}"');
    debugPrint('🔗 Query: "${uri.query}"');
    debugPrint('🔗 Query Parameters: ${uri.queryParameters}');
    debugPrint('🔗 =============================');

    // Handle HTTPS URLs with query parameters (e.g., https://daleelalhurra.com/app-redirect?type=car&id=149)
    if (uri.scheme == 'https' && uri.host == 'daleelalhurra.com' && uri.path == '/app-redirect') {
      final queryParams = uri.queryParameters;
      final type = queryParams['type'];
      final id = queryParams['id'];

      debugPrint('🔗 ✅ HTTPS redirect URL detected - Type: "$type", ID: "$id"');

      if (type != null && id != null) {
        switch (type) {
          case 'car':
            debugPrint('🚗 ✅ Successfully parsed car ID from HTTPS: $id');
            return DeepLinkData(type: DeepLinkType.car, id: id);
          case 'dealer':
            debugPrint('🏪 ✅ Successfully parsed dealer ID from HTTPS: $id');
            return DeepLinkData(type: DeepLinkType.dealer, id: id);
          default:
            debugPrint('❌ Unknown type in HTTPS URL: $type');
        }
      } else {
        debugPrint('❌ Missing type or id in HTTPS URL - Type: $type, ID: $id');
      }
    } else {
      debugPrint('🔗 Not an HTTPS redirect URL, checking custom scheme...');
      debugPrint('🔗 Scheme match: ${uri.scheme == 'https'}');
      debugPrint('🔗 Host match: ${uri.host == 'daleelalhurra.com'}');
      debugPrint('🔗 Path match: ${uri.path == '/app-redirect'}');
    }

    // Handle custom scheme URLs (e.g., daleelalhurra://car/123)
    // In this format, 'car' or 'dealer' is the HOST, and the ID is in the path
    final pathSegments = uri.pathSegments;
    final host = uri.host;
    debugPrint('🔗 Path segments: $pathSegments');
    debugPrint('🔗 Host: "$host"');

    // Special case: if it's just the base custom scheme (daleelalhurra://) without host or path,
    // treat it as opening the app normally (not an error)
    if (host.isEmpty && pathSegments.isEmpty && uri.scheme == 'daleelalhurra') {
      debugPrint('🔗 Base custom scheme detected - opening app normally');
      return DeepLinkData(type: DeepLinkType.unknown, id: ''); // This will be handled gracefully
    }

    // Check if host contains the type (car/dealer) and path contains the ID
    if (host.isNotEmpty && pathSegments.isNotEmpty) {
      final id = pathSegments[0]; // First path segment is the ID
      debugPrint('🔗 Host-based parsing - Host: "$host", ID: "$id"');

      switch (host) {
        case 'car':
          debugPrint('🚗 ✅ Successfully parsed car ID from host-based custom scheme: $id');
          return DeepLinkData(type: DeepLinkType.car, id: id);
        case 'dealer':
          debugPrint('🏪 ✅ Successfully parsed dealer ID from host-based custom scheme: $id');
          return DeepLinkData(type: DeepLinkType.dealer, id: id);
        default:
          debugPrint('❌ Unknown host: $host');
      }
    }

    // Fallback: Check path-based format (daleelalhurra://car/123 where car is in path)
    if (pathSegments.isNotEmpty) {
      final firstSegment = pathSegments[0];
      debugPrint('🔗 Path-based parsing - First segment: "$firstSegment"');

      switch (firstSegment) {
        case 'car':
          if (pathSegments.length > 1) {
            debugPrint('🚗 ✅ Successfully parsed car ID from path-based custom scheme: ${pathSegments[1]}');
            return DeepLinkData(type: DeepLinkType.car, id: pathSegments[1]);
          } else {
            debugPrint('❌ Car segment found but no ID provided');
          }
          break;
        case 'dealer':
          if (pathSegments.length > 1) {
            debugPrint('🏪 ✅ Successfully parsed dealer ID from path-based custom scheme: ${pathSegments[1]}');
            return DeepLinkData(type: DeepLinkType.dealer, id: pathSegments[1]);
          } else {
            debugPrint('❌ Dealer segment found but no ID provided');
          }
          break;
        default:
          debugPrint('❌ Unknown path segment: $firstSegment');
      }
    }

    debugPrint('❌ Could not parse custom scheme URL - Host: "$host", Path segments: $pathSegments');

    debugPrint('❌ Returning unknown deep link type');
    return DeepLinkData(type: DeepLinkType.unknown, id: '');
  }
}

class DeepLinkService {
  static const String _baseUrl = 'https://daleelalhurra.com';
  static const String _appScheme = 'daleelalhurra://';

  static AppLinks? _appLinks;
  static StreamSubscription<Uri>? _sub;
  static Uri? _pendingDeepLink;
  static bool _isAppInitialized = false;

  /// Initialize deep link handling
  static Future<void> init() async {
    try {
      debugPrint('🔗 🚀 Initializing deep link service...');
      _appLinks = AppLinks();

      // Handle deep links when app is already running
      _sub = _appLinks!.uriLinkStream.listen(
        (Uri uri) async {
          debugPrint('🔗 📱 Received deep link while app is running: $uri');
          if (_isAppInitialized) {
            debugPrint('🔗 📱 App is initialized, processing immediately');
            await _handleDeepLink(uri);
          } else {
            debugPrint('🔗 📱 App not fully initialized, storing pending deep link');
            _pendingDeepLink = uri;
          }
        },
        onError: (err) {
          debugPrint('❌ Deep link stream error: $err');
        },
        cancelOnError: false,
      );

      // Handle deep links when app is launched from cold start
      debugPrint('🔗 🚀 Checking for initial deep link...');
      final initialUri = await _appLinks!.getInitialLink();
      if (initialUri != null) {
        debugPrint('🔗 🚀 ✅ App launched with initial deep link: $initialUri');
        debugPrint('🔗 🚀 App initialization status: $_isAppInitialized');

        if (_isAppInitialized) {
          debugPrint('🔗 🚀 App is already initialized, processing initial link immediately');
          await _handleDeepLink(initialUri);
        } else {
          debugPrint('🔗 🚀 App not fully initialized yet, storing pending initial deep link');
          _pendingDeepLink = initialUri;
          debugPrint('🔗 🚀 Stored pending deep link: $_pendingDeepLink');
        }
      } else {
        debugPrint('🔗 🚀 ❌ No initial deep link detected');
      }

      debugPrint('🔗 ✅ Deep link service initialized successfully');
      debugPrint('🔗 ✅ Current state - App initialized: $_isAppInitialized, Pending link: $_pendingDeepLink');
    } catch (e) {
      debugPrint('❌ Error initializing deep links: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
    }
  }

  /// Dispose of the deep link subscription
  static void dispose() {
    _sub?.cancel();
    _appLinks = null;
    _pendingDeepLink = null;
    _isAppInitialized = false;
    debugPrint('🗑️ Deep link service disposed');
  }

  /// Mark the app as fully initialized and process any pending deep links
  static Future<void> markAppAsInitialized() async {
    debugPrint('🔗 ✅ ===== MARKING APP AS INITIALIZED =====');
    debugPrint('🔗 ✅ Previous state - App initialized: $_isAppInitialized');
    debugPrint('🔗 ✅ Previous state - Pending link: $_pendingDeepLink');

    _isAppInitialized = true;
    debugPrint('🔗 ✅ App is now marked as initialized');

    // If no pending link, try to check for initial link again as a fallback
    if (_pendingDeepLink == null) {
      debugPrint('🔗 🔄 No pending link found, double-checking for initial link...');
      try {
        final initialUri = await _appLinks?.getInitialLink();
        if (initialUri != null) {
          debugPrint('🔗 🔄 ✅ Found initial link on second check: $initialUri');
          _pendingDeepLink = initialUri;
        } else {
          debugPrint('🔗 🔄 ❌ Still no initial link found');
        }
      } catch (e) {
        debugPrint('❌ Error double-checking initial link: $e');
      }
    }

    if (_pendingDeepLink != null) {
      debugPrint('🔗 ⏳ ===== PROCESSING PENDING DEEP LINK =====');
      debugPrint('🔗 ⏳ Pending deep link found: $_pendingDeepLink');
      final pendingLink = _pendingDeepLink!;
      _pendingDeepLink = null;
      debugPrint('🔗 ⏳ Cleared pending deep link from memory');

      // Add a delay to ensure UI is ready and toastification is initialized
      debugPrint('🔗 ⏳ Waiting for UI to be ready (2000ms delay)...');
      await Future.delayed(const Duration(milliseconds: 2000));
      debugPrint('🔗 ⏳ UI should be ready now, processing deep link');

      try {
        await _handleDeepLink(pendingLink);
        debugPrint('🔗 ✅ Successfully processed pending deep link');
      } catch (e) {
        debugPrint('❌ Error processing pending deep link: $e');
        debugPrint('❌ Stack trace: ${StackTrace.current}');
      }
    } else {
      debugPrint('🔗 ✅ No pending deep links to process');
    }

    debugPrint('🔗 ✅ ===== APP INITIALIZATION COMPLETE =====');
  }

  /// Check if there's a pending deep link waiting to be processed
  static bool hasPendingDeepLink() {
    return _pendingDeepLink != null;
  }

  /// Generate a deep link for a car (uses custom scheme for better app opening)
  /// Format: daleelalhurra://car/123 (where 'car' is host, '123' is path)
  static String generateCarDeepLink(int carId) {
    final customSchemeUrl = '${_appScheme}car/$carId';
    debugPrint('🔗 Generated car deep link: $customSchemeUrl');
    return customSchemeUrl;
  }

  /// Generate a deep link for a dealer (uses custom scheme for better app opening)
  /// Format: daleelalhurra://dealer/456 (where 'dealer' is host, '456' is path)
  static String generateDealerDeepLink(int dealerId) {
    final customSchemeUrl = '${_appScheme}dealer/$dealerId';
    debugPrint('🔗 Generated dealer deep link: $customSchemeUrl');
    return customSchemeUrl;
  }

  /// Generate HTTPS deep link for web fallback with app store redirect
  static String generateCarHttpsLink(int carId) {
    final httpsUrl = '$_baseUrl/app-redirect?type=car&id=$carId';
    debugPrint('🌐 Generated car HTTPS link: $httpsUrl');
    return httpsUrl;
  }

  /// Generate HTTPS deep link for web fallback with app store redirect
  static String generateDealerHttpsLink(int dealerId) {
    final httpsUrl = '$_baseUrl/app-redirect?type=dealer&id=$dealerId';
    debugPrint('🌐 Generated dealer HTTPS link: $httpsUrl');
    return httpsUrl;
  }

  /// Generate a general app download link
  static String generateAppDownloadLink() {
    const httpsUrl = '$_baseUrl/app-redirect';
    debugPrint('🌐 Generated app download link: $httpsUrl');
    return httpsUrl;
  }

  /// Handle incoming deep links
  static Future<void> _handleDeepLink(Uri uri) async {
    debugPrint('🔗 ===== DEEP LINK RECEIVED =====');
    debugPrint('🔗 URI: $uri');
    debugPrint('🔗 Scheme: ${uri.scheme}');
    debugPrint('🔗 Host: ${uri.host}');
    debugPrint('🔗 Path: ${uri.path}');
    debugPrint('🔗 Path Segments: ${uri.pathSegments}');
    debugPrint('🔗 Query: ${uri.query}');
    debugPrint('🔗 ==============================');

    try {
      final deepLinkData = DeepLinkData.fromUri(uri);
      debugPrint('🔗 Parsed data - Type: ${deepLinkData.type}, ID: ${deepLinkData.id}');

      switch (deepLinkData.type) {
        case DeepLinkType.car:
          debugPrint('🚗 Navigating to car: ${deepLinkData.id}');
          await _navigateToCar(int.parse(deepLinkData.id));
          break;
        case DeepLinkType.dealer:
          debugPrint('🏪 Navigating to dealer: ${deepLinkData.id}');
          await _navigateToDealer(int.parse(deepLinkData.id));
          break;
        case DeepLinkType.unknown:
          // Check if this is just the base scheme (app opening normally)
          if (uri.scheme == 'daleelalhurra' && uri.pathSegments.isEmpty) {
            debugPrint('🔗 Base scheme detected - app opened normally, no action needed');
            // Don't show error for base scheme, just let the app open normally
          } else {
            debugPrint('❓ Unknown deep link type - showing error');
            _showToastSafe('Invalid link format', isError: false);
            _showErrorDialog('Invalid Link', 'The link format is not recognized.');
          }
          break;
      }
    } catch (e) {
      debugPrint('❌ Error parsing deep link: $e');
      _showToastSafe('Error opening link', isError: true);
      _showErrorDialog('Link Error', 'Could not process the link. Please try again.');
    }
  }

  /// Navigate to car details page
  static Future<void> _navigateToCar(int carId) async {
    try {
      debugPrint('🚗 Starting navigation to car details - ID: $carId');
      _showToastSafe('Opening car details...', isError: false);

      // Fetch car data from API using getCars method with filters
      final carsApi = CarsApis();

      // Use getCars without query parameter since the API doesn't support ID-based queries
      // We'll get all cars and filter client-side by ID
      final response = await carsApi.getCarById(
        carId,
      );

      if (response.status && response.data != null) {
        // Find the car with matching ID from the results
        final car = response.data!;

        debugPrint('🚗 Car data fetched successfully: ${car.title} (ID: ${car.id})');

        // Navigate to car details page
        await Get.to(() => CarDetailsPage(car: car, isMyCar: false));
        debugPrint('🚗 Successfully navigated to car details page');
      } else {
        debugPrint('❌ Failed to fetch car data: ${response.message}');
        _showToastSafe('Car not found or unavailable', isError: true);
        _showErrorDialog('Car Not Found', 'The requested car could not be found.');
      }
    } catch (e) {
      debugPrint('❌ Error navigating to car: $e');
      _showToastSafe('Error opening car details', isError: true);
      _showErrorDialog('Navigation Error', 'Could not open car details.');
    }
  }

  /// Navigate to dealer details page
  static Future<void> _navigateToDealer(int dealerId) async {
    try {
      debugPrint('🏪 Starting navigation to dealer details - ID: $dealerId');
      _showToastSafe('Opening dealer details...', isError: false);

      // Fetch dealer data from API using getDealers method
      final carsApi = CarsApis();

      // Use getDealers without any filtering since API doesn't support ID-based queries
      // We'll get all dealers and filter client-side by ID
      final response = await carsApi.getDealers();

      if (response.status && response.data != null && response.data!.isNotEmpty) {
        // Find the dealer with matching ID from the results
        final dealer = response.data!.firstWhere(
          (d) => d.id == dealerId,
          orElse: () => throw Exception('Dealer with ID $dealerId not found'),
        );

        debugPrint('🏪 Dealer data fetched successfully: ${dealer.storeName} (ID: ${dealer.id})');

        // Navigate to dealer details page
        await Get.to(() => DealerDetailsPage(dealer: dealer));
        debugPrint('🏪 Successfully navigated to dealer details page');
      } else {
        debugPrint('❌ Failed to fetch dealer data: ${response.message}');
        _showToastSafe('Dealer not found or unavailable', isError: true);
        _showErrorDialog('Dealer Not Found', 'The requested dealer could not be found.');
      }
    } catch (e) {
      debugPrint('❌ Error navigating to dealer: $e');
      _showToastSafe('Error opening dealer details', isError: true);
      _showErrorDialog('Navigation Error', 'Could not open dealer details.');
    }
  }

  /// Safely show toast messages, only if Toastification is initialized
  static void _showToastSafe(String message, {required bool isError}) {
    try {
      // Only show toast if we have a valid context and the app is fully initialized
      if (Get.context != null && _isAppInitialized) {
        // Add a small delay to ensure toast context is ready
        Future.delayed(const Duration(milliseconds: 100), () {
          try {
            if (isError) {
              Toast.e(message);
            } else {
              Toast.i(message);
            }
            debugPrint('🔗 ✅ Toast displayed: $message');
          } catch (e) {
            debugPrint('❌ Error displaying delayed toast: $e');
          }
        });
      } else {
        debugPrint('🔗 Toast skipped (app not ready): $message');
        debugPrint('🔗 Context available: ${Get.context != null}');
        debugPrint('🔗 App initialized: $_isAppInitialized');
      }
    } catch (e) {
      debugPrint('❌ Error showing toast: $e');
      // Don't throw, just log the error
    }
  }

  /// Show an error dialog
  static void _showErrorDialog(String title, String message) {
    // Add a delay to ensure context is available
    Future.delayed(const Duration(milliseconds: 200), () {
      final context = Get.context;
      if (context != null && _isAppInitialized) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(title)),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        debugPrint('🔗 ✅ Error dialog displayed: $title');
      } else {
        debugPrint('🔗 Error dialog skipped (app not ready): $title - $message');
        debugPrint('🔗 Context available: ${Get.context != null}');
        debugPrint('🔗 App initialized: $_isAppInitialized');
      }
    });
  }
}

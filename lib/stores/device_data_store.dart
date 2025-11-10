import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:logger/logger.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'dart:math';

class DeviceDataStore extends GetxService {
  // Storage keys
  static const _keyFCMToken = 'fcmToken';
  // static const _keyDeviceId = 'deviceId';
  // static const _keyDeviceName = 'deviceName';
  // static const _keyDeviceModel = 'deviceModel';
  // static const _keyDeviceBrand = 'deviceBrand';
  // static const _keyOSVersion = 'osVersion';
  // static const _keyPlatform = 'platform';
  // static const _keyAppVersion = 'appVersion';
  // static const _keyAppBuildNumber = 'appBuildNumber';
  // static const _keyScreenResolution = 'screenResolution';
  // static const _keyDeviceLanguage = 'deviceLanguage';
  // static const _keyDeviceCountry = 'deviceCountry';
  // static const _keyTimeZone = 'timeZone';
  // static const _keyIsPhysicalDevice = 'isPhysicalDevice';
  // static const _keyUserAgent = 'userAgent';
  // static const _keyInstallationId = 'installationId';
  // static const _keyFirstInstallTime = 'firstInstallTime';
  // static const _keyLastUpdateTime = 'lastUpdateTime';
  // static const _keyNetworkOperator = 'networkOperator';
  // static const _keyDeviceMemory = 'deviceMemory';
  // static const _keyStorageSpace = 'storageSpace';
  // static const _keyBatteryLevel = 'batteryLevel';
  // static const _keyDarkModeEnabled = 'darkModeEnabled';
  // static const _keyAccessibilityEnabled = 'accessibilityEnabled';
  // static const _keyRootedJailbroken = 'rootedJailbroken';
  // static const _keyAdvertisingId = 'advertisingId';
  // static const _keySessionId = 'sessionId';

  final GetStorage _storage = GetStorage();

  // Observable fields
  final RxString _fcmToken = ''.obs;
  // final RxString _deviceId = ''.obs;
  // final RxString _deviceName = ''.obs;
  // final RxString _deviceModel = ''.obs;
  // final RxString _deviceBrand = ''.obs;
  // final RxString _osVersion = ''.obs;
  // final RxString _platform = ''.obs;
  // final RxString _appVersion = ''.obs;
  // final RxString _appBuildNumber = ''.obs;
  // final RxString _screenResolution = ''.obs;
  // final RxString _deviceLanguage = ''.obs;
  // final RxString _deviceCountry = ''.obs;
  // final RxString _timeZone = ''.obs;
  // final RxBool _isPhysicalDevice = false.obs;
  // final RxString _userAgent = ''.obs;
  // final RxString _installationId = ''.obs;
  // final RxString _firstInstallTime = ''.obs;
  // final RxString _lastUpdateTime = ''.obs;
  // final RxString _networkOperator = ''.obs;
  // final RxString _deviceMemory = ''.obs;
  // final RxString _storageSpace = ''.obs;
  // final RxInt _batteryLevel = 0.obs;
  // final RxBool _darkModeEnabled = false.obs;
  // final RxBool _accessibilityEnabled = false.obs;
  // final RxBool _rootedJailbroken = false.obs;
  // final RxString _advertisingId = ''.obs;
  // final RxString _sessionId = ''.obs;

  Future<DeviceDataStore> init() async {
    await GetStorage.init();

    _fcmToken.value = _storage.read(_keyFCMToken) ?? '';
    ever(_fcmToken, (val) => _storage.write(_keyFCMToken, val));

    return this;
    // // Load stored values
    // _loadStoredValues();

    // // Set up auto-save listeners
    // _setupAutoSave();

    // // Collect fresh device data
    // await _collectDeviceData();

    // return this;
  }

  // void _loadStoredValues() {
  //   _fcmToken.value = _storage.read(_keyFCMToken) ?? '';
  //   _deviceId.value = _storage.read(_keyDeviceId) ?? '';
  //   _deviceName.value = _storage.read(_keyDeviceName) ?? '';
  //   _deviceModel.value = _storage.read(_keyDeviceModel) ?? '';
  //   _deviceBrand.value = _storage.read(_keyDeviceBrand) ?? '';
  //   _osVersion.value = _storage.read(_keyOSVersion) ?? '';
  //   _platform.value = _storage.read(_keyPlatform) ?? '';
  //   _appVersion.value = _storage.read(_keyAppVersion) ?? '';
  //   _appBuildNumber.value = _storage.read(_keyAppBuildNumber) ?? '';
  //   _screenResolution.value = _storage.read(_keyScreenResolution) ?? '';
  //   _deviceLanguage.value = _storage.read(_keyDeviceLanguage) ?? '';
  //   _deviceCountry.value = _storage.read(_keyDeviceCountry) ?? '';
  //   _timeZone.value = _storage.read(_keyTimeZone) ?? '';
  //   _isPhysicalDevice.value = _storage.read(_keyIsPhysicalDevice) ?? false;
  //   _userAgent.value = _storage.read(_keyUserAgent) ?? '';
  //   _installationId.value = _storage.read(_keyInstallationId) ?? '';
  //   _firstInstallTime.value = _storage.read(_keyFirstInstallTime) ?? '';
  //   _lastUpdateTime.value = _storage.read(_keyLastUpdateTime) ?? '';
  //   _networkOperator.value = _storage.read(_keyNetworkOperator) ?? '';
  //   _deviceMemory.value = _storage.read(_keyDeviceMemory) ?? '';
  //   _storageSpace.value = _storage.read(_keyStorageSpace) ?? '';
  //   _batteryLevel.value = _storage.read(_keyBatteryLevel) ?? 0;
  //   _darkModeEnabled.value = _storage.read(_keyDarkModeEnabled) ?? false;
  //   _accessibilityEnabled.value = _storage.read(_keyAccessibilityEnabled) ?? false;
  //   _rootedJailbroken.value = _storage.read(_keyRootedJailbroken) ?? false;
  //   _advertisingId.value = _storage.read(_keyAdvertisingId) ?? '';
  //   _sessionId.value = _storage.read(_keySessionId) ?? '';
  // }

  // void _setupAutoSave() {
  //   ever(_fcmToken, (val) => _storage.write(_keyFCMToken, val));
  //   ever(_deviceId, (val) => _storage.write(_keyDeviceId, val));
  //   ever(_deviceName, (val) => _storage.write(_keyDeviceName, val));
  //   ever(_deviceModel, (val) => _storage.write(_keyDeviceModel, val));
  //   ever(_deviceBrand, (val) => _storage.write(_keyDeviceBrand, val));
  //   ever(_osVersion, (val) => _storage.write(_keyOSVersion, val));
  //   ever(_platform, (val) => _storage.write(_keyPlatform, val));
  //   ever(_appVersion, (val) => _storage.write(_keyAppVersion, val));
  //   ever(_appBuildNumber, (val) => _storage.write(_keyAppBuildNumber, val));
  //   ever(_screenResolution, (val) => _storage.write(_keyScreenResolution, val));
  //   ever(_deviceLanguage, (val) => _storage.write(_keyDeviceLanguage, val));
  //   ever(_deviceCountry, (val) => _storage.write(_keyDeviceCountry, val));
  //   ever(_timeZone, (val) => _storage.write(_keyTimeZone, val));
  //   ever(_isPhysicalDevice, (val) => _storage.write(_keyIsPhysicalDevice, val));
  //   ever(_userAgent, (val) => _storage.write(_keyUserAgent, val));
  //   ever(_installationId, (val) => _storage.write(_keyInstallationId, val));
  //   ever(_firstInstallTime, (val) => _storage.write(_keyFirstInstallTime, val));
  //   ever(_lastUpdateTime, (val) => _storage.write(_keyLastUpdateTime, val));
  //   ever(_networkOperator, (val) => _storage.write(_keyNetworkOperator, val));
  //   ever(_deviceMemory, (val) => _storage.write(_keyDeviceMemory, val));
  //   ever(_storageSpace, (val) => _storage.write(_keyStorageSpace, val));
  //   ever(_batteryLevel, (val) => _storage.write(_keyBatteryLevel, val));
  //   ever(_darkModeEnabled, (val) => _storage.write(_keyDarkModeEnabled, val));
  //   ever(_accessibilityEnabled, (val) => _storage.write(_keyAccessibilityEnabled, val));
  //   ever(_rootedJailbroken, (val) => _storage.write(_keyRootedJailbroken, val));
  //   ever(_advertisingId, (val) => _storage.write(_keyAdvertisingId, val));
  //   ever(_sessionId, (val) => _storage.write(_keySessionId, val));
  // }

  // Future<void> _collectDeviceData() async {
  //   try {
  //     // Device info
  //     final deviceInfo = DeviceInfoPlugin();
  //     final packageInfo = await PackageInfo.fromPlatform();

  //     // App info
  //     _appVersion.value = packageInfo.version;
  //     _appBuildNumber.value = packageInfo.buildNumber;

  //     // Platform-specific data collection
  //     if (GetPlatform.isAndroid) {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       _deviceName.value = androidInfo.model;
  //       _deviceModel.value = androidInfo.model;
  //       _deviceBrand.value = androidInfo.brand;
  //       _osVersion.value = androidInfo.version.release;
  //       _platform.value = 'Android';
  //       _isPhysicalDevice.value = androidInfo.isPhysicalDevice;
  //     } else if (GetPlatform.isIOS) {
  //       final iosInfo = await deviceInfo.iosInfo;
  //       _deviceName.value = iosInfo.name;
  //       _deviceModel.value = iosInfo.model;
  //       _deviceBrand.value = 'Apple';
  //       _osVersion.value = iosInfo.systemVersion;
  //       _platform.value = 'iOS';
  //       _isPhysicalDevice.value = iosInfo.isPhysicalDevice;
  //     }

  //     // Generate installation ID if not exists
  //     if (_installationId.value.isEmpty) {
  //       _installationId.value = _generateInstallationId();
  //       _firstInstallTime.value = DateTime.now().toIso8601String();
  //     }

  //     // Update last update time
  //     _lastUpdateTime.value = DateTime.now().toIso8601String();

  //     // Generate new session ID
  //     _sessionId.value = _generateSessionId();
  //   } catch (e) {
  //     Logger().e('Error collecting device data: $e');
  //   }
  // }

  // String _generateInstallationId() {
  //   final random = Random();
  //   return DateTime.now().millisecondsSinceEpoch.toString() + (1000 + (999 * random.nextDouble())).toInt().toString();
  // }

  // String _generateSessionId() {
  //   final random = Random();
  //   return 'session_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  // }

  // Getters and Setters
  String get fcmToken => _fcmToken.value;
  set fcmToken(String val) => _fcmToken.value = val;

  // String get deviceId => _deviceId.value;
  // set deviceId(String val) => _deviceId.value = val;

  // String get deviceName => _deviceName.value;
  // set deviceName(String val) => _deviceName.value = val;

  // String get deviceModel => _deviceModel.value;
  // set deviceModel(String val) => _deviceModel.value = val;

  // String get deviceBrand => _deviceBrand.value;
  // set deviceBrand(String val) => _deviceBrand.value = val;

  // String get osVersion => _osVersion.value;
  // set osVersion(String val) => _osVersion.value = val;

  // String get platform => _platform.value;
  // set platform(String val) => _platform.value = val;

  // String get appVersion => _appVersion.value;
  // set appVersion(String val) => _appVersion.value = val;

  // String get appBuildNumber => _appBuildNumber.value;
  // set appBuildNumber(String val) => _appBuildNumber.value = val;

  // String get screenResolution => _screenResolution.value;
  // set screenResolution(String val) => _screenResolution.value = val;

  // String get deviceLanguage => _deviceLanguage.value;
  // set deviceLanguage(String val) => _deviceLanguage.value = val;

  // String get deviceCountry => _deviceCountry.value;
  // set deviceCountry(String val) => _deviceCountry.value = val;

  // String get timeZone => _timeZone.value;
  // set timeZone(String val) => _timeZone.value = val;

  // bool get isPhysicalDevice => _isPhysicalDevice.value;
  // set isPhysicalDevice(bool val) => _isPhysicalDevice.value = val;

  // String get userAgent => _userAgent.value;
  // set userAgent(String val) => _userAgent.value = val;

  // String get installationId => _installationId.value;
  // set installationId(String val) => _installationId.value = val;

  // String get firstInstallTime => _firstInstallTime.value;
  // set firstInstallTime(String val) => _firstInstallTime.value = val;

  // String get lastUpdateTime => _lastUpdateTime.value;
  // set lastUpdateTime(String val) => _lastUpdateTime.value = val;

  // String get networkOperator => _networkOperator.value;
  // set networkOperator(String val) => _networkOperator.value = val;

  // String get deviceMemory => _deviceMemory.value;
  // set deviceMemory(String val) => _deviceMemory.value = val;

  // String get storageSpace => _storageSpace.value;
  // set storageSpace(String val) => _storageSpace.value = val;

  // int get batteryLevel => _batteryLevel.value;
  // set batteryLevel(int val) => _batteryLevel.value = val;

  // bool get darkModeEnabled => _darkModeEnabled.value;
  // set darkModeEnabled(bool val) => _darkModeEnabled.value = val;

  // bool get accessibilityEnabled => _accessibilityEnabled.value;
  // set accessibilityEnabled(bool val) => _accessibilityEnabled.value = val;

  // bool get rootedJailbroken => _rootedJailbroken.value;
  // set rootedJailbroken(bool val) => _rootedJailbroken.value = val;

  // String get advertisingId => _advertisingId.value;
  // set advertisingId(String val) => _advertisingId.value = val;

  // String get sessionId => _sessionId.value;
  // set sessionId(String val) => _sessionId.value = val;

  // Utility methods
  Map<String, dynamic> toMap() {
    return {
      'fcmToken': fcmToken,
      // 'deviceId': deviceId,
      // 'deviceName': deviceName,
      // 'deviceModel': deviceModel,
      // 'deviceBrand': deviceBrand,
      // 'osVersion': osVersion,
      // 'platform': platform,
      // 'appVersion': appVersion,
      // 'appBuildNumber': appBuildNumber,
      // 'screenResolution': screenResolution,
      // 'deviceLanguage': deviceLanguage,
      // 'deviceCountry': deviceCountry,
      // 'timeZone': timeZone,
      // 'isPhysicalDevice': isPhysicalDevice,
      // 'userAgent': userAgent,
      // 'installationId': installationId,
      // 'firstInstallTime': firstInstallTime,
      // 'lastUpdateTime': lastUpdateTime,
      // 'networkOperator': networkOperator,
      // 'deviceMemory': deviceMemory,
      // 'storageSpace': storageSpace,
      // 'batteryLevel': batteryLevel,
      // 'darkModeEnabled': darkModeEnabled,
      // 'accessibilityEnabled': accessibilityEnabled,
      // 'rootedJailbroken': rootedJailbroken,
      // 'advertisingId': advertisingId,
      // 'sessionId': sessionId,
    };
  }

  void clearAllData() {
    _storage.erase();
  }
}

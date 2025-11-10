import 'dart:async';
import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';

import 'binding/main_binding.dart';
import 'controllers/locale/locale.dart';
import 'controllers/notification/notification.dart';
import 'controllers/theme/theme.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'services/deep_link_service.dart';
import 'services/fcm_service.dart';
import 'services/languages_service.dart';
import 'services/remote_config_service.dart';
import 'services/translation_service.dart';
import 'splash_screen.dart';
import 'stores/preferences_store.dart';
import 'stores/secure_store.dart';
import 'stores/user_data_store.dart';
import 'utils/loggers/custom_logger.dart';
import 'utils/theme/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late final T;
String tr(String key) => T.tr(key);

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e(
      details.exceptionAsString(),
      stackTrace: details.stack,
      error: details.exception,
    );
  };

  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) logger.d(message);
  };

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Remote Config with proper error handling
  var remoteConfigInitialized = await RemoteConfigService.init();
  if (!remoteConfigInitialized) {
    logger.w('Remote Config failed to initialize. Using default values.');
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    // await clearGetStorage();
    await GetStorage.init();
    await Get.putAsync<LanguagesService>(() => LanguagesService().init());

    await Get.putAsync<PreferencesStore>(() => PreferencesStore().init());
    await Get.putAsync<SecureStore>(() => SecureStore().init());

    await Get.putAsync<FCMService>(() => FCMService().init());
    await Get.putAsync<UserDataStore>(() => UserDataStore().init());

    // Initialize deep link service
    await DeepLinkService.init();

    debugPrint('SecureStore: ${Get.find<SecureStore>().authToken}');

    Get.put(LocaleController());
    Get.put(ThemeController());
    Get.put(NotificationController());

    await _setupInitialState();
    await initializeDateFormatting();

    await _forceDevSettings();

    T = await Get.putAsync<TranslationService>(() => TranslationService().init());

    // Don't mark app as initialized here - let the splash screen handle it
    // This ensures deep links are processed after UI is fully ready

    runApp(
      DevicePreview(
        enabled: false,
        builder: (_) => const MyApp(),
      ),
    );
  } catch (error) {
    debugPrint('App initialization failed: $error');
    runApp(const _ErrorApp());
  }
}

Future<void> clearGetStorage() async {
  await GetStorage().erase();
  debugPrint('GetStorage cleared');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize any listeners or services here
    // _initializeNotifications();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      // final loc = localeController.appLocale.value.toLanguageTag();
      // Intl.defaultLocale = loc;
      return ToastificationWrapper(
        child: GetMaterialApp(
          //   key: ValueKey(localeController.appLocale.value.languageCode),
          initialBinding: MainBinding(),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          locale: Locale(localeController.currentLanguage.locale ?? 'en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: Get.find<ThemeController>().currentTheme,
          home: const SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(0.85),
              ),
              child: child!,
            );
          },
        ),
      );
    });
  }
}

Future<void> _setupInitialState() async {
  final prefs = Get.find<PreferencesStore>();

  if (_isFirstLaunch(prefs)) {
    await _handleFirstLaunch(prefs);
  } else {
    await _restoreUserSettings(prefs);
  }
}

bool _isFirstLaunch(PreferencesStore prefs) {
  return prefs.isFirstTime;
}

Future<void> _handleFirstLaunch(PreferencesStore prefs) async {
  final platformBrightness = PlatformDispatcher.instance.platformBrightness;
  final deviceLocale = PlatformDispatcher.instance.locale;
  await _setupLocale(deviceLocale, prefs);
  await _setupTheme(platformBrightness, prefs);
  prefs.isFirstTime = false;
}

Future<void> _restoreUserSettings(PreferencesStore prefs) async {
  final savedLanguage = prefs.language;
  await Get.find<LocaleController>().setLocale(savedLanguage);
  Get.find<ThemeController>().currentTheme = prefs.currentTheme;
}

Future<void> _setupLocale(Locale deviceLocale, PreferencesStore prefs) async {
  final language = Get.find<LanguagesService>().languages.firstWhere(
        (language) => language.locale == deviceLocale.languageCode,
        orElse: () => Get.find<LanguagesService>().defaultLanguage,
      );
  await Get.find<LocaleController>().setLocale(language);
  prefs.language = language;
}

Future<void> _setupTheme(Brightness platformBrightness, PreferencesStore prefs) async {
  final themeMode = platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  prefs.currentTheme = themeMode;
  Get.find<ThemeController>().currentTheme = themeMode;
}

Future<void> _forceDevSettings() async {
  final prefs = Get.find<PreferencesStore>();
  final languagesService = Get.find<LanguagesService>();
  // Force Default language
  final defaultLocale = languagesService.defaultLanguage;
  await Get.find<LocaleController>().setLocale(defaultLocale);
  prefs.language = defaultLocale;

  prefs.currentTheme = ThemeMode.light;
  Get.find<ThemeController>().currentTheme = ThemeMode.light;

  // Mark as seen onboarding to avoid override
  prefs.seenOnboarding = true;
  logger.i('Development settings applied: ${defaultLocale.name} + Light Theme');
}

class _ErrorApp extends StatelessWidget {
  const _ErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize app',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart the application',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

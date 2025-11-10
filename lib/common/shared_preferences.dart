import 'package:get_storage/get_storage.dart';

class MyGetXStorage {
  static final _box = GetStorage();

  // Preferences keys
  static const String keyIsLogIn = 'key_isLogIn';
  static const String keyIsFirstTime = 'key_isFirstTime';
  static const String keyLanguage = 'key_language';
  static const String keyIsDarkMode = 'key_isDarkMode';
  static const String keyIsReceivingNotification =
      'key_isReceivingNotification';
  static const String keyRecentSearches = 'key_recentSearches';
  static const String keyTargetDate = 'key_targetDate';

  // User keys
  static const String keyId = 'key_id';
  static const String keyFirstName = 'key_firstName';
  static const String keyLastName = 'key_lastName';
  static const String keyGender = 'key_gender';
  static const String keyDateOfBirth = 'key_dateOfBirth';
  static const String keyEmail = 'key_email';
  static const String keyPhoneNumber = 'key_phoneNumber';
  static const String keyProfileImage = 'key_profileImage';

  static const String keyRole = 'key_role';
  static const String keyRoleName = 'key_roleName';
  static const String keyRoleId = 'key_roleId';

  static const String keyEmailVerifiedAt = 'key_emailVerifiedAt';
  static const String keyPhoneVerified = 'key_phoneVerified';
  static const String keyCountryId = 'key_countryId';
  static const String keyCityId = 'key_cityId';
  static const String keyAddress = 'key_address';
  static const String keyBusinessName = 'key_businessName';
  static const String keyCoverImage = 'key_coverImage';
  static const String keyFacebookUrl = 'key_facebookUrl';
  static const String keyInstagramUrl = 'key_instagramUrl';
  static const String keyWhatsAppUrl = 'key_whatsappUrl';
  static const String keyWebsiteUrl = 'key_websiteUrl';

  static Future<void> init() async => await GetStorage.init();

  static void clearProfile() {
    isLogIn = false;
    id = 0;
    firstName = '';
    lastName = '';
    email = '';
    phoneNumber = '';
    gender = '';
    role = '';
    targetDate = DateTime.now();
  }

  static bool get isFirstTime => _box.read(keyIsFirstTime) ?? true;
  static set isFirstTime(bool value) => _box.write(keyIsFirstTime, value);

  static String get language => _box.read(keyLanguage) ?? 'en';
  static set language(String value) => _box.write(keyLanguage, value);

  static bool get isReceivingNotification =>
      _box.read(keyIsReceivingNotification) ?? true;
  static set isReceivingNotification(bool value) =>
      _box.write(keyIsReceivingNotification, value);

  static bool get isDarkMode => _box.read(keyIsDarkMode) ?? false;
  static set isDarkMode(bool value) => _box.write(keyIsDarkMode, value);

  static bool get isLogIn => _box.read(keyIsLogIn) ?? false;
  static set isLogIn(bool value) => _box.write(keyIsLogIn, value);

  static List<String> get recentSearches =>
      List<String>.from(_box.read(keyRecentSearches) ?? []);
  static set recentSearches(List<String> value) =>
      _box.write(keyRecentSearches, value);

  static void addRecentSearch(String value) {
    final searches = recentSearches;
    if (!searches.contains(value)) {
      searches.add(value);
      recentSearches = searches;
    }
  }

  static void removeRecentSearch(String value) {
    final searches = recentSearches;
    searches.remove(value);
    recentSearches = searches;
  }

  static void clearRecentSearches() => _box.remove(keyRecentSearches);

  static int get id => _box.read(keyId) ?? 0;
  static set id(int value) => _box.write(keyId, value);

  static String get firstName => _box.read(keyFirstName) ?? '';
  static set firstName(String value) => _box.write(keyFirstName, value);

  static String get lastName => _box.read(keyLastName) ?? '';
  static set lastName(String value) => _box.write(keyLastName, value);

  static String get dateOfBirth => _box.read(keyDateOfBirth) ?? '';
  static set dateOfBirth(String value) => _box.write(keyDateOfBirth, value);

  static String get email => _box.read(keyEmail) ?? '';
  static set email(String value) => _box.write(keyEmail, value);

  static String get phoneNumber => _box.read(keyPhoneNumber) ?? '';
  static set phoneNumber(String value) => _box.write(keyPhoneNumber, value);

  static String get gender => _box.read(keyGender) ?? '';
  static set gender(String value) => _box.write(keyGender, value);

  static String get role => _box.read(keyRole) ?? '';
  static set role(String value) => _box.write(keyRole, value);

  static void clear() => _box.erase();

  static DateTime get targetDate {
    final targetDateString = _box.read(keyTargetDate);
    if (targetDateString == null) return DateTime.now();
    return DateTime.parse(targetDateString);
  }

  static set targetDate(DateTime value) =>
      _box.write(keyTargetDate, value.toIso8601String());

  static Future<void> setTargetDate(DateTime? date) async {
    await _box.write(keyTargetDate, date!.toIso8601String());
  }

  static DateTime? getTargetDate() {
    final dateString = _box.read(keyTargetDate);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static String get profileImage => _box.read(keyProfileImage) ?? '';
  static set profileImage(String value) => _box.write(keyProfileImage, value);

  static String get roleName => _box.read(keyRoleName) ?? '';
  static set roleName(String value) => _box.write(keyRoleName, value);

  static int get roleId => _box.read(keyRoleId) ?? 0;
  static set roleId(int value) => _box.write(keyRoleId, value);

  static String get emailVerifiedAt => _box.read(keyEmailVerifiedAt) ?? '';
  static set emailVerifiedAt(String value) =>
      _box.write(keyEmailVerifiedAt, value);

  static bool get phoneVerified => _box.read(keyPhoneVerified) ?? false;
  static set phoneVerified(bool value) => _box.write(keyPhoneVerified, value);

  static String get countryId => _box.read(keyCountryId) ?? '';
  static set countryId(String value) => _box.write(keyCountryId, value);

  static String get cityId => _box.read(keyCityId) ?? '';
  static set cityId(String value) => _box.write(keyCityId, value);

  static String get address => _box.read(keyAddress) ?? '';
  static set address(String value) => _box.write(keyAddress, value);

  static String get businessName => _box.read(keyBusinessName) ?? '';
  static set businessName(String value) => _box.write(keyBusinessName, value);

  static String get coverImage => _box.read(keyCoverImage) ?? '';
  static set coverImage(String value) => _box.write(keyCoverImage, value);

  static String get facebookUrl => _box.read(keyFacebookUrl) ?? '';
  static set facebookUrl(String value) => _box.write(keyFacebookUrl, value);

  static String get instagramUrl => _box.read(keyInstagramUrl) ?? '';
  static set instagramUrl(String value) => _box.write(keyInstagramUrl, value);

  static String get whatsappUrl => _box.read(keyWhatsAppUrl) ?? '';
  static set whatsappUrl(String value) => _box.write(keyWhatsAppUrl, value);

  static String get websiteUrl => _box.read(keyWebsiteUrl) ?? '';
  static set websiteUrl(String value) => _box.write(keyWebsiteUrl, value);
}

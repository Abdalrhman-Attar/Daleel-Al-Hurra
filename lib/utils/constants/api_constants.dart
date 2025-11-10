import '../../services/remote_config_service.dart';

class ApiConstants {
  static String baseUrl = RemoteConfigService.baseUrl;

  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String socialLogin = '$auth/social-login';
  static const String verifyOtp = '$auth/verify-otp';

  static const String logout = '$auth/logout';
  static const String info = '$auth/info';
  static const String updateProfile = '$auth/update-profile';
  static const String requestReset = '$auth/request-reset';
  static const String resetPassword = '$auth/reset-password';
  static const String checkVerificationStatus = '$auth/check-verification-status';
  static const String changePassword = '$auth/change-password';
  static const String deleteAccount = '$auth/delete-account';

  static const String cars = '/cars';
  static const String carBrands = '$cars/brands';
  static const String carBodyTypes = '$cars/body-types';
  static const String carCategories = '$cars/categories';
  static const String carColors = '$cars/colors';
  static const String carDealers = '$cars/vendors';
  static const String carBrandModels = '$cars/brand-models';
  static const String carFeatures = '$cars/features';

  static const String general = '/general';
  static const String contactUs = '$general/contact-us';
  static const String languages = '$general/languages';
  static const String settings = '$general/settings';
  static const String pages = '$general/pages';
  static const String partners = '$general/partners';
  static const String sliderItems = '$general/slider-apps';
  static const String translations = '$general/translations';

  static const String dealers = '/vendors';
  static const String dealerCars = '$dealers/cars';
  static const String updateCarStatus = '$dealers/cars/{carId}/status';
  static const String dealerBrands = '$dealers/brands';
  static const String addDealerBrand = '$dealers/brands/attach';
  static const String removeDealerBrand = '$dealers/brands/detach';
}

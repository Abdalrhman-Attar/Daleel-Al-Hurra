import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme/theme.dart';

class MyColors {
  MyColors._();

  static final ThemeController _themeController = Get.find<ThemeController>();

  static bool get _isDarkMode =>
      _themeController.currentTheme == ThemeMode.dark;

  static const Color _primaryLight = Color(0xFFfebd59);
  static const Color _secondaryLight = Color(0xFFada985);
  static const Color _accentLight = Color(0xFFFF9F0A);

  static const Color _textPrimaryLight = Color(0xFF1D1D1F);
  static const Color _textSecondaryLight = Color(0xFF8A8A8E);
  static const Color _textDisabledLight = Color(0xFFC6C6C8);
  static const Color _textOnPrimaryLight = Color(0xFFFFFFFF);
  static const Color _textOnAccentLight = Color(0xFFFFFFFF);
  static const Color _textLinkLight = Color(0xFF0A7AFF);

  static const Color _backgroundLight = Color(0xFFFFFFFF);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _scaffoldBackgroundLight = Color(0xFFFFFFFF);

  static const Color _containerLight = Color(0xFFFFFFFF);
  static const Color _cardBackgroundLight = Color(0xFFf5f5f5);
  static const Color _inputBackgroundLight = Color(0xFFE9E9EB);
  static const Color _appBarBackgroundLight = Color(0xFFF9F9F9);

  static const Color _buttonSecondaryBackgroundLight = Color(0xFFE9E9EB);
  static const Color _buttonDisabledBackgroundLight = Color(0xFFE0E0E0);

  static const Color _borderLight = Color(0xFFD1D1D6);
  static const Color _dividerLight = Color(0xFFE5E5EA);

  static const Color _successLight = Color(0xFF34C759);
  static const Color _warningLight = Color(0xFFFF9500);
  static const Color _errorLight = Color(0xFFFF3B30);
  static const Color _infoLight = Color(0xFF007AFF);

  static const Color _soldTagBackgroundLight = Color(0xFF8A8A8E);
  static const Color _soldTagTextLight = Color(0xFFFFFFFF);

  static const Color _priceTextLight = Color(0xFF1D1D1F);

  static const Color _iconPrimaryLight = Color(0xFF636366);
  static const Color _iconSecondaryLight = Color(0xFF8A8A8E);
  static const Color _iconOnPrimaryLight = Color(0xFFFFFFFF);

  static const Color _navBarBackgroundLight = Color(0xFFF9F9F9);
  static const Color _navBarUnselectedItemLight = Color(0xFF8A8A8E);

  static const Color _shadowLight = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color _ratingStarLight = Color(0xFFFFCC00);

  static const Color _primaryDark = Color(0xFFfebd59);
  static const Color _secondaryDark = Color(0xFF5E5CE6);
  static const Color _accentDark = Color(0xFFFFB00A);

  static const Color _textPrimaryDark = Color(0xFFFFFFFF);
  static const Color _textSecondaryDark = Color(0xFF8D8D93);
  static const Color _textDisabledDark = Color(0xFF545458);
  static const Color _textOnPrimaryDark = Color(0xFFFFFFFF);
  static const Color _textOnAccentDark = Color(0xFF000000);
  static const Color _textLinkDark = Color(0xFF0A84FF);

  static const Color _backgroundDark = Color(0xFF000000);
  static const Color _surfaceDark = Color(0xFF1C1C1E);
  static const Color _scaffoldBackgroundDark = Color(0xFF000000);

  static const Color _containerDark = Color(0xFF1C1C1E);
  static const Color _cardBackgroundDark = Color(0xFF1C1C1E);
  static const Color _inputBackgroundDark = Color(0xFF2C2C2E);
  static const Color _appBarBackgroundDark = Color(0xFF1A1A1A);

  static const Color _buttonSecondaryBackgroundDark = Color(0xFF2C2C2E);
  static const Color _buttonDisabledBackgroundDark = Color(0xFF2C2C2E);

  static const Color _borderDark = Color(0xFF38383A);
  static const Color _dividerDark = Color(0xFF2D2D2F);

  static const Color _successDark = Color(0xFF30D158);
  static const Color _warningDark = Color(0xFFFF9F0A);
  static const Color _errorDark = Color(0xFFFF453A);
  static const Color _infoDark = Color(0xFF0A84FF);

  static const Color _newTagTextDark = Color(0xFF000000);
  static const Color _usedTagTextDark = Color(0xFF000000);
  static const Color _soldTagBackgroundDark = Color(0xFF545458);
  static const Color _soldTagTextDark = Color(0xFFE0E0E0);

  static const Color _priceTextDark = Color(0xFFFFFFFF);

  static const Color _iconPrimaryDark = Color(0xFFE0E0E0);
  static const Color _iconSecondaryDark = Color(0xFF8D8D93);
  static const Color _iconOnPrimaryDark = Color(0xFFFFFFFF);

  static const Color _navBarBackgroundDark = Color(0xFF1A1A1A);
  static const Color _navBarUnselectedItemDark = Color(0xFF8D8D93);

  static const Color _shadowDark = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color _ratingStarDark = Color(0xFFFFD60A);

  static const Color _grey50Light = Color(0xFFF9FAFB);
  static const Color _grey100Light = Color(0xFFF3F4F6);
  static const Color _grey200Light = Color(0xFFE5E7EB);
  static const Color _grey300Light = Color(0xFFD1D5DB);
  static const Color _grey400Light = Color(0xFF9CA3AF);
  static const Color _grey500Light = Color(0xFF6B7280);
  static const Color _grey600Light = Color(0xFF4B5563);
  static const Color _grey700Light = Color(0xFF374151);
  static const Color _grey800Light = Color(0xFF1F2937);
  static const Color _grey900Light = Color(0xFF111827);

  static const Color _grey50Dark = Color(0xFF111827);
  static const Color _grey100Dark = Color(0xFF1F2937);
  static const Color _grey200Dark = Color(0xFF374151);
  static const Color _grey300Dark = Color(0xFF4B5563);
  static const Color _grey400Dark = Color(0xFF6B7280);
  static const Color _grey500Dark = Color(0xFF9CA3AF);
  static const Color _grey600Dark = Color(0xFFD1D5DB);
  static const Color _grey700Dark = Color(0xFFE5E7EB);
  static const Color _grey800Dark = Color(0xFFF3F4F6);
  static const Color _grey900Dark = Color(0xFFF9FAFB);

  static const Color _shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color _shimmerHighlightLight = Color(0xFFF5F5F5);
  static const Color _shimmerBaseDark = Color(0xFF2C2C2E);
  static const Color _shimmerHighlightDark = Color(0xFF38383A);

  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFB0B0B0);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static Color get primaryLight => _primaryLight;
  static Color get primaryDark => _primaryDark;
  static Color get secondaryLight => _secondaryLight;
  static Color get secondaryDark => _secondaryDark;
  static Color get accentLight => _accentLight;
  static Color get accentDark => _accentDark;
  static Color get textPrimaryLight => _textPrimaryLight;
  static Color get textPrimaryDark => _textPrimaryDark;
  static Color get textSecondaryLight => _textSecondaryLight;
  static Color get textSecondaryDark => _textSecondaryDark;
  static Color get textDisabledLight => _textDisabledLight;
  static Color get textDisabledDark => _textDisabledDark;
  static Color get textOnPrimaryLight => _textOnPrimaryLight;
  static Color get textOnPrimaryDark => _textOnPrimaryDark;
  static Color get textOnAccentLight => _textOnAccentLight;
  static Color get textOnAccentDark => _textOnAccentDark;
  static Color get textLinkLight => _textLinkLight;
  static Color get textLinkDark => _textLinkDark;
  static Color get backgroundLight => _backgroundLight;
  static Color get backgroundDark => _backgroundDark;
  static Color get surfaceLight => _surfaceLight;
  static Color get surfaceDark => _surfaceDark;
  static Color get scaffoldBackgroundLight => _scaffoldBackgroundLight;
  static Color get scaffoldBackgroundDark => _scaffoldBackgroundDark;
  static Color get containerLight => _containerLight;
  static Color get containerDark => _containerDark;
  static Color get cardBackgroundLight => _cardBackgroundLight;
  static Color get cardBackgroundDark => _cardBackgroundDark;
  static Color get inputBackgroundLight => _inputBackgroundLight;
  static Color get inputBackgroundDark => _inputBackgroundDark;
  static Color get appBarBackgroundLight => _appBarBackgroundLight;
  static Color get appBarBackgroundDark => _appBarBackgroundDark;
  static Color get buttonSecondaryBackgroundLight =>
      _buttonSecondaryBackgroundLight;
  static Color get buttonSecondaryBackgroundDark =>
      _buttonSecondaryBackgroundDark;
  static Color get buttonDisabledBackgroundLight =>
      _buttonDisabledBackgroundLight;
  static Color get buttonDisabledBackgroundDark =>
      _buttonDisabledBackgroundDark;
  static Color get borderLight => _borderLight;
  static Color get borderDark => _borderDark;
  static Color get dividerLight => _dividerLight;
  static Color get dividerDark => _dividerDark;
  static Color get successLight => _successLight;
  static Color get successDark => _successDark;
  static Color get warningLight => _warningLight;
  static Color get warningDark => _warningDark;
  static Color get errorLight => _errorLight;
  static Color get errorDark => _errorDark;
  static Color get infoLight => _infoLight;
  static Color get infoDark => _infoDark;
  static Color get newTagTextDark => _newTagTextDark;
  static Color get usedTagTextDark => _usedTagTextDark;
  static Color get soldTagBackgroundLight => _soldTagBackgroundLight;
  static Color get soldTagBackgroundDark => _soldTagBackgroundDark;
  static Color get soldTagTextLight => _soldTagTextLight;
  static Color get soldTagTextDark => _soldTagTextDark;
  static Color get priceTextLight => _priceTextLight;
  static Color get priceTextDark => _priceTextDark;
  static Color get iconPrimaryLight => _iconPrimaryLight;
  static Color get iconPrimaryDark => _iconPrimaryDark;
  static Color get iconSecondaryLight => _iconSecondaryLight;

  static Color get iconSecondaryDark => _iconSecondaryDark;
  static Color get iconOnPrimaryLight => _iconOnPrimaryLight;
  static Color get iconOnPrimaryDark => _iconOnPrimaryDark;
  static Color get navBarBackgroundLight => _navBarBackgroundLight;
  static Color get navBarBackgroundDark => _navBarBackgroundDark;
  static Color get navBarUnselectedItemLight => _navBarUnselectedItemLight;
  static Color get navBarUnselectedItemDark => _navBarUnselectedItemDark;
  static Color get shadowLight => _shadowLight;
  static Color get shadowDark => _shadowDark;
  static Color get ratingStarLight => _ratingStarLight;
  static Color get ratingStarDark => _ratingStarDark;
  static Color get grey50Light => _grey50Light;
  static Color get grey50Dark => _grey50Dark;
  static Color get grey100Light => _grey100Light;
  static Color get grey100Dark => _grey100Dark;
  static Color get grey200Light => _grey200Light;
  static Color get grey200Dark => _grey200Dark;
  static Color get grey300Light => _grey300Light;
  static Color get grey300Dark => _grey300Dark;
  static Color get grey400Light => _grey400Light;
  static Color get grey400Dark => _grey400Dark;
  static Color get grey500Light => _grey500Light;
  static Color get grey500Dark => _grey500Dark;
  static Color get grey600Light => _grey600Light;
  static Color get grey600Dark => _grey600Dark;
  static Color get grey700Light => _grey700Light;
  static Color get grey700Dark => _grey700Dark;
  static Color get grey800Light => _grey800Light;

  static Color get grey800Dark => _grey800Dark;
  static Color get grey900Light => _grey900Light;
  static Color get grey900Dark => _grey900Dark;
  static Color get shimmerBaseLight => _shimmerBaseLight;
  static Color get shimmerBaseDark => _shimmerBaseDark;
  static Color get shimmerHighlightLight => _shimmerHighlightLight;
  static Color get shimmerHighlightDark => _shimmerHighlightDark;
  static Color get shimmerContainerBackgroundLight => _grey100Light;
  static Color get shimmerContainerBackgroundDark => _grey100Dark;
  static Color get shimmerBaseColorLight => _shimmerBaseLight;
  static Color get shimmerBaseColorDark => _shimmerBaseDark;
  static Color get shimmerHighlightColorLight => _shimmerHighlightLight;
  static Color get shimmerHighlightColorDark => _shimmerHighlightDark;
  static Color get shimmerBaseColor =>
      _isDarkMode ? _shimmerBaseDark : _shimmerBaseLight;
  static Color get shimmerHighlightColor =>
      _isDarkMode ? _shimmerHighlightDark : _shimmerHighlightLight;

  static Color get primary => _isDarkMode ? _primaryDark : _primaryLight;
  static Color get secondary => _isDarkMode ? _secondaryDark : _secondaryLight;
  static Color get accent => _isDarkMode ? _accentDark : _accentLight;

  static Color get textPrimary =>
      _isDarkMode ? _textPrimaryDark : _textPrimaryLight;
  static Color get textSecondary =>
      _isDarkMode ? _textSecondaryDark : _textSecondaryLight;
  static Color get textDisabled =>
      _isDarkMode ? _textDisabledDark : _textDisabledLight;
  static Color get textOnPrimary =>
      _isDarkMode ? _textOnPrimaryDark : _textOnPrimaryLight;
  static Color get textOnAccent =>
      _isDarkMode ? _textOnAccentDark : _textOnAccentLight;
  static Color get textLink => _isDarkMode ? _textLinkDark : _textLinkLight;

  static Color get background =>
      _isDarkMode ? _backgroundDark : _backgroundLight;
  static Color get surface => _isDarkMode ? _surfaceDark : _surfaceLight;
  static Color get scaffoldBackground =>
      _isDarkMode ? _scaffoldBackgroundDark : _scaffoldBackgroundLight;

  static Color get container => _isDarkMode ? _containerDark : _containerLight;
  static Color get cardBackground =>
      _isDarkMode ? _cardBackgroundDark : _cardBackgroundLight;
  static Color get inputBackground =>
      _isDarkMode ? _inputBackgroundDark : _inputBackgroundLight;
  static Color get appBarBackground =>
      _isDarkMode ? _appBarBackgroundDark : _appBarBackgroundLight;

  static Color get buttonPrimaryBackground => primary;
  static Color get buttonPrimaryText => textOnPrimary;
  static Color get buttonSecondaryBackground => _isDarkMode
      ? _buttonSecondaryBackgroundDark
      : _buttonSecondaryBackgroundLight;
  static Color get buttonSecondaryText => textPrimary;
  static Color get buttonDisabledBackground => _isDarkMode
      ? _buttonDisabledBackgroundDark
      : _buttonDisabledBackgroundLight;
  static Color get buttonDisabledText => textDisabled;

  static Color get border => _isDarkMode ? _borderDark : _borderLight;
  static Color get divider => _isDarkMode ? _dividerDark : _dividerLight;

  static Color get success => _isDarkMode ? _successDark : _successLight;
  static Color get warning => _isDarkMode ? _warningDark : _warningLight;
  static Color get error => _isDarkMode ? _errorDark : _errorLight;
  static Color get info => _isDarkMode ? _infoDark : _infoLight;

  static Color get newTagBackground => success;
  static Color get newTagText => _isDarkMode ? _newTagTextDark : white;
  static Color get usedTagBackground => warning;
  static Color get usedTagText => _isDarkMode ? _usedTagTextDark : white;
  static Color get featuredTagBackground => accent;
  static Color get featuredTagText => textOnAccent;
  static Color get soldTagBackground =>
      _isDarkMode ? _soldTagBackgroundDark : _soldTagBackgroundLight;
  static Color get soldTagText =>
      _isDarkMode ? _soldTagTextDark : _soldTagTextLight;

  static Color get availableStatus => success;
  static Color get pendingStatus => warning;
  static Color get inspectionStatus => info;

  static Color get priceText => _isDarkMode ? _priceTextDark : _priceTextLight;
  static Color get discountedPriceText => error;

  static Color get iconPrimary =>
      _isDarkMode ? _iconPrimaryDark : _iconPrimaryLight;
  static Color get iconSecondary =>
      _isDarkMode ? _iconSecondaryDark : _iconSecondaryLight;
  static Color get iconOnPrimary =>
      _isDarkMode ? _iconOnPrimaryDark : _iconOnPrimaryLight;

  static Color get navBarBackground =>
      _isDarkMode ? _navBarBackgroundDark : _navBarBackgroundLight;
  static Color get navBarSelectedItem => primary;
  static Color get navBarUnselectedItem =>
      _isDarkMode ? _navBarUnselectedItemDark : _navBarUnselectedItemLight;

  static Color get shadow => _isDarkMode ? _shadowDark : _shadowLight;
  static Color get ratingStar =>
      _isDarkMode ? _ratingStarDark : _ratingStarLight;

  static Color get grey50 => _isDarkMode ? _grey50Dark : _grey50Light;
  static Color get grey100 => _isDarkMode ? _grey100Dark : _grey100Light;
  static Color get grey200 => _isDarkMode ? _grey200Dark : _grey200Light;
  static Color get grey300 => _isDarkMode ? _grey300Dark : _grey300Light;
  static Color get grey400 => _isDarkMode ? _grey400Dark : _grey400Light;
  static Color get grey500 => _isDarkMode ? _grey500Dark : _grey500Light;
  static Color get grey600 => _isDarkMode ? _grey600Dark : _grey600Light;
  static Color get grey700 => _isDarkMode ? _grey700Dark : _grey700Light;
  static Color get grey800 => _isDarkMode ? _grey800Dark : _grey800Light;
  static Color get grey900 => _isDarkMode ? _grey900Dark : _grey900Light;

  static Color get shimmerBase =>
      _isDarkMode ? _shimmerBaseDark : _shimmerBaseLight;
  static Color get shimmerHighlight =>
      _isDarkMode ? _shimmerHighlightDark : _shimmerHighlightLight;

  static Color get shimmerContainerBackground =>
      _isDarkMode ? _grey100Dark : white;
}

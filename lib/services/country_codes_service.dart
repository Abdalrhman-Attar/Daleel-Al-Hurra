import '../model/general/country_code/country_code.dart';

class CountryCodesService {
  static final List<CountryCode> _countryCodes = [
    const CountryCode(
        name: 'Jordan', code: 'JO', flag: '🇯🇴', dialCode: '+962'),
    const CountryCode(
        name: 'United States', code: 'US', flag: '🇺🇸', dialCode: '+1'),
    const CountryCode(
        name: 'United Kingdom', code: 'GB', flag: '🇬🇧', dialCode: '+44'),
    const CountryCode(
        name: 'Saudi Arabia', code: 'SA', flag: '🇸🇦', dialCode: '+966'),
    const CountryCode(
        name: 'United Arab Emirates',
        code: 'AE',
        flag: '🇦🇪',
        dialCode: '+971'),
    const CountryCode(
        name: 'Kuwait', code: 'KW', flag: '🇰🇼', dialCode: '+965'),
    const CountryCode(
        name: 'Qatar', code: 'QA', flag: '🇶🇦', dialCode: '+974'),
    const CountryCode(
        name: 'Bahrain', code: 'BH', flag: '🇧🇭', dialCode: '+973'),
    const CountryCode(name: 'Oman', code: 'OM', flag: '🇴🇲', dialCode: '+968'),
    const CountryCode(name: 'Egypt', code: 'EG', flag: '🇪🇬', dialCode: '+20'),
    const CountryCode(
        name: 'Lebanon', code: 'LB', flag: '🇱🇧', dialCode: '+961'),
    const CountryCode(
        name: 'Syria', code: 'SY', flag: '🇸🇾', dialCode: '+963'),
    const CountryCode(name: 'Iraq', code: 'IQ', flag: '🇮🇶', dialCode: '+964'),
    const CountryCode(
        name: 'Palestine', code: 'PS', flag: '🇵🇸', dialCode: '+970'),
    const CountryCode(
        name: 'Yemen', code: 'YE', flag: '🇾🇪', dialCode: '+967'),
    const CountryCode(
        name: 'Libya', code: 'LY', flag: '🇱🇾', dialCode: '+218'),
    const CountryCode(
        name: 'Tunisia', code: 'TN', flag: '🇹🇳', dialCode: '+216'),
    const CountryCode(
        name: 'Algeria', code: 'DZ', flag: '🇩🇿', dialCode: '+213'),
    const CountryCode(
        name: 'Morocco', code: 'MA', flag: '🇲🇦', dialCode: '+212'),
    const CountryCode(
        name: 'Sudan', code: 'SD', flag: '🇸🇩', dialCode: '+249'),
    const CountryCode(
        name: 'Turkey', code: 'TR', flag: '🇹🇷', dialCode: '+90'),
    const CountryCode(name: 'Iran', code: 'IR', flag: '🇮🇷', dialCode: '+98'),
    const CountryCode(
        name: 'Pakistan', code: 'PK', flag: '🇵🇰', dialCode: '+92'),
    const CountryCode(
        name: 'Afghanistan', code: 'AF', flag: '🇦🇫', dialCode: '+93'),
    const CountryCode(name: 'India', code: 'IN', flag: '🇮🇳', dialCode: '+91'),
    const CountryCode(
        name: 'Bangladesh', code: 'BD', flag: '🇧🇩', dialCode: '+880'),
    const CountryCode(
        name: 'Sri Lanka', code: 'LK', flag: '🇱🇰', dialCode: '+94'),
    const CountryCode(
        name: 'Nepal', code: 'NP', flag: '🇳🇵', dialCode: '+977'),
    const CountryCode(
        name: 'Myanmar', code: 'MM', flag: '🇲🇲', dialCode: '+95'),
    const CountryCode(
        name: 'Thailand', code: 'TH', flag: '🇹🇭', dialCode: '+66'),
    const CountryCode(
        name: 'Vietnam', code: 'VN', flag: '🇻🇳', dialCode: '+84'),
    const CountryCode(
        name: 'Cambodia', code: 'KH', flag: '🇰🇭', dialCode: '+855'),
    const CountryCode(name: 'Laos', code: 'LA', flag: '🇱🇦', dialCode: '+856'),
    const CountryCode(
        name: 'Malaysia', code: 'MY', flag: '🇲🇾', dialCode: '+60'),
    const CountryCode(
        name: 'Singapore', code: 'SG', flag: '🇸🇬', dialCode: '+65'),
    const CountryCode(
        name: 'Indonesia', code: 'ID', flag: '🇮🇩', dialCode: '+62'),
    const CountryCode(
        name: 'Philippines', code: 'PH', flag: '🇵🇭', dialCode: '+63'),
    const CountryCode(name: 'China', code: 'CN', flag: '🇨🇳', dialCode: '+86'),
    const CountryCode(name: 'Japan', code: 'JP', flag: '🇯🇵', dialCode: '+81'),
    const CountryCode(
        name: 'South Korea', code: 'KR', flag: '🇰🇷', dialCode: '+82'),
    const CountryCode(
        name: 'North Korea', code: 'KP', flag: '🇰🇵', dialCode: '+850'),
    const CountryCode(
        name: 'Mongolia', code: 'MN', flag: '🇲🇳', dialCode: '+976'),
    const CountryCode(
        name: 'Taiwan', code: 'TW', flag: '🇹🇼', dialCode: '+886'),
    const CountryCode(
        name: 'Hong Kong', code: 'HK', flag: '🇭🇰', dialCode: '+852'),
    const CountryCode(
        name: 'Macau', code: 'MO', flag: '🇲🇴', dialCode: '+853'),
    const CountryCode(name: 'Canada', code: 'CA', flag: '🇨🇦', dialCode: '+1'),
    const CountryCode(
        name: 'Mexico', code: 'MX', flag: '🇲🇽', dialCode: '+52'),
    const CountryCode(
        name: 'Brazil', code: 'BR', flag: '🇧🇷', dialCode: '+55'),
    const CountryCode(
        name: 'Argentina', code: 'AR', flag: '🇦🇷', dialCode: '+54'),
    const CountryCode(name: 'Chile', code: 'CL', flag: '🇨🇱', dialCode: '+56'),
    const CountryCode(name: 'Peru', code: 'PE', flag: '🇵🇪', dialCode: '+51'),
    const CountryCode(
        name: 'Colombia', code: 'CO', flag: '🇨🇴', dialCode: '+57'),
    const CountryCode(
        name: 'Venezuela', code: 'VE', flag: '🇻🇪', dialCode: '+58'),
    const CountryCode(
        name: 'Ecuador', code: 'EC', flag: '🇪🇨', dialCode: '+593'),
    const CountryCode(
        name: 'Bolivia', code: 'BO', flag: '🇧🇴', dialCode: '+591'),
    const CountryCode(
        name: 'Paraguay', code: 'PY', flag: '🇵🇾', dialCode: '+595'),
    const CountryCode(
        name: 'Uruguay', code: 'UY', flag: '🇺🇾', dialCode: '+598'),
    const CountryCode(
        name: 'Guyana', code: 'GY', flag: '🇬🇾', dialCode: '+592'),
    const CountryCode(
        name: 'Suriname', code: 'SR', flag: '🇸🇷', dialCode: '+597'),
    const CountryCode(
        name: 'French Guiana', code: 'GF', flag: '🇬🇫', dialCode: '+594'),
    const CountryCode(
        name: 'Germany', code: 'DE', flag: '🇩🇪', dialCode: '+49'),
    const CountryCode(
        name: 'France', code: 'FR', flag: '🇫🇷', dialCode: '+33'),
    const CountryCode(name: 'Italy', code: 'IT', flag: '🇮🇹', dialCode: '+39'),
    const CountryCode(name: 'Spain', code: 'ES', flag: '🇪🇸', dialCode: '+34'),
    const CountryCode(
        name: 'Portugal', code: 'PT', flag: '🇵🇹', dialCode: '+351'),
    const CountryCode(
        name: 'Netherlands', code: 'NL', flag: '🇳🇱', dialCode: '+31'),
    const CountryCode(
        name: 'Belgium', code: 'BE', flag: '🇧🇪', dialCode: '+32'),
    const CountryCode(
        name: 'Switzerland', code: 'CH', flag: '🇨🇭', dialCode: '+41'),
    const CountryCode(
        name: 'Austria', code: 'AT', flag: '🇦🇹', dialCode: '+43'),
    const CountryCode(
        name: 'Sweden', code: 'SE', flag: '🇸🇪', dialCode: '+46'),
    const CountryCode(
        name: 'Norway', code: 'NO', flag: '🇳🇴', dialCode: '+47'),
    const CountryCode(
        name: 'Denmark', code: 'DK', flag: '🇩🇰', dialCode: '+45'),
    const CountryCode(
        name: 'Finland', code: 'FI', flag: '🇫🇮', dialCode: '+358'),
    const CountryCode(
        name: 'Iceland', code: 'IS', flag: '🇮🇸', dialCode: '+354'),
    const CountryCode(
        name: 'Poland', code: 'PL', flag: '🇵🇱', dialCode: '+48'),
    const CountryCode(
        name: 'Czech Republic', code: 'CZ', flag: '🇨🇿', dialCode: '+420'),
    const CountryCode(
        name: 'Slovakia', code: 'SK', flag: '🇸🇰', dialCode: '+421'),
    const CountryCode(
        name: 'Hungary', code: 'HU', flag: '🇭🇺', dialCode: '+36'),
    const CountryCode(
        name: 'Romania', code: 'RO', flag: '🇷🇴', dialCode: '+40'),
    const CountryCode(
        name: 'Bulgaria', code: 'BG', flag: '🇧🇬', dialCode: '+359'),
    const CountryCode(
        name: 'Croatia', code: 'HR', flag: '🇭🇷', dialCode: '+385'),
    const CountryCode(
        name: 'Slovenia', code: 'SI', flag: '🇸🇮', dialCode: '+386'),
    const CountryCode(
        name: 'Serbia', code: 'RS', flag: '🇷🇸', dialCode: '+381'),
    const CountryCode(
        name: 'Montenegro', code: 'ME', flag: '🇲🇪', dialCode: '+382'),
    const CountryCode(
        name: 'Bosnia and Herzegovina',
        code: 'BA',
        flag: '🇧🇦',
        dialCode: '+387'),
    const CountryCode(
        name: 'North Macedonia', code: 'MK', flag: '🇲🇰', dialCode: '+389'),
    const CountryCode(
        name: 'Albania', code: 'AL', flag: '🇦🇱', dialCode: '+355'),
    const CountryCode(
        name: 'Greece', code: 'GR', flag: '🇬🇷', dialCode: '+30'),
    const CountryCode(
        name: 'Cyprus', code: 'CY', flag: '🇨🇾', dialCode: '+357'),
    const CountryCode(
        name: 'Malta', code: 'MT', flag: '🇲🇹', dialCode: '+356'),
    const CountryCode(
        name: 'Ireland', code: 'IE', flag: '🇮🇪', dialCode: '+353'),
    const CountryCode(
        name: 'Luxembourg', code: 'LU', flag: '🇱🇺', dialCode: '+352'),
    const CountryCode(
        name: 'Monaco', code: 'MC', flag: '🇲🇨', dialCode: '+377'),
    const CountryCode(
        name: 'Liechtenstein', code: 'LI', flag: '🇱🇮', dialCode: '+423'),
    const CountryCode(
        name: 'San Marino', code: 'SM', flag: '🇸🇲', dialCode: '+378'),
    const CountryCode(
        name: 'Vatican City', code: 'VA', flag: '🇻🇦', dialCode: '+379'),
    const CountryCode(
        name: 'Andorra', code: 'AD', flag: '🇦🇩', dialCode: '+376'),
    const CountryCode(name: 'Russia', code: 'RU', flag: '🇷🇺', dialCode: '+7'),
    const CountryCode(
        name: 'Ukraine', code: 'UA', flag: '🇺🇦', dialCode: '+380'),
    const CountryCode(
        name: 'Belarus', code: 'BY', flag: '🇧🇾', dialCode: '+375'),
    const CountryCode(
        name: 'Moldova', code: 'MD', flag: '🇲🇩', dialCode: '+373'),
    const CountryCode(
        name: 'Estonia', code: 'EE', flag: '🇪🇪', dialCode: '+372'),
    const CountryCode(
        name: 'Latvia', code: 'LV', flag: '🇱🇻', dialCode: '+371'),
    const CountryCode(
        name: 'Lithuania', code: 'LT', flag: '🇱🇹', dialCode: '+370'),
    const CountryCode(
        name: 'Georgia', code: 'GE', flag: '🇬🇪', dialCode: '+995'),
    const CountryCode(
        name: 'Armenia', code: 'AM', flag: '🇦🇲', dialCode: '+374'),
    const CountryCode(
        name: 'Azerbaijan', code: 'AZ', flag: '🇦🇿', dialCode: '+994'),
    const CountryCode(
        name: 'Kazakhstan', code: 'KZ', flag: '🇰🇿', dialCode: '+7'),
    const CountryCode(
        name: 'Uzbekistan', code: 'UZ', flag: '🇺🇿', dialCode: '+998'),
    const CountryCode(
        name: 'Kyrgyzstan', code: 'KG', flag: '🇰🇬', dialCode: '+996'),
    const CountryCode(
        name: 'Tajikistan', code: 'TJ', flag: '🇹🇯', dialCode: '+992'),
    const CountryCode(
        name: 'Turkmenistan', code: 'TM', flag: '🇹🇲', dialCode: '+993'),
    const CountryCode(
        name: 'Australia', code: 'AU', flag: '🇦🇺', dialCode: '+61'),
    const CountryCode(
        name: 'New Zealand', code: 'NZ', flag: '🇳🇿', dialCode: '+64'),
    const CountryCode(name: 'Fiji', code: 'FJ', flag: '🇫🇯', dialCode: '+679'),
    const CountryCode(
        name: 'Papua New Guinea', code: 'PG', flag: '🇵🇬', dialCode: '+675'),
    const CountryCode(
        name: 'Solomon Islands', code: 'SB', flag: '🇸🇧', dialCode: '+677'),
    const CountryCode(
        name: 'Vanuatu', code: 'VU', flag: '🇻🇺', dialCode: '+678'),
    const CountryCode(
        name: 'New Caledonia', code: 'NC', flag: '🇳🇨', dialCode: '+687'),
    const CountryCode(
        name: 'French Polynesia', code: 'PF', flag: '🇵🇫', dialCode: '+689'),
    const CountryCode(
        name: 'Samoa', code: 'WS', flag: '🇼🇸', dialCode: '+685'),
    const CountryCode(
        name: 'Tonga', code: 'TO', flag: '🇹🇴', dialCode: '+676'),
    const CountryCode(
        name: 'Kiribati', code: 'KI', flag: '🇰🇮', dialCode: '+686'),
    const CountryCode(
        name: 'Tuvalu', code: 'TV', flag: '🇹🇻', dialCode: '+688'),
    const CountryCode(
        name: 'Nauru', code: 'NR', flag: '🇳🇷', dialCode: '+674'),
    const CountryCode(
        name: 'Palau', code: 'PW', flag: '🇵🇼', dialCode: '+680'),
    const CountryCode(
        name: 'Marshall Islands', code: 'MH', flag: '🇲🇭', dialCode: '+692'),
    const CountryCode(
        name: 'Micronesia', code: 'FM', flag: '🇫🇲', dialCode: '+691'),
    const CountryCode(
        name: 'South Africa', code: 'ZA', flag: '🇿🇦', dialCode: '+27'),
    const CountryCode(
        name: 'Nigeria', code: 'NG', flag: '🇳🇬', dialCode: '+234'),
    const CountryCode(
        name: 'Kenya', code: 'KE', flag: '🇰🇪', dialCode: '+254'),
    const CountryCode(
        name: 'Ghana', code: 'GH', flag: '🇬🇭', dialCode: '+233'),
    const CountryCode(
        name: 'Ethiopia', code: 'ET', flag: '🇪🇹', dialCode: '+251'),
    const CountryCode(
        name: 'Tanzania', code: 'TZ', flag: '🇹🇿', dialCode: '+255'),
    const CountryCode(
        name: 'Uganda', code: 'UG', flag: '🇺🇬', dialCode: '+256'),
    const CountryCode(
        name: 'Zimbabwe', code: 'ZW', flag: '🇿🇼', dialCode: '+263'),
    const CountryCode(
        name: 'Zambia', code: 'ZM', flag: '🇿🇲', dialCode: '+260'),
    const CountryCode(
        name: 'Malawi', code: 'MW', flag: '🇲🇼', dialCode: '+265'),
    const CountryCode(
        name: 'Mozambique', code: 'MZ', flag: '🇲🇿', dialCode: '+258'),
    const CountryCode(
        name: 'Botswana', code: 'BW', flag: '🇧🇼', dialCode: '+267'),
    const CountryCode(
        name: 'Namibia', code: 'NA', flag: '🇳🇦', dialCode: '+264'),
    const CountryCode(
        name: 'Lesotho', code: 'LS', flag: '🇱🇸', dialCode: '+266'),
    const CountryCode(
        name: 'Eswatini', code: 'SZ', flag: '🇸🇿', dialCode: '+268'),
    const CountryCode(
        name: 'Madagascar', code: 'MG', flag: '🇲🇬', dialCode: '+261'),
    const CountryCode(
        name: 'Mauritius', code: 'MU', flag: '🇲🇺', dialCode: '+230'),
    const CountryCode(
        name: 'Seychelles', code: 'SC', flag: '🇸🇨', dialCode: '+248'),
    const CountryCode(
        name: 'Comoros', code: 'KM', flag: '🇰🇲', dialCode: '+269'),
    const CountryCode(
        name: 'Djibouti', code: 'DJ', flag: '🇩🇯', dialCode: '+253'),
    const CountryCode(
        name: 'Somalia', code: 'SO', flag: '🇸🇴', dialCode: '+252'),
    const CountryCode(
        name: 'Eritrea', code: 'ER', flag: '🇪🇷', dialCode: '+291'),
    const CountryCode(name: 'Chad', code: 'TD', flag: '🇹🇩', dialCode: '+235'),
    const CountryCode(
        name: 'Central African Republic',
        code: 'CF',
        flag: '🇨🇫',
        dialCode: '+236'),
    const CountryCode(
        name: 'Cameroon', code: 'CM', flag: '🇨🇲', dialCode: '+237'),
    const CountryCode(
        name: 'Gabon', code: 'GA', flag: '🇬🇦', dialCode: '+241'),
    const CountryCode(
        name: 'Congo', code: 'CG', flag: '🇨🇬', dialCode: '+242'),
    const CountryCode(
        name: 'Democratic Republic of the Congo',
        code: 'CD',
        flag: '🇨🇩',
        dialCode: '+243'),
    const CountryCode(
        name: 'Angola', code: 'AO', flag: '🇦🇴', dialCode: '+244'),
    const CountryCode(
        name: 'Equatorial Guinea', code: 'GQ', flag: '🇬🇶', dialCode: '+240'),
    const CountryCode(
        name: 'São Tomé and Príncipe',
        code: 'ST',
        flag: '🇸🇹',
        dialCode: '+239'),
    const CountryCode(
        name: 'Cape Verde', code: 'CV', flag: '🇨🇻', dialCode: '+238'),
    const CountryCode(
        name: 'Guinea-Bissau', code: 'GW', flag: '🇬🇼', dialCode: '+245'),
    const CountryCode(
        name: 'Guinea', code: 'GN', flag: '🇬🇳', dialCode: '+224'),
    const CountryCode(
        name: 'Sierra Leone', code: 'SL', flag: '🇸🇱', dialCode: '+232'),
    const CountryCode(
        name: 'Liberia', code: 'LR', flag: '🇱🇷', dialCode: '+231'),
    const CountryCode(
        name: 'Côte d\'Ivoire', code: 'CI', flag: '🇨🇮', dialCode: '+225'),
    const CountryCode(
        name: 'Burkina Faso', code: 'BF', flag: '🇧🇫', dialCode: '+226'),
    const CountryCode(name: 'Mali', code: 'ML', flag: '🇲🇱', dialCode: '+223'),
    const CountryCode(
        name: 'Niger', code: 'NE', flag: '🇳🇪', dialCode: '+227'),
    const CountryCode(
        name: 'Benin', code: 'BJ', flag: '🇧🇯', dialCode: '+229'),
    const CountryCode(name: 'Togo', code: 'TG', flag: '🇹🇬', dialCode: '+228'),
    const CountryCode(
        name: 'Senegal', code: 'SN', flag: '🇸🇳', dialCode: '+221'),
    const CountryCode(
        name: 'Gambia', code: 'GM', flag: '🇬🇲', dialCode: '+220'),
    const CountryCode(
        name: 'Guinea-Bissau', code: 'GW', flag: '🇬🇼', dialCode: '+245'),
    const CountryCode(
        name: 'Mauritania', code: 'MR', flag: '🇲🇷', dialCode: '+222'),
    const CountryCode(
        name: 'Western Sahara', code: 'EH', flag: '🇪🇭', dialCode: '+212'),
  ];

  static List<CountryCode> get countryCodes => _countryCodes;

  static CountryCode? getCountryByCode(String code) {
    try {
      return _countryCodes.firstWhere((country) => country.code == code);
    } catch (e) {
      return null;
    }
  }

  static CountryCode? getCountryByDialCode(String dialCode) {
    try {
      return _countryCodes
          .firstWhere((country) => country.dialCode == dialCode);
    } catch (e) {
      return null;
    }
  }

  static CountryCode getDefaultCountry() {
    return getCountryByCode('JO') ?? _countryCodes.first;
  }
}

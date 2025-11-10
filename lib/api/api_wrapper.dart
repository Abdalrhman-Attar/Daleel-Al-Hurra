import 'package:logger/logger.dart';

import 'request_builder.dart';

abstract class ApiWrapper {
  final ApiService apiService = ApiService();
  final Logger logger = Logger();
}

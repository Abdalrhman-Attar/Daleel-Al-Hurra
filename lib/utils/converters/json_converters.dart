import 'package:freezed_annotation/freezed_annotation.dart';

class StringConverter implements JsonConverter<String?, dynamic> {
  const StringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    return json.toString();
  }

  @override
  dynamic toJson(String? object) => object;
}

class IntConverter implements JsonConverter<int?, dynamic> {
  const IntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) return int.tryParse(json);
    if (json is double) return json.toInt();
    return null; // Lenient fallback
  }

  @override
  dynamic toJson(int? object) => object;
}

class DoubleConverter implements JsonConverter<double?, dynamic> {
  const DoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null; // Lenient fallback
  }

  @override
  dynamic toJson(double? object) => object;
}

class BoolConverter implements JsonConverter<bool?, dynamic> {
  const BoolConverter();

  @override
  bool? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is bool) return json;
    if (json is int) return json == 1;
    if (json is String) {
      final lower = json.toLowerCase();
      return lower == 'true' || lower == '1';
    }
    return null; // Lenient fallback
  }

  @override
  dynamic toJson(bool? object) => object;
}

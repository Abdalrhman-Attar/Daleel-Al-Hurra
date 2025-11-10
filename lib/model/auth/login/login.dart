import 'package:freezed_annotation/freezed_annotation.dart';

import '../user/user.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class Login with _$Login {
  const factory Login({
    String? token,
    @JsonKey(name: 'login_by') String? loginType,
    User? user,
  }) = _Login;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
}

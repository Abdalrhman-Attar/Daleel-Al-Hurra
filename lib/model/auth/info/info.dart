import 'package:freezed_annotation/freezed_annotation.dart';

import '../user/user.dart';

part 'info.freezed.dart';
part 'info.g.dart';

@freezed
class Info with _$Info {
  const factory Info({
    User? user,
    @JsonKey(name: 'is_profile_complete') bool? isProfileCompleted,
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
}

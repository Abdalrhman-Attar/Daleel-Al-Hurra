import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

@freezed
class PageModel with _$PageModel {
  const factory PageModel({
    int? id,
    String? title,
    String? content,
    String? slug,
    String? image,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _PageModel;

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);
}

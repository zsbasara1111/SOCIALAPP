import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户模型
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    required String nickname,
    String? avatarUrl,
    String? gender,
    DateTime? birthDate,
    String? city,
    String? bio,
    @Default(false) bool isVip,
    @Default('none') String vipTier,
    DateTime? vipExpireAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastActiveAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// 用户照片墙模型
@freezed
class UserPhotoModel with _$UserPhotoModel {
  const factory UserPhotoModel({
    required String id,
    required String userId,
    required String photoUrl,
    @Default(0) int sortOrder,
    required DateTime createdAt,
  }) = _UserPhotoModel;

  factory UserPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$UserPhotoModelFromJson(json);
}

/// 用户资料扩展信息
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required UserModel user,
    @Default([]) List<UserPhotoModel> photos,
    @Default([]) List<UserHobbyItemModel> hobbies,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// 爱好分类模型
@freezed
class HobbyCategoryModel with _$HobbyCategoryModel {
  const factory HobbyCategoryModel({
    required String id,
    required String name,
    String? iconName,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _HobbyCategoryModel;

  factory HobbyCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$HobbyCategoryModelFromJson(json);
}

/// 用户爱好条目模型
@freezed
class UserHobbyItemModel with _$UserHobbyItemModel {
  const factory UserHobbyItemModel({
    required String id,
    required String userId,
    required String categoryId,
    required String itemName,
    String? categoryName,
    required DateTime createdAt,
  }) = _UserHobbyItemModel;

  factory UserHobbyItemModel.fromJson(Map<String, dynamic> json) =>
      _$UserHobbyItemModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// 匹配记录模型
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String userId1,
    required String userId2,
    @Default(0) int matchScore,
    @Default([]) List<dynamic> commonHobbies,
    @Default('pending') String status,
    required DateTime createdAt,
    DateTime? matchedAt,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}

/// 滑动动作模型
@freezed
class SwipeActionModel with _$SwipeActionModel {
  const factory SwipeActionModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required String action, // 'like' 或 'dislike'
    required String matchMode, // 'hobby', 'city', 'precise'
    required DateTime createdAt,
  }) = _SwipeActionModel;

  factory SwipeActionModel.fromJson(Map<String, dynamic> json) =>
      _$SwipeActionModelFromJson(json);
}

/// 匹配使用统计模型
@freezed
class MatchUsageModel with _$MatchUsageModel {
  const factory MatchUsageModel({
    required String id,
    required String userId,
    required String matchMode, // 'hobby', 'city', 'precise'
    required DateTime usageDate,
    @Default(0) int usedCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MatchUsageModel;

  factory MatchUsageModel.fromJson(Map<String, dynamic> json) =>
      _$MatchUsageModelFromJson(json);
}

/// 匹配限制常量
class MatchLimits {
  // 普通用户每日限制
  static const int hobbyMatchFreeDaily = 30; // 同好匹配
  static const int cityMatchFreeDaily = 10; // 同城匹配

  // VIP 用户每日限制
  static const int hobbyMatchVipDaily = 999999; // 同好匹配无限
  static const int cityMatchVipDaily = 50; // 同城匹配
  static const int preciseMatchVipDaily = 30; // 精准匹配

  // 匹配模式名称
  static const String modeHobby = 'hobby';
  static const String modeCity = 'city';
  static const String modePrecise = 'precise';
}

/// 匹配用户卡片数据
@freezed
class MatchCardModel with _$MatchCardModel {
  const factory MatchCardModel({
    required String id,
    required String nickname,
    String? avatarUrl,
    String? city,
    int? age,
    @Default([]) List<String> photos,
    @Default([]) List<UserHobbyInfo> hobbies,
    int? matchScore,
    @Default([]) List<String> commonHobbies,
  }) = _MatchCardModel;

  factory MatchCardModel.fromJson(Map<String, dynamic> json) =>
      _$MatchCardModelFromJson(json);
}

/// 用户爱好信息（用于匹配卡片）
@freezed
class UserHobbyInfo with _$UserHobbyInfo {
  const factory UserHobbyInfo({
    required String categoryName,
    required String itemName,
  }) = _UserHobbyInfo;

  factory UserHobbyInfo.fromJson(Map<String, dynamic> json) =>
      _$UserHobbyInfoFromJson(json);
}

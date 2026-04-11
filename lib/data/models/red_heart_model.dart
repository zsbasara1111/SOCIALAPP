import 'package:freezed_annotation/freezed_annotation.dart';

part 'red_heart_model.freezed.dart';
part 'red_heart_model.g.dart';

/// 红心记录模型
@freezed
class RedHeartModel with _$RedHeartModel {
  const factory RedHeartModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required DateTime createdAt,
    // 关联字段
    String? fromUserNickname,
    String? fromUserAvatar,
    String? toUserNickname,
    String? toUserAvatar,
    @Default(false) bool hasMutual, // 是否互点
  }) = _RedHeartModel;

  factory RedHeartModel.fromJson(Map<String, dynamic> json) =>
      _$RedHeartModelFromJson(json);
}

/// 红心状态
@freezed
class RedHeartStatus with _$RedHeartStatus {
  const factory RedHeartStatus({
    required String userId,
    @Default(false) bool hasSentHeart,
    @Default(false) bool hasReceivedHeart,
    @Default(false) bool isMutual,
    DateTime? sentAt,
    DateTime? receivedAt,
  }) = _RedHeartStatus;

  factory RedHeartStatus.fromJson(Map<String, dynamic> json) =>
      _$RedHeartStatusFromJson(json);
}

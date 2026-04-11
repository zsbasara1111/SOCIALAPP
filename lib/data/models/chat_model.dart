import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// 聊天会话模型
@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required String userId1,
    required String userId2,
    String? lastMessage,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount1,
    @Default(0) int unreadCount2,
    @Default(true) bool isActive,
    required DateTime createdAt,
    // 关联字段
    String? otherUserNickname,
    String? otherUserAvatar,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}

/// 消息模型
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    @Default('text') String messageType, // text, image, system
    @Default(false) bool isRead,
    required DateTime createdAt,
    // 关联字段
    String? senderNickname,
    String? senderAvatar,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

/// 发送消息请求
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required String conversationId,
    required String content,
    @Default('text') String messageType,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}

/// 消息类型常量
class MessageTypes {
  static const String text = 'text';
  static const String image = 'image';
  static const String system = 'system';
}

/// 系统消息类型
class SystemMessageTypes {
  static const String match = 'match'; // 匹配成功
  static const String redHeart = 'red_heart'; // 红心互动
  static const String dateInvite = 'date_invite'; // 约会邀请
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// 动态模型
@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String userId,
    required String content,
    @Default([]) List<String> images,
    String? location,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    // 关联字段（查询时填充）
    String? userNickname,
    String? userAvatar,
    @Default(false) bool isLikedByMe,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

/// 动态点赞模型
@freezed
class PostLikeModel with _$PostLikeModel {
  const factory PostLikeModel({
    required String id,
    required String postId,
    required String userId,
    required DateTime createdAt,
  }) = _PostLikeModel;

  factory PostLikeModel.fromJson(Map<String, dynamic> json) =>
      _$PostLikeModelFromJson(json);
}

/// 动态评论模型
@freezed
class PostCommentModel with _$PostCommentModel {
  const factory PostCommentModel({
    required String id,
    required String postId,
    required String userId,
    String? parentId, // 回复的评论ID
    required String content,
    @Default(0) int likeCount,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    // 关联字段
    String? userNickname,
    String? userAvatar,
    @Default([]) List<PostCommentModel> replies, // 子回复
  }) = _PostCommentModel;

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);
}

/// 动态发布请求
@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String content,
    @Default([]) List<String> images,
    String? location,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

/// 动态筛选类型
enum PostFilterType {
  all, // 全部
  city, // 同城
  following, // 关注
}

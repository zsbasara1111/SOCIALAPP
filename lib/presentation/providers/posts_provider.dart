import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 动态类型
enum PostType {
  text,
  image,
  video,
}

/// 动态模型
class Post {
  final String id;
  final String userId;
  final String userNickname;
  final String? userAvatar;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final String? city;

  const Post({
    required this.id,
    required this.userId,
    required this.userNickname,
    this.userAvatar,
    required this.content,
    this.imageUrls = const [],
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.city,
  });
}

/// 动态筛选类型
enum PostsFilter {
  all,      // 推荐
  friends,  // 好友
  city,     // 同城
}

extension PostsFilterExtension on PostsFilter {
  String get displayName {
    switch (this) {
      case PostsFilter.all:
        return '推荐';
      case PostsFilter.friends:
        return '好友';
      case PostsFilter.city:
        return '同城';
    }
  }
}

/// 动态状态
class PostsState {
  final List<Post> posts;
  final PostsFilter currentFilter;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  const PostsState({
    this.posts = const [],
    this.currentFilter = PostsFilter.all,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  PostsState copyWith({
    List<Post>? posts,
    PostsFilter? currentFilter,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      currentFilter: currentFilter ?? this.currentFilter,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// 发布动态状态
class CreatePostState {
  final String content;
  final List<String> selectedImages;
  final bool isPosting;
  final String? error;

  const CreatePostState({
    this.content = '',
    this.selectedImages = const [],
    this.isPosting = false,
    this.error,
  });

  CreatePostState copyWith({
    String? content,
    List<String>? selectedImages,
    bool? isPosting,
    String? error,
  }) {
    return CreatePostState(
      content: content ?? this.content,
      selectedImages: selectedImages ?? this.selectedImages,
      isPosting: isPosting ?? this.isPosting,
      error: error ?? this.error,
    );
  }

  bool get canPost => content.trim().isNotEmpty || selectedImages.isNotEmpty;
  bool get canAddImage => selectedImages.length < 9;
}

/// 动态列表状态管理
class PostsNotifier extends StateNotifier<PostsState> {
  PostsNotifier() : super(const PostsState()) {
    loadPosts();
  }

  /// 加载动态列表
  Future<void> loadPosts({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final page = refresh ? 1 : state.currentPage;

      // TODO: 从Supabase获取动态列表
      await Future.delayed(const Duration(milliseconds: 800));

      // 模拟数据
      final mockPosts = _getMockPosts();

      state = state.copyWith(
        posts: refresh ? mockPosts : [...state.posts, ...mockPosts],
        isLoading: false,
        hasMore: mockPosts.length >= 10,
        currentPage: page + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载失败，请重试',
      );
    }
  }

  /// 切换筛选
  Future<void> switchFilter(PostsFilter filter) async {
    if (state.currentFilter == filter) return;

    state = state.copyWith(
      currentFilter: filter,
      posts: [],
      currentPage: 1,
      hasMore: true,
    );

    await loadPosts(refresh: true);
  }

  /// 点赞/取消点赞
  Future<void> toggleLike(String postId) async {
    // TODO: 调用服务器API

    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return Post(
          id: post.id,
          userId: post.userId,
          userNickname: post.userNickname,
          userAvatar: post.userAvatar,
          content: post.content,
          imageUrls: post.imageUrls,
          createdAt: post.createdAt,
          likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
          commentCount: post.commentCount,
          isLiked: !post.isLiked,
          city: post.city,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadPosts();
  }

  /// 模拟数据
  List<Post> _getMockPosts() {
    return [
      Post(
        id: '1',
        userId: 'user1',
        userNickname: '小橘子',
        content: '今天看完《三体》，被大刘的想象力震撼到了！黑暗森林法则真的很深刻，推荐给大家。',
        imageUrls: [],
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        likeCount: 23,
        commentCount: 8,
        city: '上海',
      ),
      Post(
        id: '2',
        userId: 'user2',
        userNickname: '音乐旅人',
        content: '周杰伦新专辑循环播放中，最喜欢《最伟大的作品》这首歌！',
        imageUrls: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likeCount: 156,
        commentCount: 42,
        isLiked: true,
        city: '北京',
      ),
      Post(
        id: '3',
        userId: 'user3',
        userNickname: '游戏宅',
        content: '原神新版本太肝了，但是剧情真的很棒！截图留念~',
        imageUrls: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likeCount: 89,
        commentCount: 15,
        city: '广州',
      ),
    ];
  }
}

/// 发布动态状态管理
class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(const CreatePostState());

  /// 设置内容
  void setContent(String content) {
    state = state.copyWith(content: content);
  }

  /// 添加图片
  void addImage(String imagePath) {
    if (!state.canAddImage) return;

    state = state.copyWith(
      selectedImages: [...state.selectedImages, imagePath],
    );
  }

  /// 移除图片
  void removeImage(int index) {
    final images = [...state.selectedImages];
    images.removeAt(index);
    state = state.copyWith(selectedImages: images);
  }

  /// 发布动态
  Future<bool> post() async {
    if (!state.canPost) return false;

    state = state.copyWith(isPosting: true, error: null);

    try {
      // TODO: 调用API发布动态
      await Future.delayed(const Duration(seconds: 1));

      // 清空状态
      state = const CreatePostState();
      return true;
    } catch (e) {
      state = state.copyWith(
        isPosting: false,
        error: '发布失败，请重试',
      );
      return false;
    }
  }

  /// 清空
  void clear() {
    state = const CreatePostState();
  }
}

/// 动态列表提供者
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  return PostsNotifier();
});

/// 发布动态提供者
final createPostProvider = StateNotifierProvider<CreatePostNotifier, CreatePostState>((ref) {
  return CreatePostNotifier();
});

/// 当前筛选提供者
final postsFilterProvider = Provider<PostsFilter>((ref) {
  return ref.watch(postsProvider).currentFilter;
});

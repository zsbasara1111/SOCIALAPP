import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/hobby_provider.dart';
import '../../providers/red_heart_provider.dart';
import 'chat_detail_page.dart';

/// 聊天列表页面
class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 顶部标题栏
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '消息',
                      style: AppTheme.headlineSmall.copyWith(
                        fontFamily: AppTheme.fontFamilyDisplay,
                      ),
                    ),
                    // 新匹配入口
                    GestureDetector(
                      onTap: () {
                        // TODO: 查看新匹配
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceMd,
                          vertical: AppTheme.spaceSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '新匹配',
                              style: AppTheme.labelMedium.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 聊天列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // 模拟数据（每个人的爱好不同）
                  final chats = [
                    _ChatData(
                      id: '1',
                      name: '小雨',
                      message: '你好呀～看到你的资料觉得很有缘！',
                      time: '10:30',
                      unreadCount: 3,
                      avatar: 'https://randomuser.me/api/portraits/women/3.jpg',
                      age: 24,
                      city: '上海',
                      bio: '喜欢阅读和旅行，享受安静的午后时光',
                      hobbies: [
                        UserHobbyItem(categoryId: 'books', itemName: '《三体》'),
                        UserHobbyItem(categoryId: 'travel', itemName: '日本'),
                        UserHobbyItem(categoryId: 'movies', itemName: '《千与千寻》'),
                      ],
                    ),
                    _ChatData(
                      id: '2',
                      name: '旅行者',
                      message: '那张照片是在哪里拍的？风景真美',
                      time: '昨天',
                      unreadCount: 0,
                      avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
                      age: 26,
                      city: '北京',
                      bio: '用脚步丈量世界，用镜头记录风景',
                      hobbies: [
                        UserHobbyItem(categoryId: 'travel', itemName: '西藏'),
                        UserHobbyItem(categoryId: 'photography', itemName: '风光摄影'),
                        UserHobbyItem(categoryId: 'music', itemName: '民谣'),
                      ],
                    ),
                    _ChatData(
                      id: '3',
                      name: '美食探索家',
                      message: '推荐你去试试那家新开的日料店！',
                      time: '昨天',
                      unreadCount: 1,
                      avatar: 'https://randomuser.me/api/portraits/women/5.jpg',
                      age: 25,
                      city: '广州',
                      bio: '人生苦短，唯有美食不可辜负',
                      hobbies: [
                        UserHobbyItem(categoryId: 'food', itemName: '日料'),
                        UserHobbyItem(categoryId: 'food', itemName: '火锅'),
                        UserHobbyItem(categoryId: 'movies', itemName: '《深夜食堂》'),
                      ],
                    ),
                    _ChatData(
                      id: '4',
                      name: '摄影爱好者',
                      message: '可以交流一下摄影技巧～',
                      time: '周一',
                      unreadCount: 0,
                      avatar: 'https://randomuser.me/api/portraits/men/6.jpg',
                      age: 23,
                      city: '杭州',
                      bio: '摄影是光的绘画',
                      hobbies: [
                        UserHobbyItem(categoryId: 'photography', itemName: '人像摄影'),
                        UserHobbyItem(categoryId: 'photography', itemName: '胶片'),
                        UserHobbyItem(categoryId: 'music', itemName: '爵士乐'),
                      ],
                    ),
                  ];

                  if (index >= chats.length) {
                    return const SizedBox.shrink();
                  }

                  final chat = chats[index];
                  return _buildChatItem(
                    context,
                    chat: chat,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            userId: chat.id,
                            userName: chat.name,
                            avatar: chat.avatar,
                            age: chat.age,
                            city: chat.city,
                            bio: chat.bio,
                            matchUserHobbies: chat.hobbies,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required _ChatData chat,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceLg,
          vertical: AppTheme.spaceXs,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Row(
          children: [
            // 头像
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.8),
                        AppTheme.accent.withOpacity(0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: chat.avatar != null
                      ? ClipOval(
                          child: Image.network(
                            chat.avatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Text(
                                chat.name.substring(0, 1),
                                style: AppTheme.titleLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            chat.name.substring(0, 1),
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                // 在线状态指示器
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppTheme.spaceLg),

            // 消息内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chat.name,
                            style: AppTheme.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // 红心互点标记（仅爱心图标）
                          Consumer(
                            builder: (context, ref, child) {
                              final isMutual = ref.watch(
                                isMutualHeartProvider(chat.id),
                              );
                              if (!isMutual) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE91E63),
                                        Color(0xFFFF6B9D),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        chat.time,
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.message,
                          style: AppTheme.bodyMedium.copyWith(
                            color: chat.unreadCount > 0
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: AppTheme.spaceSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: AppTheme.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 聊天数据
class _ChatData {
  final String id;
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final String? avatar;
  final int? age;
  final String? city;
  final String? bio;
  final List<UserHobbyItem> hobbies;

  const _ChatData({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    this.avatar,
    this.age,
    this.city,
    this.bio,
    this.hobbies = const [],
  });
}

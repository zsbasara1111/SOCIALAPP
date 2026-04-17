import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 我喜欢的人页面
class LikedUsersPage extends StatelessWidget {
  const LikedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 从服务器加载真实数据
    final likedUsers = [
      _LikedUser(
        id: '1',
        name: '小雨',
        age: 24,
        city: '上海',
        avatar: null,
        likedAt: '3天前',
      ),
      _LikedUser(
        id: '2',
        name: '旅行者',
        age: 26,
        city: '北京',
        avatar: null,
        likedAt: '1周前',
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '我喜欢的人',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
      ),
      body: likedUsers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              itemCount: likedUsers.length,
              itemBuilder: (context, index) {
                final user = likedUsers[index];
                return _buildUserCard(context, user);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Text(
            '还没有喜欢的人',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '去匹配页面发现更多有趣的人吧',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, _LikedUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          // 头像
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
            child: user.avatar != null
                ? ClipOval(
                    child: Image.network(
                      user.avatar!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      user.name.substring(0, 1),
                      style: AppTheme.titleLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: AppTheme.spaceLg),
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name} · ${user.age}岁',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.city,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '喜欢于 ${user.likedAt}',
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // 取消喜欢按钮
          IconButton(
            onPressed: () {
              // TODO: 取消喜欢
            },
            icon: Icon(
              Icons.favorite,
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _LikedUser {
  final String id;
  final String name;
  final int age;
  final String city;
  final String? avatar;
  final String likedAt;

  const _LikedUser({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    this.avatar,
    required this.likedAt,
  });
}

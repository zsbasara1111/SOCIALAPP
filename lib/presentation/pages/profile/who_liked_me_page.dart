import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../providers/user_interactions_provider.dart';

/// 谁喜欢我页面
class WhoLikedMePage extends ConsumerWidget {
  const WhoLikedMePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userInteractionsProvider).usersWhoLikedMe;

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
          '谁喜欢我',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
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
            '还没有人喜欢过你',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '完善资料，让更多人发现你的魅力',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, InteractionUser user) {
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
                  AppTheme.primary.withValues(alpha: 0.8),
                  AppTheme.accent.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: user.avatarUrl != null
                ? ClipOval(
                    child: AppImage(
                      imagePath: user.avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      user.nickname.substring(0, 1),
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
                  '${user.nickname}${user.age != null ? ' · ${user.age}岁' : ''}',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (user.city != null)
                  Text(
                    user.city!,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '喜欢于 ${_formatTime(user.interactedAt)}',
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // 喜欢图标
          const Icon(
            Icons.favorite,
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../providers/posts_provider.dart';

/// 动态卡片组件
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceSm,
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头部信息
          _buildHeader(),

          const SizedBox(height: AppTheme.spaceMd),

          // 内容
          _buildContent(),

          // 图片网格
          if (post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spaceMd),
            _buildImageGrid(),
          ],

          const SizedBox(height: AppTheme.spaceMd),

          // 位置和标签
          if (post.city != null)
            _buildLocation(),

          const SizedBox(height: AppTheme.spaceMd),

          // 互动按钮
          _buildActions(),
        ],
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Row(
      children: [
        // 头像
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.8),
                AppTheme.accent.withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: post.userAvatar != null
              ? ClipOval(
                  child: AppImage(
                    imagePath: post.userAvatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),

        const SizedBox(width: AppTheme.spaceMd),

        // 用户信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userNickname,
                style: AppTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(post.createdAt),
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),

        // 更多按钮
        IconButton(
          onPressed: () {
            // TODO: 显示更多选项
          },
          icon: Icon(
            Icons.more_horiz,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  /// 构建内容
  Widget _buildContent() {
    return Text(
      post.content,
      style: AppTheme.bodyLarge.copyWith(
        color: AppTheme.textPrimary,
        height: 1.6,
      ),
    );
  }

  /// 构建图片网格
  Widget _buildImageGrid() {
    final imageCount = post.imageUrls.length;

    if (imageCount == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: AppImage(
            imagePath: post.imageUrls[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // 多图网格
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: imageCount <= 4 ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: imageCount,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: AppImage(
            imagePath: post.imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  /// 构建位置
  Widget _buildLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 14,
          color: AppTheme.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          post.city!,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  /// 构建互动按钮
  Widget _buildActions() {
    return Row(
      children: [
        // 点赞
        _buildActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          color: post.isLiked ? const Color(0xFFEF4444) : AppTheme.textTertiary,
          count: post.likeCount,
          onTap: onLike,
        ),

        const SizedBox(width: AppTheme.spaceXl),

        // 评论
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: post.commentCount,
          onTap: onComment,
        ),

        const SizedBox(width: AppTheme.spaceXl),

        // 分享
        _buildActionButton(
          icon: Icons.share_outlined,
          onTap: onShare,
        ),
      ],
    );
  }

  /// 构建单个互动按钮
  Widget _buildActionButton({
    required IconData icon,
    Color? color,
    int? count,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? AppTheme.textTertiary,
          ),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: AppTheme.bodySmall.copyWith(
                color: color ?? AppTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 格式化时间
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

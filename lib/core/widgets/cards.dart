import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

/// 匹配卡片 - 核心组件
class MatchCard extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final int age;
  final String city;
  final int matchScore;
  final List<String> commonHobbies;
  final VoidCallback? onPhotoTapLeft;
  final VoidCallback? onPhotoTapRight;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  const MatchCard({
    super.key,
    this.photoUrl,
    required this.name,
    required this.age,
    required this.city,
    required this.matchScore,
    this.commonHobbies = const [],
    this.onPhotoTapLeft,
    this.onPhotoTapRight,
    this.onLike,
    this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowLg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        child: Stack(
          children: [
            // 照片区域
            AspectRatio(
              aspectRatio: 3 / 4,
              child: GestureDetector(
                onTapUp: (details) {
                  final width = context.size?.width ?? 0;
                  if (details.localPosition.dx < width / 2) {
                    onPhotoTapLeft?.call();
                  } else {
                    onPhotoTapRight?.call();
                  }
                },
                child: Container(
                  color: AppTheme.surfaceVariant,
                  child: photoUrl != null
                      ? AppImage(
                          imagePath: photoUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 120,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                ),
              ),
            ),

            // 渐变遮罩
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // 信息叠加层
            Positioned(
              bottom: AppTheme.spaceXl,
              left: AppTheme.spaceXl,
              right: AppTheme.spaceXl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 匹配值徽章
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceMd,
                      vertical: AppTheme.spaceXs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '匹配值 $matchScore',
                      style: AppTheme.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),

                  // 姓名年龄
                  Row(
                    children: [
                      Text(
                        name,
                        style: AppTheme.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      Text(
                        '$age',
                        style: AppTheme.titleLarge.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceXs),

                  // 城市
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: AppTheme.spaceXs),
                      Text(
                        city,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMd),

                  // 共同爱好标签
                  if (commonHobbies.isNotEmpty)
                    Wrap(
                      spacing: AppTheme.spaceSm,
                      runSpacing: AppTheme.spaceSm,
                      children: commonHobbies.take(3).map((hobby) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceMd,
                            vertical: AppTheme.spaceXs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            hobby,
                            style: AppTheme.labelSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            // 左右滑动提示
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: onPhotoTapLeft,
                child: Container(
                  width: 60,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onPhotoTapRight,
                child: Container(
                  width: 60,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 动态卡片
class PostCard extends StatelessWidget {
  final String? userAvatar;
  final String userName;
  final String? content;
  final List<String>? images;
  final String? location;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    this.userAvatar,
    required this.userName,
    this.content,
    this.images,
    this.location,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.surfaceVariant,
                  backgroundImage: userAvatar != null
                      ? NetworkImage(userAvatar!)
                      : null,
                  child: userAvatar == null
                      ? const Icon(Icons.person, color: AppTheme.textTertiary)
                      : null,
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(width: AppTheme.spaceXs),
                            Text(
                              location!,
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceLg),

            // 文字内容
            if (content != null)
              Text(
                content!,
                style: AppTheme.bodyLarge,
              ),
            if (content != null) const SizedBox(height: AppTheme.spaceLg),

            // 图片网格
            if (images != null && images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                child: _buildImageGrid(images!),
              ),
            if (images != null && images!.isNotEmpty)
              const SizedBox(height: AppTheme.spaceLg),

            // 操作栏
            Row(
              children: [
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  count: likeCount,
                  color: isLiked ? AppTheme.error : AppTheme.textSecondary,
                  onTap: onLike,
                ),
                const SizedBox(width: AppTheme.spaceXl),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  count: commentCount,
                  onTap: onComment,
                ),
                const SizedBox(width: AppTheme.spaceXl),
                _ActionButton(
                  icon: Icons.share,
                  onTap: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return AspectRatio(
        aspectRatio: 1,
        child: AppImage(
          imagePath: images[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      return Row(
        children: images.map((url) {
          return Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: AppImage(imagePath: url, fit: BoxFit.cover),
            ),
          );
        }).toList(),
      );
    } else if (images.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: AppImage(imagePath: images[0], fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Column(
              children: images.sublist(1).map((url) {
                return Expanded(
                  child: AppImage(imagePath: url, fit: BoxFit.cover),
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: images.take(9).map((url) {
          return AppImage(imagePath: url, fit: BoxFit.cover);
        }).toList(),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int? count;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.count,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: color ?? AppTheme.textSecondary,
          ),
          if (count != null) ...[
            const SizedBox(width: AppTheme.spaceXs),
            Text(
              count.toString(),
              style: AppTheme.bodySmall.copyWith(
                color: color ?? AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 爱好标签
class HobbyTag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? color;

  const HobbyTag({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppTheme.primary)
              : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected
                ? (color ?? AppTheme.primary)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// VIP卡片
class VipCard extends StatelessWidget {
  final String tier;
  final String price;
  final String period;
  final List<String> benefits;
  final bool isPopular;
  final VoidCallback? onSubscribe;

  const VipCard({
    super.key,
    required this.tier,
    required this.price,
    required this.period,
    required this.benefits,
    this.isPopular = false,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spaceMd),
      decoration: BoxDecoration(
        gradient: isPopular ? AppTheme.vipGradient : null,
        color: isPopular ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: isPopular ? AppTheme.shadowLg : AppTheme.shadowSm,
        border: !isPopular
            ? Border.all(color: AppTheme.textTertiary.withOpacity(0.3))
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMd,
                    vertical: AppTheme.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: const Text(
                    '最受欢迎',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: AppTheme.spaceMd),
              Text(
                tier,
                style: (isPopular
                        ? AppTheme.headlineMedium
                        : AppTheme.headlineSmall)
                    .copyWith(
                  color: isPopular ? Colors.white : AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceXs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: AppTheme.displaySmall.copyWith(
                      color: isPopular ? Colors.white : AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceXs),
                  Text(
                    period,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isPopular
                          ? Colors.white.withOpacity(0.8)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceLg),
              ...benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spaceSm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: isPopular
                            ? Colors.white
                            : AppTheme.successDark,
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      Text(
                        benefit,
                        style: AppTheme.bodyMedium.copyWith(
                          color: isPopular
                              ? Colors.white.withOpacity(0.9)
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppTheme.spaceLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPopular ? Colors.white : AppTheme.primary,
                    foregroundColor:
                        isPopular ? AppTheme.vipGold : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                  ),
                  child: Text(
                    '立即升级',
                    style: AppTheme.labelLarge.copyWith(
                      color: isPopular ? AppTheme.vipGold : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

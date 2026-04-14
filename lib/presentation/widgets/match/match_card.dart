import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/match_provider.dart';

/// 匹配卡片组件
class MatchCard extends StatelessWidget {
  final MatchUser user;

  const MatchCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowMd,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        child: Stack(
          children: [
            // 照片区域
            _buildPhotoArea(),

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
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            // 信息区域
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户名和基本信息
                    Row(
                      children: [
                        Text(
                          user.nickname,
                          style: const TextStyle(
                            fontFamily: AppTheme.fontFamilyDisplay,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (user.age != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${user.age}岁',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        // 在线状态
                        if (user.isOnline)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spaceSm),

                    // 城市
                    if (user.city != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.city!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: AppTheme.spaceMd),

                    // 个人简介
                    if (user.bio != null)
                      Text(
                        user.bio!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: AppTheme.spaceMd),

                    // 爱好标签（简化版）
                    _buildHobbyTags(),
                  ],
                ),
              ),
            ),

            // 照片指示器
            if (user.photoUrls.length > 1)
              Positioned(
                top: AppTheme.spaceLg,
                left: AppTheme.spaceLg,
                right: AppTheme.spaceLg,
                child: Row(
                  children: List.generate(
                    user.photoUrls.length,
                    (index) => Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建照片区域
  Widget _buildPhotoArea() {
    // 如果没有照片，显示占位图
    if (user.photoUrls.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.surfaceVariant,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppTheme.primary.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 有照片时显示照片
    return PageView.builder(
      itemCount: user.photoUrls.length,
      itemBuilder: (context, index) {
        return Image.network(
          user.photoUrls[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppTheme.surfaceVariant,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.surfaceVariant,
              child: Icon(
                Icons.image_not_supported,
                color: AppTheme.textTertiary,
              ),
            );
          },
        );
      },
    );
  }

  /// 构建爱好标签
  Widget _buildHobbyTags() {
    if (user.hobbies.isEmpty) {
      return const SizedBox.shrink();
    }

    // 只显示前3个爱好
    final displayHobbies = user.hobbies.take(3).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayHobbies.map((hobby) {
        // 获取分类颜色（这里简化处理）
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            hobby.itemName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../providers/match_provider.dart';

/// 匹配成功弹窗 - Mindate 双卡片倾斜风格
class MatchSuccessDialog extends StatelessWidget {
  final MatchUser matchedUser;
  final VoidCallback onClose;
  final VoidCallback onChat;

  const MatchSuccessDialog({
    super.key,
    required this.matchedUser,
    required this.onClose,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: AppTheme.shadowXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            const Text(
              '匹配成功！',
              style: TextStyle(
                fontFamily: AppTheme.fontFamilyDisplay,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // 双卡片展示
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 左侧卡片（当前用户 - 模拟）
                  Positioned(
                    left: 20,
                    child: Transform.rotate(
                      angle: -0.26, // -15度
                      child: _buildMiniCard(
                        avatarUrl: 'assets/images/avatars/male_01.jpg',
                        name: '我',
                      ),
                    ),
                  ),
                  // 右侧卡片（匹配用户）
                  Positioned(
                    right: 20,
                    child: Transform.rotate(
                      angle: 0.26, // +15度
                      child: _buildMiniCard(
                        avatarUrl: matchedUser.avatarUrl,
                        name: matchedUser.nickname,
                      ),
                    ),
                  ),
                  // 中心红心
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // 提示文字
            Text(
              '你们都喜欢相同的作品，\n开始聊天吧！',
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // 按钮
            Row(
              children: [
                // 稍后再说
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: BorderSide(color: AppTheme.textTertiary.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spaceMd,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: const Text('稍后再说'),
                  ),
                ),

                const SizedBox(width: AppTheme.spaceMd),

                // 立即聊天
                Expanded(
                  child: ElevatedButton(
                    onPressed: onChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spaceMd,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: const Text('立即聊天'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建小卡片
  Widget _buildMiniCard({
    required String? avatarUrl,
    required String name,
  }) {
    return Container(
      width: 100,
      height: 130,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowMd,
        border: Border.all(
          color: AppTheme.surfaceVariant,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withOpacity(0.8),
                  AppTheme.accent.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: avatarUrl != null
                ? ClipOval(
                    child: AppImage(
                      imagePath: avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            name,
            style: AppTheme.labelMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

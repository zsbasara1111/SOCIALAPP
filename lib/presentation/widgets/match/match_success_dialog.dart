import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/match_provider.dart';

/// 匹配成功弹窗
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B4A), Color(0xFFFF8F73)],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            const Text(
              '匹配成功！',
              style: TextStyle(
                fontFamily: AppTheme.fontFamilyDisplay,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // 用户头像
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: matchedUser.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        matchedUser.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.primary,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.primary,
                    ),
            ),

            const SizedBox(height: AppTheme.spaceMd),

            // 用户名
            Text(
              matchedUser.nickname,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            // 年龄和城市
            if (matchedUser.age != null || matchedUser.city != null)
              Text(
                [
                  if (matchedUser.age != null) '${matchedUser.age}岁',
                  if (matchedUser.city != null) matchedUser.city!,
                ].join(' · '),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

            const SizedBox(height: AppTheme.spaceXl),

            // 提示文字
            Text(
              '你们都喜欢相同的作品，\n开始聊天吧！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
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
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
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
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
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
}

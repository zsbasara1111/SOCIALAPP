import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 聊天列表页面
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('消息'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildChatItem(
            name: '用户 $index',
            message: '你好呀～',
            time: '10:30',
            unreadCount: index == 0 ? 3 : 0,
          );
        },
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String message,
    required String time,
    int unreadCount = 0,
  }) {
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
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.primaryLight,
            child: Text(
              name.substring(0, 1),
              style: AppTheme.titleLarge.copyWith(color: AppTheme.primary),
            ),
          ),
          const SizedBox(width: AppTheme.spaceLg),
          // 消息内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTheme.titleMedium),
                const SizedBox(height: AppTheme.spaceXs),
                Text(
                  message,
                  style: AppTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 时间和未读数
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: AppTheme.labelSmall),
              if (unreadCount > 0) ...[
                const SizedBox(height: AppTheme.spaceXs),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceXs),
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unreadCount',
                    style: AppTheme.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

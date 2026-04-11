import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';

/// 动态页面
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('动态'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        bottom: TabBar(
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: '推荐'),
            Tab(text: '同城'),
            Tab(text: '关注'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        children: const [
          PostCard(
            userName: '小明',
            content: '今天去看了周杰伦的演唱会，太开心了！',
            location: '北京',
            likeCount: 128,
            commentCount: 32,
          ),
          SizedBox(height: AppTheme.spaceLg),
          PostCard(
            userName: '小红',
            content: '刚读完《三体》，震撼到说不出话来...',
            location: '上海',
            likeCount: 256,
            commentCount: 45,
          ),
        ],
      ),
    );
  }
}

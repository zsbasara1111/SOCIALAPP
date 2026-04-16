import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/posts/post_card.dart';
import 'create_post_page.dart';

/// 动态列表页面
class PostsPage extends ConsumerStatefulWidget {
  const PostsPage({super.key});

  @override
  ConsumerState<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final posts = postsState.posts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 顶部导航
            SliverToBoxAdapter(
              child: _buildAppBar(),
            ),

            // 筛选标签
            SliverToBoxAdapter(
              child: _buildFilterTabs(),
            ),

            // 动态列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= posts.length) {
                    return postsState.hasMore
                        ? _buildLoadingIndicator()
                        : _buildNoMoreIndicator();
                  }
                  return PostCard(
                    post: posts[index],
                    onLike: () {
                      ref
                          .read(postsProvider.notifier)
                          .toggleLike(posts[index].id);
                    },
                    onComment: () {
                      // TODO: 打开评论页面
                    },
                  );
                },
                childCount: posts.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreatePostPage(),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 构建顶部导航
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '动态广场',
            style: AppTheme.headlineSmall.copyWith(
              fontFamily: AppTheme.fontFamilyDisplay,
            ),
          ),
          // 发布动态入口
          IconButton(
            onPressed: () => context.goCreatePost(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                Icons.add,
                color: AppTheme.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: 打开通知页面
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Badge(
                smallSize: 8,
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选标签
  Widget _buildFilterTabs() {
    final currentFilter = ref.watch(postsFilterProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      child: Row(
        children: PostsFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return GestureDetector(
            onTap: () {
              ref.read(postsProvider.notifier).switchFilter(filter);
            },
            child: Container(
              margin: const EdgeInsets.only(right: AppTheme.spaceMd),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceLg,
                vertical: AppTheme.spaceSm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                boxShadow: isSelected ? AppTheme.shadowSm : null,
              ),
              child: Text(
                filter.displayName,
                style: AppTheme.labelLarge.copyWith(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(AppTheme.spaceLg),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 构建无更多数据指示器
  Widget _buildNoMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Center(
        child: Text(
          '已经到底了',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }
}

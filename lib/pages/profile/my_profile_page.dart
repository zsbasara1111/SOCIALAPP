import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_image.dart';
import '../../presentation/providers/posts_provider.dart';
import '../../presentation/providers/profile_stats_provider.dart';
import '../../presentation/providers/vip_provider.dart';
import '../../presentation/widgets/posts/post_card.dart';

/// 我的页面
class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVip = ref.watch(isVipProvider);
    final stats = ref.watch(profileStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 顶部用户信息区域
            SliverToBoxAdapter(
              child: Container(
                color: AppTheme.surface,
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceLg,
                  AppTheme.space2Xl,
                  AppTheme.spaceLg,
                  AppTheme.spaceLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 设置按钮（右上角）
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.goSettings(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: AppTheme.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spaceMd),

                    // 头像 + 用户名 + VIP 状态
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 头像（点击进入照片墙）
                        GestureDetector(
                          onTap: () => context.goMyPhotos(),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primary.withValues(alpha: 0.8),
                                  AppTheme.accent.withValues(alpha: 0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: AppImage(
                                imagePath: 'assets/images/avatars/male_05.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceMd),
                        // 用户名 + VIP
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '我的昵称',
                                  style:
                                      AppTheme.headlineSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // VIP 徽章
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.vipGradient,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusSm,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.workspace_premium,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'VIP',
                                        style: AppTheme.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spaceSm),

                    // 编辑资料按钮
                    GestureDetector(
                      onTap: () => context.goEditProfile(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceMd,
                          vertical: AppTheme.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          '编辑资料',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spaceLg),

                    // 统计数字行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          value: formatCompactNumber(stats.likedUsersCount),
                          label: '喜欢的人',
                          onTap: () => context.goLikedUsers(),
                        ),
                        _buildStatItem(
                          value: formatCompactNumber(stats.visitorsCount),
                          label: '看过我的人',
                          hasDot: stats.visitorsCount > 0,
                          onTap: () => context.goVisitors(),
                        ),
                        _buildStatItem(
                          value: formatCompactNumber(stats.whoLikedMeCount),
                          label: '谁喜欢我',
                          hasDot: stats.whoLikedMeCount > 0,
                          isLocked: !isVip,
                          onTap: () {
                            if (!isVip) {
                              _showVipRequiredDialog();
                            } else {
                              context.goWhoLikedMe();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spaceLg),

                    // VIP 推广卡片（紧凑版）
                    _buildCompactVipCard(),
                  ],
                ),
              ),
            ),

            // TabBar（吸顶）
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMyPostsTab(),
            _buildLikedPostsTab(),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem({
    required String value,
    required String label,
    bool hasDot = false,
    bool isLocked = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasDot)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 4, bottom: 8),
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 2),
                Icon(
                  Icons.lock,
                  size: 10,
                  color: AppTheme.textTertiary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// 构建紧凑版 VIP 卡片
  Widget _buildCompactVipCard() {
    return GestureDetector(
      onTap: () => context.goVipCenter(),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          gradient: AppTheme.vipGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部：我的特权 + 箭头
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '我的特权',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceMd),
            // 中部：价格 + 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'VIP 首季 68 元',
                          style: AppTheme.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Text(
                            '立减16元',
                            style: AppTheme.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '22.7元/月解锁9项高级特权',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                // 立即开通按钮
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceLg,
                    vertical: AppTheme.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_open,
                        size: 14,
                        color: AppTheme.vipGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '立即开通',
                        style: AppTheme.labelLarge.copyWith(
                          color: AppTheme.vipGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建"动态"标签页（我发过的动态）
  Widget _buildMyPostsTab() {
    final postsState = ref.watch(postsProvider);
    // 只显示当前用户发布的动态
    final myPosts = postsState.posts
        .where((p) => p.userId == 'currentUser')
        .toList();

    if (myPosts.isEmpty) {
      return _buildEmptyTab('还没有发布过动态');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: AppTheme.spaceMd),
      itemCount: myPosts.length,
      itemBuilder: (context, index) {
        final post = myPosts[index];
        return PostCard(
          post: post,
          onLike: () {
            ref.read(postsProvider.notifier).toggleLike(post.id);
          },
        );
      },
    );
  }

  /// 构建"喜欢"标签页（我点赞过的动态）
  Widget _buildLikedPostsTab() {
    final postsState = ref.watch(postsProvider);
    final likedPosts = postsState.posts.where((p) => p.isLiked).toList();

    if (likedPosts.isEmpty) {
      return _buildEmptyTab('还没有赞过动态');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: AppTheme.spaceMd),
      itemCount: likedPosts.length,
      itemBuilder: (context, index) {
        final post = likedPosts[index];
        return PostCard(
          post: post,
          onLike: () {
            ref.read(postsProvider.notifier).toggleLike(post.id);
          },
        );
      },
    );
  }

  /// 构建空标签页状态
  Widget _buildEmptyTab(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 56,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            message,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示 VIP 专属提示弹窗
  void _showVipRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          title: Text(
            '高级会员专享',
            style: AppTheme.headlineSmall,
          ),
          content: Text(
            '查看"谁喜欢我"需要开通 VIP 会员，立即升级解锁更多特权！',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '取消',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.goVipCenter();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('去开通'),
            ),
          ],
        );
      },
    );
  }
}

/// TabBar 的 SliverPersistentHeader 代理
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _TabBarDelegate({required this.tabController});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppTheme.surface,
      child: TabBar(
        controller: tabController,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textTertiary,
        indicatorColor: AppTheme.primary,
        indicatorWeight: 3,
        labelStyle: AppTheme.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.bodyLarge.copyWith(
          color: AppTheme.textTertiary,
        ),
        tabs: const [
          Tab(text: '动态'),
          Tab(text: '喜欢'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

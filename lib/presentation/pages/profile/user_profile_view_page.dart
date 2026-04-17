import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';

/// 用户资料查看页面
/// 展示对方的基本信息、爱好库和共同爱好
class UserProfileViewPage extends StatelessWidget {
  final String userId;
  final String userName;
  final String? avatar;
  final int? age;
  final String? city;
  final String? bio;
  final List<UserHobbyItem> userHobbies;
  final List<UserHobbyItem> myHobbies;

  const UserProfileViewPage({
    super.key,
    required this.userId,
    required this.userName,
    this.avatar,
    this.age,
    this.city,
    this.bio,
    this.userHobbies = const [],
    this.myHobbies = const [],
  });

  @override
  Widget build(BuildContext context) {
    // 计算共同爱好（按作品名称匹配）
    final myHobbyNames = myHobbies.map((h) => h.itemName).toSet();
    final commonHobbies = userHobbies
        .where((h) => myHobbyNames.contains(h.itemName))
        .toList();

    // 按分类ID分组对方的爱好
    final Map<String, List<String>> hobbiesByCategory = {};
    for (final hobby in userHobbies) {
      hobbiesByCategory.putIfAbsent(hobby.categoryId, () => []);
      if (!hobbiesByCategory[hobby.categoryId]!.contains(hobby.itemName)) {
        hobbiesByCategory[hobby.categoryId]!.add(hobby.itemName);
      }
    }

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
          '个人资料',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息卡片
              _buildProfileCard(),

              const SizedBox(height: AppTheme.spaceXl),

              // 共同爱好
              if (commonHobbies.isNotEmpty) ...[
                _buildSectionTitle('共同爱好', Icons.favorite, AppTheme.error),
                const SizedBox(height: AppTheme.spaceMd),
                _buildCommonHobbies(commonHobbies),
                const SizedBox(height: AppTheme.spaceXl),
              ],

              // 对方爱好库
              _buildSectionTitle('爱好库', Icons.auto_awesome, AppTheme.primary),
              const SizedBox(height: AppTheme.spaceMd),
              if (hobbiesByCategory.isEmpty)
                _buildEmptyHobbies()
              else
                _buildHobbyLibrary(hobbiesByCategory),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建个人资料卡片
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(0.15),
            AppTheme.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Column(
        children: [
          // 头像
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withOpacity(0.8),
                  AppTheme.accent.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: avatar != null
                ? ClipOval(
                    child: Image.network(
                      avatar!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      userName.substring(0, 1),
                      style: AppTheme.displayMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          // 昵称
          Text(
            userName,
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          // 年龄和城市
          if (age != null || city != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (age != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      '$age岁',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                ],
                if (city != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      city!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppTheme.spaceMd),
          // 签名
          if (bio != null && bio!.isNotEmpty)
            Text(
              bio!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  /// 构建区域标题
  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spaceSm),
        Text(
          title,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// 构建共同爱好
  Widget _buildCommonHobbies(List<UserHobbyItem> commonHobbies) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppTheme.error.withOpacity(0.2),
        ),
      ),
      child: Wrap(
        spacing: AppTheme.spaceSm,
        runSpacing: AppTheme.spaceSm,
        children: commonHobbies.map((hobby) {
          final category = HobbyCategories.getById(hobby.categoryId);
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMd,
              vertical: AppTheme.spaceSm,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFF8E53),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category?.icon ?? Icons.favorite,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  hobby.itemName,
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建空爱好状态
  Widget _buildEmptyHobbies() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceXl),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            color: AppTheme.textTertiary,
            size: 48,
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            'TA还没有添加爱好',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建爱好库
  Widget _buildHobbyLibrary(Map<String, List<String>> hobbiesByCategory) {
    return Column(
      children: hobbiesByCategory.entries.map((entry) {
        final category = HobbyCategories.getById(entry.key);
        final items = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类标题
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (category?.color ?? AppTheme.primary).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(
                      category?.icon ?? Icons.help_outline,
                      color: category?.color ?? AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  Text(
                    category?.name ?? '其他',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMd),
              // 作品列表
              Wrap(
                spacing: AppTheme.spaceSm,
                runSpacing: AppTheme.spaceSm,
                children: items.map((item) {
                  // 判断是否也是我的爱好
                  final isCommon = myHobbies.any(
                    (h) => h.itemName == item,
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceMd,
                      vertical: AppTheme.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: isCommon
                          ? AppTheme.error.withOpacity(0.1)
                          : (category?.color ?? AppTheme.primary).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: isCommon
                            ? AppTheme.error.withOpacity(0.3)
                            : (category?.color ?? AppTheme.primary).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item,
                          style: AppTheme.bodyMedium.copyWith(
                            color: isCommon
                                ? AppTheme.error
                                : (category?.color ?? AppTheme.primary),
                            fontWeight: isCommon ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (isCommon) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.favorite,
                            size: 12,
                            color: AppTheme.error,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

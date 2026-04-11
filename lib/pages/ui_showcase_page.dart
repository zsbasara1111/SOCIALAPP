import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// UI 方案展示页面
/// 展示 10 种不同的 UI 设计风格供用户选择
class UIShowcasePage extends StatefulWidget {
  const UIShowcasePage({super.key});

  @override
  State<UIShowcasePage> createState() => _UIShowcasePageState();
}

class _UIShowcasePageState extends State<UIShowcasePage> {
  int _selectedOption = 0;

  // 10 个 UI 方案配置
  final List<UIOption> _options = [
    UIOption(
      name: 'A. 极简主义白',
      description: '纯白背景，极致简洁，大量留白，呼吸感强',
      primaryColor: const Color(0xFF1A1A1A),
      backgroundColor: const Color(0xFFFFFFFF),
      accentColor: const Color(0xFF4A4A4A),
    ),
    UIOption(
      name: 'B. 深色科技感',
      description: '深黑背景，霓虹蓝绿点缀，玻璃态效果',
      primaryColor: const Color(0xFF00D4FF),
      backgroundColor: const Color(0xFF0A0A0F),
      accentColor: const Color(0xFF00FF88),
    ),
    UIOption(
      name: 'C. 奶油甜心风',
      description: '奶油白底色，珊瑚粉主调，甜美柔和',
      primaryColor: const Color(0xFFFF9AA2),
      backgroundColor: const Color(0xFFFFF9F5),
      accentColor: const Color(0xFFA2E1D8),
    ),
    UIOption(
      name: 'D. 新中式典雅',
      description: '宣纸米黄底色，朱砂红点缀，山水意境',
      primaryColor: const Color(0xFFC73E3A),
      backgroundColor: const Color(0xFFFAF5E6),
      accentColor: const Color(0xFFD4AF37),
    ),
    UIOption(
      name: 'E. 活力运动风',
      description: '鲜艳橙色主调，动感斜切，能量感十足',
      primaryColor: const Color(0xFFFF6B35),
      backgroundColor: const Color(0xFFFFFFFF),
      accentColor: const Color(0xFF00D9FF),
    ),
    UIOption(
      name: 'F. 赛博朋克霓虹',
      description: '深紫黑背景，霓虹粉紫渐变，未来都市感',
      primaryColor: const Color(0xFFFF00FF),
      backgroundColor: const Color(0xFF0D001A),
      accentColor: const Color(0xFF00FFFF),
    ),
    UIOption(
      name: 'G. 手绘插画风',
      description: '温暖米色背景，手绘线条，亲切可爱',
      primaryColor: const Color(0xFFFF8C42),
      backgroundColor: const Color(0xFFFDF6E3),
      accentColor: const Color(0xFF7CB342),
    ),
    UIOption(
      name: 'H. 轻奢莫兰迪',
      description: '低饱和度色系，高级灰调，优雅柔和',
      primaryColor: const Color(0xFFB5838D),
      backgroundColor: const Color(0xFFF5F0EB),
      accentColor: const Color(0xFF8A9A8C),
    ),
    UIOption(
      name: 'I. 复古胶片风',
      description: '胶片质感暖色，怀旧复古，经典电影感',
      primaryColor: const Color(0xFF8B6914),
      backgroundColor: const Color(0xFFE8DCC4),
      accentColor: const Color(0xFFC75B39),
    ),
    UIOption(
      name: 'J. 清新森系风',
      description: '森林绿主调，自然清新，氧气感设计',
      primaryColor: const Color(0xFF2D6A4F),
      backgroundColor: const Color(0xFFF1F8F4),
      accentColor: const Color(0xFF95D5B2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('UI 风格选择'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 顶部说明
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            color: AppTheme.surface,
            child: Column(
              children: [
                Text(
                  '选择你喜欢的 UI 风格',
                  style: AppTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Text(
                  '点击下方方案查看预览效果，选择最符合你审美的风格',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // 方案列表
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = _selectedOption == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? option.primaryColor.withOpacity(0.1)
                          : AppTheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? option.primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: option.primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        // 颜色预览
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                option.primaryColor,
                                option.accentColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMd),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceLg),

                        // 文字信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.name,
                                style: AppTheme.titleLarge.copyWith(
                                  color: isSelected
                                      ? option.primaryColor
                                      : AppTheme.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spaceXs),
                              Text(
                                option.description,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 选中标记
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: option.primaryColor,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 预览区域
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(AppTheme.spaceLg),
              decoration: BoxDecoration(
                color: _options[_selectedOption].backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.shadowLg,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                child: _buildPreview(_options[_selectedOption]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建预览界面
  Widget _buildPreview(UIOption option) {
    final isDark = option.backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF666666);

    return Column(
      children: [
        // 模拟 AppBar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          color: option.backgroundColor.withOpacity(0.8),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: textColor),
                const SizedBox(width: 16),
                Text(
                  '发现',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: option.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline,
                          size: 16, color: option.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '同好匹配',
                        style: TextStyle(
                          fontSize: 12,
                          color: option.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 模拟匹配卡片
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 卡片
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 照片区域
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  option.accentColor.withOpacity(0.3),
                                  option.primaryColor.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: option.primaryColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),

                        // 信息区域
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '小雅',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: option.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '匹配值 8',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: option.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '21岁 · 北京',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: ['周杰伦', '《三体》', '原神']
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: option.accentColor
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? option.accentColor
                                                : const Color(0xFF666666),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 操作按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.close,
                      color: isDark ? Colors.white70 : Colors.grey,
                      size: 56,
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      icon: Icons.favorite,
                      color: Colors.red,
                      size: 56,
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      icon: Icons.favorite,
                      color: option.primaryColor,
                      size: 64,
                      isMain: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    bool isMain = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isMain ? color : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: isMain ? Colors.white : color,
        size: size * 0.4,
      ),
    );
  }
}

/// UI 方案数据类
class UIOption {
  final String name;
  final String description;
  final Color primaryColor;
  final Color backgroundColor;
  final Color accentColor;

  UIOption({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
    required this.accentColor,
  });
}

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/impeccable_options/option_01_dawn.dart';
import '../core/theme/impeccable_options/option_02_midnight.dart';
import '../core/theme/impeccable_options/option_03_urban.dart';
import '../core/theme/impeccable_options/option_04_botanical.dart';
import '../core/theme/impeccable_options/option_05_gallery.dart';

/// Impeccable 设计 - 5个独特UI方案展示
///
/// 使用impeccable skill设计的5个非模板化方案
class ImpeccableShowcasePage extends StatefulWidget {
  const ImpeccableShowcasePage({super.key});

  @override
  State<ImpeccableShowcasePage> createState() => _ImpeccableShowcasePageState();
}

class _ImpeccableShowcasePageState extends State<ImpeccableShowcasePage> {
  int _selectedOption = 0;
  bool _isDarkMode = false;

  // 5个方案配置
  final List<ImpeccableOption> _options = [
    ImpeccableOption(
      name: '晨曦微光',
      subtitle: 'Dawn Glow',
      description: '日出时分的温暖色调，象征新的开始和期待。温柔的金橘渐变，如同清晨第一缕阳光。',
      emotion: '期待感 · 温暖 · 希望',
      lightTheme: DawnGlowTheme.lightTheme,
      darkTheme: DawnGlowTheme.darkTheme,
      primaryColor: DawnGlowTheme.primary,
      accentColor: DawnGlowTheme.accent,
      fonts: 'Raleway + Cabin',
    ),
    ImpeccableOption(
      name: '深夜咖啡馆',
      subtitle: 'Midnight Café',
      description: '深夜独自坐在咖啡馆的氛围，暖黄的灯光在深暗背景中显得温馨。适合睡前使用的舒适暗色。',
      emotion: '安心感 · 被理解 · 深夜的慰藉',
      lightTheme: MidnightCafeTheme.lightTheme,
      darkTheme: MidnightCafeTheme.darkTheme,
      primaryColor: MidnightCafeTheme.primary,
      accentColor: MidnightCafeTheme.accent,
      fonts: 'Merriweather + Source Sans 3',
    ),
    ImpeccableOption(
      name: '都市探险家',
      subtitle: 'Urban Explorer',
      description: '现代都市的几何美学，建筑的线条与色块。探索城市的未知角落，充满活力但保持克制。',
      emotion: '探索感 · 活力 · 现代感',
      lightTheme: UrbanExplorerTheme.lightTheme,
      darkTheme: UrbanExplorerTheme.darkTheme,
      primaryColor: UrbanExplorerTheme.primary,
      accentColor: UrbanExplorerTheme.accent,
      fonts: 'Space Grotesk + Work Sans',
    ),
    ImpeccableOption(
      name: '植物园漫步',
      subtitle: 'Botanical Garden',
      description: '走进温室植物园的感觉，湿润、清新、充满生机。自然有机的形态，随性但有生命力。',
      emotion: '自然 · 随性 · 生命力',
      lightTheme: BotanicalGardenTheme.lightTheme,
      darkTheme: BotanicalGardenTheme.darkTheme,
      primaryColor: BotanicalGardenTheme.primary,
      accentColor: BotanicalGardenTheme.accent,
      fonts: 'Cormorant Garamond + Nunito',
    ),
    ImpeccableOption(
      name: '私人画廊',
      subtitle: 'Private Gallery',
      description: '走进私人艺术收藏馆的感觉，大面积的留白，作品是主角。克制但精致的细节，每件展品都值得细细品味。',
      emotion: '高级感 · 品味 · 独特',
      lightTheme: PrivateGalleryTheme.lightTheme,
      darkTheme: PrivateGalleryTheme.darkTheme,
      primaryColor: PrivateGalleryTheme.primary,
      accentColor: PrivateGalleryTheme.accent,
      fonts: 'Playfair Display + Lora',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentOption = _options[_selectedOption];
    final currentTheme = _isDarkMode ? currentOption.darkTheme : currentOption.lightTheme;

    return Theme(
      data: currentTheme,
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'Impeccable Design',
                style: currentTheme.textTheme.titleLarge,
              ),
              Text(
                '选择你的风格',
                style: currentTheme.textTheme.bodySmall?.copyWith(
                  color: _isDarkMode
                    ? currentTheme.colorScheme.onSurface.withOpacity(0.6)
                    : currentTheme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            // 暗黑模式切换
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // 方案选择器
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? option.primaryColor.withOpacity(0.15)
                            : currentTheme.cardTheme.color?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? option.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 颜色预览
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  option.primaryColor,
                                  option.accentColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            option.name.substring(0, 2),
                            style: currentTheme.textTheme.labelSmall?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? option.primaryColor
                                  : currentTheme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 方案详情
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 方案标题
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentOption.name,
                                style: currentTheme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentOption.subtitle,
                                style: currentTheme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 选中标记
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: currentOption.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: currentOption.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '方案 ${_selectedOption + 1}/5',
                                style: currentTheme.textTheme.labelSmall?.copyWith(
                                  color: currentOption.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 描述
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: currentTheme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentOption.description,
                            style: currentTheme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          // 情感标签
                          Wrap(
                            spacing: 8,
                            children: currentOption.emotion
                                .split(' · ')
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: currentOption.accentColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: currentTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: currentOption.accentColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 字体信息
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: currentTheme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.font_download_outlined,
                            color: currentOption.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '字体搭配',
                                  style: currentTheme.textTheme.labelSmall,
                                ),
                                Text(
                                  currentOption.fonts,
                                  style: currentTheme.textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 预览区域标题
                    Text(
                      '界面预览',
                      style: currentTheme.textTheme.titleLarge,
                    ),

                    const SizedBox(height: 12),

                    // 模拟界面预览
                    _buildPreview(currentOption, currentTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(ImpeccableOption option, ThemeData theme) {
    final isDark = _isDarkMode;
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = isDark
        ? textColor.withOpacity(0.7)
        : textColor.withOpacity(0.6);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // 模拟 AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.8),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: textColor, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '发现',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: option.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 14,
                            color: option.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '同好匹配',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: option.primaryColor,
                              fontSize: 11,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
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
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person_outline,
                              size: 64,
                              color: option.primaryColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),

                      // 信息区域
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '小雅',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: option.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '匹配值 8',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: option.primaryColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '21岁 · 北京',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              children: ['周杰伦', '《三体》', '原神']
                                  .map(
                                    (tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: option.accentColor
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        tag,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 10,
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
            ),

            // 操作按钮
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.close,
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: Colors.red.shade400,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: option.primaryColor,
                    size: 56,
                    isMain: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            blurRadius: 8,
            offset: const Offset(0, 2),
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

/// Impeccable 方案数据类
class ImpeccableOption {
  final String name;
  final String subtitle;
  final String description;
  final String emotion;
  final String fonts;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final Color primaryColor;
  final Color accentColor;

  ImpeccableOption({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.emotion,
    required this.fonts,
    required this.lightTheme,
    required this.darkTheme,
    required this.primaryColor,
    required this.accentColor,
  });
}

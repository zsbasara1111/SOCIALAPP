import 'package:flutter/material.dart';
import '../core/theme/previews/theme_a_minimal.dart';
import '../core/theme/previews/theme_b_dark_tech.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/previews/theme_d_chinese.dart';
import '../core/theme/previews/theme_e_sporty.dart';
import '../core/theme/previews/theme_f_cyberpunk.dart';
import '../core/theme/previews/theme_g_handdrawn.dart';

/// UI方案预览入口页面
class UIPreviewPage extends StatefulWidget {
  const UIPreviewPage({super.key});

  @override
  State<UIPreviewPage> createState() => _UIPreviewPageState();
}

class _UIPreviewPageState extends State<UIPreviewPage> {
  int _selectedIndex = 0;

  final List<_ThemeOption> _themes = [
    _ThemeOption(
      name: 'A. 极简主义白',
      description: '纯白背景、细边框、大量留白、无装饰',
      theme: MinimalTheme.theme,
      colors: const [Colors.white, Colors.black],
    ),
    _ThemeOption(
      name: 'B. 深色科技感',
      description: '深色背景、霓虹色、毛玻璃效果',
      theme: DarkTechTheme.theme,
      colors: const [Color(0xFF0A0A0F), Color(0xFF00D4AA)],
    ),
    _ThemeOption(
      name: 'C. 奶油甜心风',
      description: '珊瑚粉、圆角、柔和阴影',
      theme: AppTheme.lightTheme,
      colors: const [Color(0xFFFFF9F5), Color(0xFFFF9AA2)],
    ),
    _ThemeOption(
      name: 'D. 新中式典雅',
      description: '宣纸色、墨黑、中式元素、印章效果',
      theme: ChineseElegantTheme.theme,
      colors: const [Color(0xFFF5F0E8), Color(0xFF8B1A1A)],
    ),
    _ThemeOption(
      name: 'E. 活力运动风',
      description: '高饱和色、粗体、动感斜角',
      theme: SportyTheme.theme,
      colors: const [Colors.white, Color(0xFFFF3B30)],
    ),
    _ThemeOption(
      name: 'F. 赛博朋克霓虹',
      description: '黑底、霓虹渐变、网格背景',
      theme: CyberpunkTheme.theme,
      colors: const [Color(0xFF050508), Color(0xFFFF10F0)],
    ),
    _ThemeOption(
      name: 'G. 手绘插画风',
      description: '不规则边框、手写体、蜡笔色彩',
      theme: HandDrawnTheme.theme,
      colors: const [Color(0xFFFEFCF7), Color(0xFFFF6B6B)],
    ),
  ];

  void _showPreview(int index) {
    setState(() => _selectedIndex = index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ThemePreviewPage(
          themeOption: _themes[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('UI方案预览'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _themes.length,
        itemBuilder: (context, index) {
          final theme = _themes[index];
          return _buildThemeCard(theme, index);
        },
      ),
    );
  }

  Widget _buildThemeCard(_ThemeOption theme, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showPreview(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 颜色预览
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: theme.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.grey[300]!),
                ),
              ),
              const SizedBox(width: 16),
              // 文字信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // 箭头
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// 主题预览详情页
class _ThemePreviewPage extends StatelessWidget {
  final _ThemeOption themeOption;

  const _ThemePreviewPage({required this.themeOption});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeOption.theme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return Scaffold(
            appBar: AppBar(
              title: Text(themeOption.name),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 颜色展示
                  _buildSection('色彩系统'),
                  _buildColorPalette(colorScheme),
                  const SizedBox(height: 24),

                  // 按钮展示
                  _buildSection('按钮组件'),
                  _buildButtons(context),
                  const SizedBox(height: 24),

                  // 卡片展示
                  _buildSection('卡片组件'),
                  _buildCards(context),
                  const SizedBox(height: 24),

                  // 文字展示
                  _buildSection('字体系统'),
                  _buildTypography(context),
                  const SizedBox(height: 32),

                  // 选择按钮
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // 返回并传递选择结果
                        Navigator.pop(context, themeOption.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('已选择: ${themeOption.name}'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('选择此方案'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildColorPalette(ColorScheme colorScheme) {
    final colors = [
      ('Primary', colorScheme.primary),
      ('Surface', colorScheme.surface),
      ('Background', colorScheme.background),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        return Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.$2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              color.$1,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('主要按钮'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          child: const Text('次要按钮'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('文字按钮'),
        ),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '用户昵称',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '2分钟前',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '这是一条示例动态内容，展示卡片的样式和排版效果。',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypography(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标题文字', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('正文内容', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text('次要文字', style: theme.textTheme.bodySmall),
      ],
    );
  }
}

/// 主题选项数据
class _ThemeOption {
  final String name;
  final String description;
  final ThemeData theme;
  final List<Color> colors;

  _ThemeOption({
    required this.name,
    required this.description,
    required this.theme,
    required this.colors,
  });
}

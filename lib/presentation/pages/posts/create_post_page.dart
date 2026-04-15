import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/posts_provider.dart';

/// 发布动态页面
class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      ref.read(createPostProvider.notifier).setContent(_contentController.text);
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createPostProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '发布动态',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: createState.canPost && !createState.isPosting
                ? () async {
                    final success =
                        await ref.read(createPostProvider.notifier).post();
                    if (success && mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('发布成功！')),
                      );
                    }
                  }
                : null,
            child: createState.isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    '发布',
                    style: AppTheme.labelLarge.copyWith(
                      color: createState.canPost
                          ? AppTheme.primary
                          : AppTheme.textTertiary,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 内容输入
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: '分享你的想法、喜欢的作品...',
                      hintStyle: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      border: InputBorder.none,
                      counterStyle: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    style: AppTheme.bodyLarge,
                  ),

                  const SizedBox(height: AppTheme.spaceLg),

                  // 图片预览
                  if (createState.selectedImages.isNotEmpty)
                    _buildImagePreview(createState),
                ],
              ),
            ),
          ),

          // 底部工具栏
          _buildBottomBar(createState),
        ],
      ),
    );
  }

  /// 构建图片预览
  Widget _buildImagePreview(CreatePostState state) {
    return Wrap(
      spacing: AppTheme.spaceSm,
      runSpacing: AppTheme.spaceSm,
      children: [
        ...state.selectedImages.asMap().entries.map((entry) {
          return _buildImageItem(entry.value, entry.key);
        }),
        if (state.canAddImage) _buildAddImageButton(),
      ],
    );
  }

  /// 构建单个图片项
  Widget _buildImageItem(String path, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            width: 100,
            height: 100,
            color: AppTheme.surfaceVariant,
            child: Icon(
              Icons.image,
              color: AppTheme.textTertiary,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              ref.read(createPostProvider.notifier).removeImage(index);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建添加图片按钮
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // TODO: 打开图片选择器
        _showImagePickerSheet();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: AppTheme.surfaceVariant,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              '添加图片',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部工具栏
  Widget _buildBottomBar(CreatePostState state) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.surfaceVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 图片按钮
            IconButton(
              onPressed: state.canAddImage ? () => _showImagePickerSheet() : null,
              icon: Icon(
                Icons.image_outlined,
                color: state.canAddImage
                    ? AppTheme.textSecondary
                    : AppTheme.textTertiary,
              ),
            ),

            // 话题按钮
            IconButton(
              onPressed: () {
                // TODO: 插入话题
              },
              icon: Icon(
                Icons.tag,
                color: AppTheme.textSecondary,
              ),
            ),

            // 表情按钮
            IconButton(
              onPressed: () {
                // TODO: 打开表情面板
              },
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: AppTheme.textSecondary,
              ),
            ),

            const Spacer(),

            // 位置
            GestureDetector(
              onTap: () {
                // TODO: 选择位置
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '添加位置',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示图片选择器底部弹窗
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            _buildPickerOption(
              icon: Icons.camera_alt,
              title: '拍照',
              onTap: () {
                Navigator.of(context).pop();
                // TODO: 拍照
              },
            ),
            const SizedBox(height: AppTheme.spaceMd),
            _buildPickerOption(
              icon: Icons.photo_library,
              title: '从相册选择',
              onTap: () {
                Navigator.of(context).pop();
                // TODO: 从相册选择
                // 模拟添加图片
                ref.read(createPostProvider.notifier).addImage('mock_path');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),
            Text(
              title,
              style: AppTheme.titleMedium,
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

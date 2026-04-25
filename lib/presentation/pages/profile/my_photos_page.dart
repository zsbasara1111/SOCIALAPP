import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';

/// 我的照片墙页面
class MyPhotosPage extends StatelessWidget {
  const MyPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 从服务器加载真实照片数据
    final photos = <String>[];

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
          '我的照片墙',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: 上传照片
            },
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
      body: photos.isEmpty
          ? _buildEmptyState(context)
          : GridView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppTheme.spaceSm,
                mainAxisSpacing: AppTheme.spaceSm,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: AppImage(
                    imagePath: photos[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Text(
            '照片墙还是空的',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '点击右上角添加照片，最多可上传9张',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXl),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: 上传照片
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('添加照片'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceXl,
                vertical: AppTheme.spaceMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

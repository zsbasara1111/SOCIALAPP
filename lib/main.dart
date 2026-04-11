import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/supabase_provider.dart';
import 'core/theme/app_theme.dart';
import 'pages/ui_preview_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Supabase (带有错误处理)
  try {
    await initializeSupabase();
  } catch (e) {
    debugPrint('Warning: Supabase initialization failed: $e');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI方案预览',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const UIPreviewPage(),
    );
  }
}

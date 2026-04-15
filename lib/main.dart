import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/providers/supabase_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web 平台使用 Path URL 策略，支持直接访问子路由
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  // 初始化 Supabase (带有错误处理)
  try {
    await initializeSupabase();
  } catch (e) {
    // 如果 Supabase 未配置，打印警告但继续运行
    // 这样可以在没有后端的情况下预览UI
    debugPrint('Warning: Supabase initialization failed: $e');
    debugPrint('Please configure Supabase credentials in lib/core/config/supabase_config.dart');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '社交App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

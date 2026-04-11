import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Supabase 客户端 Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// 当前用户 Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange
      .map((event) => event.session?.user)
      .distinct();
});

/// 当前用户ID Provider
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  return user?.id;
});

/// 用户认证状态 Provider
final authStateProvider = Provider<AuthState?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  // 返回当前会话状态
  return null; // 需要监听时单独处理
});

/// 初始化 Supabase
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    debug: true, // 开发时启用调试
  );
}

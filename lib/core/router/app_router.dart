import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../pages/design_showcase_page.dart';
import '../../pages/ui_showcase_page.dart';
import '../../pages/impeccable_showcase_page.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/auth/phone_verification_page.dart';
import '../../pages/profile/profile_setup_page.dart';
import '../../presentation/pages/match/match_page.dart';
import '../../presentation/pages/posts/posts_page.dart';
import '../../presentation/pages/chat/chat_list_page.dart';
import '../../pages/profile/my_profile_page.dart';
import '../../pages/main/main_scaffold.dart';
import '../../presentation/pages/vip/vip_center_page.dart';
import '../../presentation/pages/hobby/hobby_selection_page.dart';
import '../../presentation/pages/hobby/hobby_showcase_page.dart';
import '../../presentation/pages/profile/profile_hobbies_page.dart';
import '../../presentation/pages/posts/create_post_page.dart';

/// 路由名称常量
class RouteNames {
  static const String impeccableShowcase = 'impeccable-showcase';
  static const String uiShowcase = 'ui-showcase';
  static const String showcase = 'showcase';
  static const String login = 'login';
  static const String register = 'register';
  static const String phoneVerify = 'phone-verify';
  static const String profileSetup = 'profile-setup';
  static const String main = 'main';
  static const String match = 'match';
  static const String posts = 'posts';
  static const String chat = 'chat';
  static const String profile = 'profile';
  static const String vipCenter = 'vip-center';
  static const String hobbySelection = 'hobby-selection';
  static const String profileHobbies = 'profile-hobbies';
  static const String hobbyShowcase = 'hobby-showcase';
  static const String createPost = 'create-post';
}

/// 路由路径常量
class RoutePaths {
  static const String impeccableShowcase = '/impeccable';
  static const String uiShowcase = '/ui-showcase';
  static const String showcase = '/showcase';
  static const String login = '/login';
  static const String register = '/register';
  static const String phoneVerify = '/phone-verify';
  static const String profileSetup = '/profile-setup';
  static const String main = '/';
  static const String match = '/match';
  static const String posts = '/posts';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String vipCenter = '/vip-center';
  static const String hobbySelection = '/hobby-selection';
  static const String profileHobbies = '/profile-hobbies';
  static const String hobbyShowcase = '/hobby-showcase';
  static const String createPost = '/create-post';
}

/// 路由状态
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.main,
    debugLogDiagnostics: true,
    routes: [
      // Impeccable 风格选择页面
      GoRoute(
        path: RoutePaths.impeccableShowcase,
        name: RouteNames.impeccableShowcase,
        builder: (context, state) => const ImpeccableShowcasePage(),
      ),

      // UI 风格选择页面 (旧版10个方案)
      GoRoute(
        path: RoutePaths.uiShowcase,
        name: RouteNames.uiShowcase,
        builder: (context, state) => const UIShowcasePage(),
      ),

      // 设计展示页面
      GoRoute(
        path: RoutePaths.showcase,
        name: RouteNames.showcase,
        builder: (context, state) => const DesignShowcasePage(),
      ),

      // 认证相关
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutePaths.phoneVerify,
        name: RouteNames.phoneVerify,
        builder: (context, state) {
          final phone = state.extra as String?;
          return PhoneVerificationPage(phone: phone ?? '');
        },
      ),
      GoRoute(
        path: RoutePaths.profileSetup,
        name: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),

      // VIP中心
      GoRoute(
        path: RoutePaths.vipCenter,
        name: RouteNames.vipCenter,
        builder: (context, state) => const VipCenterPage(),
      ),

      // 发布动态
      GoRoute(
        path: RoutePaths.createPost,
        name: RouteNames.createPost,
        builder: (context, state) => const CreatePostPage(),
      ),

      // 爱好系统展示页面
      GoRoute(
        path: RoutePaths.hobbyShowcase,
        name: RouteNames.hobbyShowcase,
        builder: (context, state) => const HobbyShowcasePage(),
      ),

      // 爱好选择页面
      GoRoute(
        path: RoutePaths.hobbySelection,
        name: RouteNames.hobbySelection,
        builder: (context, state) => HobbySelectionPage(
          onNext: () => context.goProfileSetup(),
          onSkip: () => context.goProfileSetup(),
        ),
      ),

      // 个人资料爱好管理
      GoRoute(
        path: RoutePaths.profileHobbies,
        name: RouteNames.profileHobbies,
        builder: (context, state) => const ProfileHobbiesPage(),
      ),

      // 主页面 (带底部导航)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 匹配
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.main,
                name: RouteNames.main,
                builder: (context, state) => const MatchPage(),
              ),
            ],
          ),
          // 动态
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.posts,
                name: RouteNames.posts,
                builder: (context, state) => const PostsPage(),
              ),
            ],
          ),
          // 发布 (中间按钮，点击后弹出)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/publish-placeholder',
                builder: (context, state) => const SizedBox.shrink(),
              ),
            ],
          ),
          // 消息
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.chat,
                name: RouteNames.chat,
                builder: (context, state) => const ChatListPage(),
              ),
            ],
          ),
          // 我的
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const MyProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],

    // 错误页面
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('页面不存在: ${state.error}'),
      ),
    ),
  );
});

/// 路由扩展方法
extension GoRouterExtension on BuildContext {
  /// 前往Impeccable风格选择页
  void goImpeccableShowcase() => go(RoutePaths.impeccableShowcase);

  /// 前往UI风格选择页
  void goUIShowcase() => go(RoutePaths.uiShowcase);

  /// 前往设计展示页
  void goDesignShowcase() => go(RoutePaths.showcase);

  /// 前往登录页
  void goLogin() => go(RoutePaths.login);

  /// 前往注册页
  void goRegister() => go(RoutePaths.register);

  /// 前往手机验证
  void goPhoneVerify(String phone) => go(
        RoutePaths.phoneVerify,
        extra: phone,
      );

  /// 前往资料完善
  void goProfileSetup() => go(RoutePaths.profileSetup);

  /// 前往主页
  void goMain() => go(RoutePaths.main);

  /// 前往VIP中心
  void goVipCenter() => push(RoutePaths.vipCenter);

  /// 前往发布动态页面
  void goCreatePost() => push(RoutePaths.createPost);

  /// 前往爱好选择页面
  void goHobbySelection() => push(RoutePaths.hobbySelection);

  /// 前往爱好系统展示页面
  void goHobbyShowcase() => push(RoutePaths.hobbyShowcase);

  /// 前往个人资料爱好管理
  void goProfileHobbies() => push(RoutePaths.profileHobbies);

  /// 返回上一页
  void goBack() => pop();
}

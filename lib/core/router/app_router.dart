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
import '../../presentation/pages/chat/chat_detail_page.dart';
import '../../pages/profile/my_profile_page.dart';
import '../../pages/main/main_scaffold.dart';
import '../../presentation/pages/vip/vip_center_page.dart';
import '../../presentation/pages/hobby/hobby_selection_page.dart';
import '../../presentation/pages/hobby/hobby_showcase_page.dart';
import '../../presentation/pages/hobby/hobby_library_page.dart';
import '../../presentation/pages/profile/profile_hobbies_page.dart';
import '../../presentation/pages/posts/create_post_page.dart';
import '../../presentation/pages/profile/user_profile_view_page.dart';
import '../../presentation/pages/profile/edit_profile_page.dart';
import '../../presentation/pages/profile/my_photos_page.dart';
import '../../presentation/pages/profile/liked_users_page.dart';
import '../../presentation/pages/profile/visitors_page.dart';
import '../../presentation/pages/profile/who_liked_me_page.dart';
import '../../presentation/pages/profile/settings_page.dart';
import '../../presentation/providers/hobby_provider.dart';

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
  static const String hobbyLibrary = 'hobby-library';
  static const String createPost = 'create-post';
  static const String userProfile = 'user-profile';
  static const String editProfile = 'edit-profile';
  static const String myPhotos = 'my-photos';
  static const String likedUsers = 'liked-users';
  static const String visitors = 'visitors';
  static const String whoLikedMe = 'who-liked-me';
  static const String chatDetail = 'chat-detail';
  static const String settings = 'settings';
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
  static const String hobbyLibrary = '/hobby-library';
  static const String createPost = '/create-post';
  static const String userProfile = '/user-profile';
  static const String editProfile = '/edit-profile';
  static const String myPhotos = '/my-photos';
  static const String likedUsers = '/liked-users';
  static const String visitors = '/visitors';
  static const String whoLikedMe = '/who-liked-me';
  static const String settings = '/settings';
  static const String chatDetail = '/chat-detail';
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

      // 爱好库编辑页面
      GoRoute(
        path: RoutePaths.hobbyLibrary,
        name: RouteNames.hobbyLibrary,
        builder: (context, state) => const HobbyLibraryPage(),
      ),

      // 用户资料查看页面
      GoRoute(
        path: RoutePaths.userProfile,
        name: RouteNames.userProfile,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final userHobbiesRaw = extra['userHobbies'] as List<dynamic>? ?? [];
          final myHobbiesRaw = extra['myHobbies'] as List<dynamic>? ?? [];
          return UserProfileViewPage(
            userId: extra['userId'] as String? ?? '',
            userName: extra['userName'] as String? ?? '',
            avatar: extra['avatar'] as String?,
            age: extra['age'] as int?,
            city: extra['city'] as String?,
            bio: extra['bio'] as String?,
            userHobbies: userHobbiesRaw
                .whereType<UserHobbyItem>()
                .toList(),
            myHobbies: myHobbiesRaw
                .whereType<UserHobbyItem>()
                .toList(),
          );
        },
      ),

      // 编辑资料
      GoRoute(
        path: RoutePaths.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),

      // 我的照片墙
      GoRoute(
        path: RoutePaths.myPhotos,
        name: RouteNames.myPhotos,
        builder: (context, state) => const MyPhotosPage(),
      ),

      // 我喜欢的人
      GoRoute(
        path: RoutePaths.likedUsers,
        name: RouteNames.likedUsers,
        builder: (context, state) => const LikedUsersPage(),
      ),

      // 看过我的人
      GoRoute(
        path: RoutePaths.visitors,
        name: RouteNames.visitors,
        builder: (context, state) => const VisitorsPage(),
      ),

      // 谁喜欢我
      GoRoute(
        path: RoutePaths.whoLikedMe,
        name: RouteNames.whoLikedMe,
        builder: (context, state) => const WhoLikedMePage(),
      ),

      // 聊天详情页（独立全屏，不保留底部导航栏）
      GoRoute(
        path: RoutePaths.chatDetail,
        name: RouteNames.chatDetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final hobbiesRaw = extra['matchUserHobbies'] as List<dynamic>? ?? [];
          return ChatDetailPage(
            userId: extra['userId'] as String? ?? '',
            userName: extra['userName'] as String? ?? '',
            avatar: extra['avatar'] as String?,
            age: extra['age'] as int?,
            city: extra['city'] as String?,
            bio: extra['bio'] as String?,
            matchUserHobbies: hobbiesRaw
                .whereType<UserHobbyItem>()
                .toList(),
          );
        },
      ),

      // 设置
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
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

  /// 前往爱好库编辑页面
  void goHobbyLibrary() => push(RoutePaths.hobbyLibrary);

  /// 返回上一页
  void goBack() => pop();

  /// 前往用户资料查看页面
  void goUserProfile(Map<String, dynamic> extra) => push(
        RoutePaths.userProfile,
        extra: extra,
      );

  /// 前往编辑资料页面
  void goEditProfile() => push(RoutePaths.editProfile);

  /// 前往我的照片墙页面
  void goMyPhotos() => push(RoutePaths.myPhotos);

  /// 前往我喜欢的人页面
  void goLikedUsers() => push(RoutePaths.likedUsers);

  /// 前往看过我的人页面
  void goVisitors() => push(RoutePaths.visitors);

  /// 前往谁喜欢我页面
  void goWhoLikedMe() => push(RoutePaths.whoLikedMe);

  /// 前往设置页面
  void goSettings() => push(RoutePaths.settings);

  /// 前往聊天详情页
  void goChatDetail(Map<String, dynamic> extra) => push(
        RoutePaths.chatDetail,
        extra: extra,
      );
}

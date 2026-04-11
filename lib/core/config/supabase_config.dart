/// Supabase 配置
///
/// 注意: 实际使用时需要替换为你的 Supabase 项目配置
/// 可以从 Supabase Dashboard -> Project Settings -> API 获取
class SupabaseConfig {
  // TODO: 替换为你的 Supabase URL
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  // TODO: 替换为你的 Supabase Anon Key
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // 存储桶名称
  static const String avatarsBucket = 'avatars';
  static const String photosBucket = 'photos';
  static const String postsBucket = 'posts';

  // 表名
  static const String usersTable = 'users';
  static const String userPhotosTable = 'user_photos';
  static const String hobbyCategoriesTable = 'hobby_categories';
  static const String userHobbyItemsTable = 'user_hobby_items';
  static const String matchesTable = 'matches';
  static const String swipeActionsTable = 'swipe_actions';
  static const String matchUsageTable = 'match_usage';
  static const String redHeartsTable = 'red_hearts';
  static const String conversationsTable = 'conversations';
  static const String messagesTable = 'messages';
  static const String postsTable = 'posts';
  static const String postLikesTable = 'post_likes';
  static const String postCommentsTable = 'post_comments';
  static const String vipSubscriptionsTable = 'vip_subscriptions';
}

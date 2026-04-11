# Supabase 后端配置说明

## 1. 创建 Supabase 项目

1. 访问 [Supabase](https://supabase.com) 并注册/登录
2. 点击 "New Project" 创建新项目
3. 填写项目信息:
   - Name: `socialapp`
   - Database Password: 设置强密码
   - Region: 选择最近的地区 (如 Singapore 或 Tokyo)
4. 等待项目创建完成

## 2. 获取 API 凭证

1. 进入项目 Dashboard
2. 点击左侧菜单 "Project Settings" → "API"
3. 复制以下信息:
   - **Project URL**: `https://xxxxxx.supabase.co`
   - **anon public**: `eyJ...`
4. 更新到 `lib/core/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

## 3. 执行数据库脚本

### 方式一: 使用 Supabase SQL Editor

1. 在 Dashboard 中点击 "SQL Editor"
2. 创建新查询
3. 依次执行以下文件中的 SQL:
   - [schema.sql](./schema.sql) - 创建表结构和初始数据
   - [rls_policies.sql](./rls_policies.sql) - 设置访问权限策略
   - [storage_policies.sql](./storage_policies.sql) - 设置存储桶

### 方式二: 使用 psql 命令行

```bash
# 从 Dashboard -> Database -> Connection string 获取连接信息
psql -h db.xxxxxx.supabase.co -p 5432 -d postgres -U postgres -f schema.sql
```

## 4. 配置 Storage 存储桶

头像、照片墙和动态图片需要存储桶:

1. 在 Dashboard 中点击 "Storage"
2. 创建以下公开存储桶:
   - `avatars` - 用户头像
   - `photos` - 照片墙图片
   - `posts` - 动态图片
3. 设置每个存储桶为 "Public bucket"

## 5. 配置认证 (Auth)

### 5.1 手机号认证

1. Dashboard -> Authentication -> Providers
2. 启用 "Phone" 提供者
3. 配置短信服务商:
   - 开发测试: 使用 Test OTP (固定验证码)
   - 生产环境: 配置 Twilio 或其他短信服务商

### 5.2 自定义 JWT (可选)

如需自定义 JWT 过期时间:
1. Dashboard -> Settings -> Auth
2. 修改 "JWT Settings" -> "JWT expiry"

## 6. 数据库表说明

| 表名 | 用途 |
|------|------|
| `users` | 用户扩展资料 |
| `user_photos` | 用户照片墙 |
| `hobby_categories` | 爱好分类 (预置19个) |
| `user_hobby_items` | 用户爱好条目 |
| `matches` | 匹配记录 |
| `swipe_actions` | 滑动操作记录 |
| `match_usage` | 每日匹配使用统计 |
| `precise_match_selections` | 精准匹配选择 |
| `red_hearts` | 红心约会记录 |
| `conversations` | 聊天会话 |
| `messages` | 聊天消息 |
| `posts` | 动态 |
| `post_likes` | 动态点赞 |
| `post_comments` | 动态评论 |
| `vip_subscriptions` | VIP订阅记录 |

## 7. 生成 Freezed 模型代码

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 8. 本地开发配置

创建 `.env` 文件用于本地开发 (可选):

```
SUPABASE_URL=https://xxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

使用 `flutter_dotenv` 包加载环境变量。

## 9. 测试连接

运行应用后，检查控制台是否有 Supabase 连接成功日志。

## 常见问题

### Q: 国内访问 Supabase 慢怎么办?
A: 可考虑:
1. 使用 CDN 加速
2. 后端使用国内云服务 (阿里云/腾讯云) 自建 PostgreSQL
3. 使用 Supabase 的边缘函数优化访问

### Q: 如何备份数据?
A: Dashboard -> Database -> Backups 可设置自动备份

### Q: RLS 策略不生效?
A: 确保用户已登录，且 Token 正确传递。检查 Supabase 控制台日志。

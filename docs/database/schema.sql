-- ============================================
-- 社交App数据库表结构
-- 基于Supabase PostgreSQL
-- ============================================

-- 启用UUID扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. 用户相关表
-- ============================================

-- 用户扩展表 (与Supabase Auth集成)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone VARCHAR(20) UNIQUE NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    avatar_url TEXT,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    city VARCHAR(50),
    bio TEXT,
    is_vip BOOLEAN DEFAULT FALSE,
    vip_tier VARCHAR(20) CHECK (vip_tier IN ('none', 'basic', 'premium')),
    vip_expire_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 用户照片墙
CREATE TABLE IF NOT EXISTS user_photos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    photo_url TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 2. 爱好分类系统
-- ============================================

-- 爱好分类表
CREATE TABLE IF NOT EXISTS hobby_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL,
    icon_name VARCHAR(50),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 用户爱好条目表
CREATE TABLE IF NOT EXISTS user_hobby_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES hobby_categories(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, category_id, item_name)
);

-- ============================================
-- 3. 匹配系统
-- ============================================

-- 匹配记录表
CREATE TABLE IF NOT EXISTS matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id_1 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_id_2 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    match_score INTEGER NOT NULL DEFAULT 0,
    common_hobbies JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'matched', 'rejected', 'unmatched')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    matched_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(user_id_1, user_id_2)
);

-- 用户滑动记录表
CREATE TABLE IF NOT EXISTS swipe_actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(10) NOT NULL CHECK (action IN ('like', 'dislike')),
    match_mode VARCHAR(20) NOT NULL CHECK (match_mode IN ('hobby', 'city', 'precise')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(from_user_id, to_user_id)
);

-- 匹配使用统计表
CREATE TABLE IF NOT EXISTS match_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    match_mode VARCHAR(20) NOT NULL CHECK (match_mode IN ('hobby', 'city', 'precise')),
    usage_date DATE NOT NULL DEFAULT CURRENT_DATE,
    used_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, match_mode, usage_date)
);

-- 精准匹配选择记录
CREATE TABLE IF NOT EXISTS precise_match_selections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_category_id UUID NOT NULL REFERENCES hobby_categories(id) ON DELETE CASCADE,
    target_item_name VARCHAR(100) NOT NULL,
    selected_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, target_category_id, target_item_name)
);

-- ============================================
-- 4. 红心约会系统
-- ============================================

-- 红心记录表
CREATE TABLE IF NOT EXISTS red_hearts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(from_user_id, to_user_id)
);

-- ============================================
-- 5. 聊天系统
-- ============================================

-- 聊天会话表
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id_1 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_id_2 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    last_message TEXT,
    last_message_at TIMESTAMP WITH TIME ZONE,
    unread_count_1 INTEGER DEFAULT 0,
    unread_count_2 INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id_1, user_id_2)
);

-- 消息表
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'system')),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 6. 动态广场系统
-- ============================================

-- 动态表
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    images JSONB DEFAULT '[]',
    location VARCHAR(100),
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 动态点赞表
CREATE TABLE IF NOT EXISTS post_likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, user_id)
);

-- 动态评论表
CREATE TABLE IF NOT EXISTS post_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES post_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    like_count INTEGER DEFAULT 0,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 7. VIP订阅系统
-- ============================================

-- VIP订阅记录表
CREATE TABLE IF NOT EXISTS vip_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tier VARCHAR(20) NOT NULL CHECK (tier IN ('basic', 'premium')),
    price DECIMAL(10, 2) NOT NULL,
    duration_months INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_auto_renew BOOLEAN DEFAULT FALSE,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 索引优化
-- ============================================

-- 用户表索引
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_city ON users(city);
CREATE INDEX IF NOT EXISTS idx_users_vip ON users(is_vip);

-- 爱好索引
CREATE INDEX IF NOT EXISTS idx_user_hobby_items_user ON user_hobby_items(user_id);
CREATE INDEX IF NOT EXISTS idx_user_hobby_items_name ON user_hobby_items(item_name);

-- 匹配索引
CREATE INDEX IF NOT EXISTS idx_matches_user1 ON matches(user_id_1);
CREATE INDEX IF NOT EXISTS idx_matches_user2 ON matches(user_id_2);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_swipe_from ON swipe_actions(from_user_id);
CREATE INDEX IF NOT EXISTS idx_swipe_to ON swipe_actions(to_user_id);

-- 聊天索引
CREATE INDEX IF NOT EXISTS idx_conversations_user1 ON conversations(user_id_1);
CREATE INDEX IF NOT EXISTS idx_conversations_user2 ON conversations(user_id_2);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(created_at);

-- 动态索引
CREATE INDEX IF NOT EXISTS idx_posts_user ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created ON posts(created_at);
CREATE INDEX IF NOT EXISTS idx_post_likes_post ON post_likes(post_id);

-- ============================================
-- 初始化数据
-- ============================================

-- 插入20个爱好分类
INSERT INTO hobby_categories (name, icon_name, sort_order) VALUES
('书籍', 'book', 1),
('音乐', 'music_note', 2),
('游戏', 'sports_esports', 3),
('电影', 'movie', 4),
('动漫', 'animation', 5),
('剧集', 'tv', 6),
('综艺', 'live_tv', 7),
('运动', 'sports', 8),
('美食', 'restaurant', 9),
('宠物', 'pets', 10),
('摄影', 'camera_alt', 11),
('绘画', 'palette', 12),
('手工', 'handyman', 13),
('科技', 'computer', 14),
('时尚', 'checkroom', 15),
('汽车', 'directions_car', 16),
('学习', 'school', 17),
('旅游', 'flight', 18),
('博主', 'person', 19)
ON CONFLICT DO NOTHING;

-- ============================================
-- 触发器: 自动更新 updated_at
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为用户表添加触发器
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 为匹配使用统计表添加触发器
DROP TRIGGER IF EXISTS update_match_usage_updated_at ON match_usage;
CREATE TRIGGER update_match_usage_updated_at
    BEFORE UPDATE ON match_usage
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 为动态表添加触发器
DROP TRIGGER IF EXISTS update_posts_updated_at ON posts;
CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

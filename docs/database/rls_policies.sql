-- ============================================
-- Row Level Security (RLS) 安全策略
-- ============================================

-- 启用RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_hobby_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipe_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE precise_match_selections ENABLE ROW LEVEL SECURITY;
ALTER TABLE red_hearts ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE vip_subscriptions ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 1. 用户表策略
-- ============================================

-- 允许已认证用户查看其他用户基本信息
DROP POLICY IF EXISTS "允许查看用户列表" ON users;
CREATE POLICY "允许查看用户列表"
    ON users FOR SELECT
    TO authenticated
    USING (true);

-- 允许用户查看自己的完整信息
DROP POLICY IF EXISTS "允许查看自己的完整信息" ON users;
CREATE POLICY "允许查看自己的完整信息"
    ON users FOR SELECT
    TO authenticated
    USING (id = auth.uid());

-- 允许用户更新自己的信息
DROP POLICY IF EXISTS "允许更新自己的信息" ON users;
CREATE POLICY "允许更新自己的信息"
    ON users FOR UPDATE
    TO authenticated
    USING (id = auth.uid());

-- 允许服务角色管理所有用户
DROP POLICY IF EXISTS "服务角色管理用户" ON users;
CREATE POLICY "服务角色管理用户"
    ON users FOR ALL
    TO service_role
    USING (true);

-- ============================================
-- 2. 用户照片墙策略
-- ============================================

DROP POLICY IF EXISTS "允许查看用户照片" ON user_photos;
CREATE POLICY "允许查看用户照片"
    ON user_photos FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS "允许管理自己的照片" ON user_photos;
CREATE POLICY "允许管理自己的照片"
    ON user_photos FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 3. 用户爱好条目策略
-- ============================================

DROP POLICY IF EXISTS "允许查看用户爱好" ON user_hobby_items;
CREATE POLICY "允许查看用户爱好"
    ON user_hobby_items FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS "允许管理自己的爱好" ON user_hobby_items;
CREATE POLICY "允许管理自己的爱好"
    ON user_hobby_items FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 4. 匹配记录策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的匹配" ON matches;
CREATE POLICY "允许查看自己的匹配"
    ON matches FOR SELECT
    TO authenticated
    USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

DROP POLICY IF EXISTS "允许创建匹配记录" ON matches;
CREATE POLICY "允许创建匹配记录"
    ON matches FOR INSERT
    TO authenticated
    WITH CHECK (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

DROP POLICY IF EXISTS "允许更新自己的匹配状态" ON matches;
CREATE POLICY "允许更新自己的匹配状态"
    ON matches FOR UPDATE
    TO authenticated
    USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

-- ============================================
-- 5. 滑动记录策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的滑动记录" ON swipe_actions;
CREATE POLICY "允许查看自己的滑动记录"
    ON swipe_actions FOR SELECT
    TO authenticated
    USING (from_user_id = auth.uid());

DROP POLICY IF EXISTS "允许创建滑动记录" ON swipe_actions;
CREATE POLICY "允许创建滑动记录"
    ON swipe_actions FOR INSERT
    TO authenticated
    WITH CHECK (from_user_id = auth.uid());

-- ============================================
-- 6. 匹配使用统计策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的使用统计" ON match_usage;
CREATE POLICY "允许查看自己的使用统计"
    ON match_usage FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS "允许管理自己的使用统计" ON match_usage;
CREATE POLICY "允许管理自己的使用统计"
    ON match_usage FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 7. 精准匹配选择策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的精准匹配选择" ON precise_match_selections;
CREATE POLICY "允许查看自己的精准匹配选择"
    ON precise_match_selections FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS "允许管理自己的精准匹配选择" ON precise_match_selections;
CREATE POLICY "允许管理自己的精准匹配选择"
    ON precise_match_selections FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 8. 红心记录策略
-- ============================================

DROP POLICY IF EXISTS "允许查看发送的红心" ON red_hearts;
CREATE POLICY "允许查看发送的红心"
    ON red_hearts FOR SELECT
    TO authenticated
    USING (from_user_id = auth.uid());

DROP POLICY IF EXISTS "允许查看收到的红心" ON red_hearts;
CREATE POLICY "允许查看收到的红心"
    ON red_hearts FOR SELECT
    TO authenticated
    USING (to_user_id = auth.uid());

DROP POLICY IF EXISTS "允许发送红心" ON red_hearts;
CREATE POLICY "允许发送红心"
    ON red_hearts FOR INSERT
    TO authenticated
    WITH CHECK (from_user_id = auth.uid());

DROP POLICY IF EXISTS "允许删除自己发送的红心" ON red_hearts;
CREATE POLICY "允许删除自己发送的红心"
    ON red_hearts FOR DELETE
    TO authenticated
    USING (from_user_id = auth.uid());

-- ============================================
-- 9. 聊天会话策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的会话" ON conversations;
CREATE POLICY "允许查看自己的会话"
    ON conversations FOR SELECT
    TO authenticated
    USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

DROP POLICY IF EXISTS "允许创建会话" ON conversations;
CREATE POLICY "允许创建会话"
    ON conversations FOR INSERT
    TO authenticated
    WITH CHECK (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

DROP POLICY IF EXISTS "允许更新自己的会话" ON conversations;
CREATE POLICY "允许更新自己的会话"
    ON conversations FOR UPDATE
    TO authenticated
    USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

-- ============================================
-- 10. 消息策略
-- ============================================

DROP POLICY IF EXISTS "允许查看会话消息" ON messages;
CREATE POLICY "允许查看会话消息"
    ON messages FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.user_id_1 = auth.uid() OR conversations.user_id_2 = auth.uid())
        )
    );

DROP POLICY IF EXISTS "允许发送消息" ON messages;
CREATE POLICY "允许发送消息"
    ON messages FOR INSERT
    TO authenticated
    WITH CHECK (
        sender_id = auth.uid() AND
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.user_id_1 = auth.uid() OR conversations.user_id_2 = auth.uid())
        )
    );

-- ============================================
-- 11. 动态策略
-- ============================================

DROP POLICY IF EXISTS "允许查看动态" ON posts;
CREATE POLICY "允许查看动态"
    ON posts FOR SELECT
    TO authenticated
    USING (is_deleted = false);

DROP POLICY IF EXISTS "允许管理自己的动态" ON posts;
CREATE POLICY "允许管理自己的动态"
    ON posts FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 12. 动态点赞策略
-- ============================================

DROP POLICY IF EXISTS "允许查看点赞" ON post_likes;
CREATE POLICY "允许查看点赞"
    ON post_likes FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS "允许点赞和取消点赞" ON post_likes;
CREATE POLICY "允许点赞和取消点赞"
    ON post_likes FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 13. 动态评论策略
-- ============================================

DROP POLICY IF EXISTS "允许查看评论" ON post_comments;
CREATE POLICY "允许查看评论"
    ON post_comments FOR SELECT
    TO authenticated
    USING (is_deleted = false);

DROP POLICY IF EXISTS "允许管理自己的评论" ON post_comments;
CREATE POLICY "允许管理自己的评论"
    ON post_comments FOR ALL
    TO authenticated
    USING (user_id = auth.uid());

-- ============================================
-- 14. VIP订阅策略
-- ============================================

DROP POLICY IF EXISTS "允许查看自己的订阅" ON vip_subscriptions;
CREATE POLICY "允许查看自己的订阅"
    ON vip_subscriptions FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS "服务角色管理订阅" ON vip_subscriptions;
CREATE POLICY "服务角色管理订阅"
    ON vip_subscriptions FOR ALL
    TO service_role
    USING (true);

-- ============================================
-- 15. 爱好分类策略 (公开读取)
-- ============================================

DROP POLICY IF EXISTS "允许查看爱好分类" ON hobby_categories;
CREATE POLICY "允许查看爱好分类"
    ON hobby_categories FOR SELECT
    TO authenticated
    USING (is_active = true);

DROP POLICY IF EXISTS "服务角色管理分类" ON hobby_categories;
CREATE POLICY "服务角色管理分类"
    ON hobby_categories FOR ALL
    TO service_role
    USING (true);

-- ============================================
-- Storage 存储桶配置
-- ============================================

-- 创建头像存储桶
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- 创建照片墙存储桶
INSERT INTO storage.buckets (id, name, public)
VALUES ('photos', 'photos', true)
ON CONFLICT (id) DO NOTHING;

-- 创建动态图片存储桶
INSERT INTO storage.buckets (id, name, public)
VALUES ('posts', 'posts', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Storage 安全策略
-- ============================================

-- 头像存储桶策略

-- 允许所有人查看头像
DROP POLICY IF EXISTS "允许查看头像" ON storage.objects;
CREATE POLICY "允许查看头像"
    ON storage.objects FOR SELECT
    TO authenticated
    USING (bucket_id = 'avatars');

-- 允许用户上传自己的头像
DROP POLICY IF EXISTS "允许上传自己的头像" ON storage.objects;
CREATE POLICY "允许上传自己的头像"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'avatars' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 允许用户更新自己的头像
DROP POLICY IF EXISTS "允许更新自己的头像" ON storage.objects;
CREATE POLICY "允许更新自己的头像"
    ON storage.objects FOR UPDATE
    TO authenticated
    USING (
        bucket_id = 'avatars' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 允许用户删除自己的头像
DROP POLICY IF EXISTS "允许删除自己的头像" ON storage.objects;
CREATE POLICY "允许删除自己的头像"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (
        bucket_id = 'avatars' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 照片墙存储桶策略

-- 允许所有人查看照片
DROP POLICY IF EXISTS "允许查看照片墙" ON storage.objects;
CREATE POLICY "允许查看照片墙"
    ON storage.objects FOR SELECT
    TO authenticated
    USING (bucket_id = 'photos');

-- 允许用户上传自己的照片
DROP POLICY IF EXISTS "允许上传自己的照片" ON storage.objects;
CREATE POLICY "允许上传自己的照片"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'photos' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 允许用户删除自己的照片
DROP POLICY IF EXISTS "允许删除自己的照片" ON storage.objects;
CREATE POLICY "允许删除自己的照片"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (
        bucket_id = 'photos' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 动态图片存储桶策略

-- 允许所有人查看动态图片
DROP POLICY IF EXISTS "允许查看动态图片" ON storage.objects;
CREATE POLICY "允许查看动态图片"
    ON storage.objects FOR SELECT
    TO authenticated
    USING (bucket_id = 'posts');

-- 允许用户上传自己的动态图片
DROP POLICY IF EXISTS "允许上传动态图片" ON storage.objects;
CREATE POLICY "允许上传动态图片"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'posts' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

-- 允许用户删除自己的动态图片
DROP POLICY IF EXISTS "允许删除动态图片" ON storage.objects;
CREATE POLICY "允许删除动态图片"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (
        bucket_id = 'posts' AND
        (storage.foldername(name))[1] = auth.uid()::text
    );

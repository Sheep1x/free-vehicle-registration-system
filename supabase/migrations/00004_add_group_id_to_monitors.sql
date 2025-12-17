-- 为监控员表添加班组关联字段
ALTER TABLE IF EXISTS monitors_info ADD COLUMN IF NOT EXISTS group_id uuid REFERENCES toll_groups(id) ON DELETE SET NULL;

-- 添加索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_monitors_group ON monitors_info(group_id);

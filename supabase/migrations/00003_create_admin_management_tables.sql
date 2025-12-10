/*
# 创建后台管理相关表

1. 新增表
   - `toll_stations` (收费站)
     - `id` (uuid, 主键)
     - `name` (text, 收费站名称)
     - `code` (text, 收费站编码)
     - `created_at` (timestamptz)
   
   - `toll_groups` (收费班组)
     - `id` (uuid, 主键)
     - `station_id` (uuid, 外键关联收费站)
     - `name` (text, 班组名称)
     - `code` (text, 班组编码)
     - `created_at` (timestamptz)
   
   - `toll_collectors_info` (收费员信息)
     - `id` (uuid, 主键)
     - `name` (text, 姓名)
     - `code` (text, 工号)
     - `group_id` (uuid, 外键关联班组)
     - `created_at` (timestamptz)
   
   - `monitors_info` (监控员信息)
     - `id` (uuid, 主键)
     - `name` (text, 姓名)
     - `code` (text, 工号)
     - `station_id` (uuid, 外键关联收费站)
     - `created_at` (timestamptz)
   
   - `shift_settings` (班次时间设置)
     - `id` (uuid, 主键)
     - `shift_name` (text, 班次名称：白班/中班/夜班)
     - `start_time` (time, 开始时间)
     - `end_time` (time, 结束时间)
     - `created_at` (timestamptz)

2. 安全策略
   - 所有表不启用RLS，允许公开访问（后台管理用途）
*/

-- 创建收费站表
CREATE TABLE IF NOT EXISTS toll_stations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 创建收费班组表
CREATE TABLE IF NOT EXISTS toll_groups (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    station_id uuid REFERENCES toll_stations(id) ON DELETE CASCADE,
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 创建收费员信息表
CREATE TABLE IF NOT EXISTS toll_collectors_info (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    group_id uuid REFERENCES toll_groups(id) ON DELETE SET NULL,
    created_at timestamptz DEFAULT now()
);

-- 创建监控员信息表
CREATE TABLE IF NOT EXISTS monitors_info (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    station_id uuid REFERENCES toll_stations(id) ON DELETE SET NULL,
    created_at timestamptz DEFAULT now()
);

-- 创建班次时间设置表
CREATE TABLE IF NOT EXISTS shift_settings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    shift_name text NOT NULL UNIQUE,
    start_time time NOT NULL,
    end_time time NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 插入默认班次设置
INSERT INTO shift_settings (shift_name, start_time, end_time) VALUES
    ('白班', '07:30:00', '15:30:00'),
    ('中班', '15:30:00', '23:30:00'),
    ('夜班', '23:30:00', '07:30:00')
ON CONFLICT (shift_name) DO NOTHING;

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_toll_groups_station ON toll_groups(station_id);
CREATE INDEX IF NOT EXISTS idx_toll_collectors_group ON toll_collectors_info(group_id);
CREATE INDEX IF NOT EXISTS idx_monitors_station ON monitors_info(station_id);

-- 添加注释
COMMENT ON TABLE toll_stations IS '收费站信息表';
COMMENT ON TABLE toll_groups IS '收费班组信息表';
COMMENT ON TABLE toll_collectors_info IS '收费员信息表';
COMMENT ON TABLE monitors_info IS '监控员信息表';
COMMENT ON TABLE shift_settings IS '班次时间设置表';
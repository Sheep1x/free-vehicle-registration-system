/*
# 创建车辆通行费票据识别记录表

1. 新建表
   - `toll_records`
     - `id` (uuid, 主键, 默认: gen_random_uuid())
     - `plate_number` (text, 车牌号)
     - `vehicle_type` (text, 车型)
     - `axle_count` (text, 轴数)
     - `tonnage` (text, 吨位)
     - `entry_info` (text, 入口信息)
     - `entry_time` (timestamptz, 通行时间)
     - `amount` (numeric, 金额)
     - `image_url` (text, 票据图片URL)
     - `created_at` (timestamptz, 创建时间, 默认: now())

2. 安全策略
   - 公开数据，所有用户可读写
   - 不启用RLS（无登录系统）

3. 索引
   - 为 plate_number 和 created_at 创建索引以优化查询
*/

CREATE TABLE IF NOT EXISTS toll_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plate_number text,
  vehicle_type text,
  axle_count text,
  tonnage text,
  entry_info text,
  entry_time timestamptz,
  amount numeric(10, 2),
  image_url text,
  created_at timestamptz DEFAULT now()
);

-- 创建索引优化查询
CREATE INDEX IF NOT EXISTS idx_toll_records_plate_number ON toll_records(plate_number);
CREATE INDEX IF NOT EXISTS idx_toll_records_created_at ON toll_records(created_at DESC);

-- 添加注释
COMMENT ON TABLE toll_records IS '车辆通行费票据识别记录表';
COMMENT ON COLUMN toll_records.plate_number IS '车牌号';
COMMENT ON COLUMN toll_records.vehicle_type IS '车型';
COMMENT ON COLUMN toll_records.axle_count IS '轴数';
COMMENT ON COLUMN toll_records.tonnage IS '吨位';
COMMENT ON COLUMN toll_records.entry_info IS '入口信息（包含站点和省份）';
COMMENT ON COLUMN toll_records.entry_time IS '通行时间';
COMMENT ON COLUMN toll_records.amount IS '通行费金额';
COMMENT ON COLUMN toll_records.image_url IS '票据图片URL';

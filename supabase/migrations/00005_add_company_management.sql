/*
# 添加分公司管理功能

1. 新增表
   - `companies` (分公司)
     - `id` (uuid, 主键)
     - `name` (text, 分公司名称)
     - `code` (text, 分公司编码)
     - `created_at` (timestamptz)

2. 修改表
   - `toll_stations` (收费站)
     - 添加 `company_id` 外键，关联分公司

3. 关系设计
   - 分公司与收费站：一对多关系
   - 允许添加分公司时选择下属收费站
   - 允许添加收费站时选择上级分公司
*/

-- 创建分公司表
CREATE TABLE IF NOT EXISTS companies (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 修改收费站表，添加分公司外键
ALTER TABLE toll_stations
ADD COLUMN IF NOT EXISTS company_id uuid REFERENCES companies(id) ON DELETE SET NULL;

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_toll_stations_company ON toll_stations(company_id);
CREATE INDEX IF NOT EXISTS idx_companies_code ON companies(code);

-- 添加注释
COMMENT ON TABLE companies IS '分公司信息表';
COMMENT ON COLUMN toll_stations.company_id IS '所属分公司ID';

-- 插入默认分公司数据（可选，根据实际情况调整）
INSERT INTO companies (name, code) VALUES
    ('总公司', '000'),
    ('华北分公司', '001'),
    ('华东分公司', '002')
ON CONFLICT (code) DO NOTHING;

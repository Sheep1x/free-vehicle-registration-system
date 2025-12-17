/*
# 完整的分公司管理功能SQL

1. 创建分公司表
2. 修改收费站表，添加分公司外键
3. 创建必要的索引
4. 添加表和字段注释
5. 插入默认数据
6. 权限设置
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

-- 添加表和字段注释
COMMENT ON TABLE companies IS '分公司信息表，用于管理收费站的上级分公司';
COMMENT ON COLUMN companies.id IS '分公司ID，主键';
COMMENT ON COLUMN companies.name IS '分公司名称';
COMMENT ON COLUMN companies.code IS '分公司编码，唯一标识';
COMMENT ON COLUMN companies.created_at IS '创建时间';

COMMENT ON COLUMN toll_stations.company_id IS '所属分公司ID，外键关联companies表';

-- 插入默认分公司数据（可选，根据实际情况调整）
INSERT INTO companies (name, code) VALUES
    ('总公司', '000'),
    ('华北分公司', '001'),
    ('华东分公司', '002')
ON CONFLICT (code) DO NOTHING;

-- 设置表权限（允许公开访问，根据实际需求调整）
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE toll_stations ENABLE ROW LEVEL SECURITY;

-- 创建策略，允许所有访问（后台管理用途）
CREATE POLICY "Allow public access to companies" ON companies
    FOR ALL USING (true);

CREATE POLICY "Allow public access to toll_stations" ON toll_stations
    FOR ALL USING (true);

-- 创建视图，方便查询分公司及其下属收费站
CREATE VIEW companies_with_stations AS
SELECT
    c.id AS company_id,
    c.name AS company_name,
    c.code AS company_code,
    ARRAY_AGG(
        JSON_BUILD_OBJECT(
            'station_id', s.id,
            'station_name', s.name,
            'station_code', s.code
        )
    ) FILTER (WHERE s.id IS NOT NULL) AS stations
FROM companies c
LEFT JOIN toll_stations s ON c.id = s.company_id
GROUP BY c.id, c.name, c.code;

-- 添加视图注释
COMMENT ON VIEW companies_with_stations IS '分公司及其下属收费站视图';

-- 完整的数据库修复脚本
-- 用于修复收费站与分公司的关联问题

-- 步骤1: 检查并创建分公司表
CREATE TABLE IF NOT EXISTS companies (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text UNIQUE NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- 步骤2: 检查并添加收费站表的company_id字段
DO $$
BEGIN
    -- 检查company_id字段是否存在
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'toll_stations' AND column_name = 'company_id'
    ) THEN
        -- 添加company_id字段
        ALTER TABLE toll_stations
        ADD COLUMN company_id uuid REFERENCES companies(id) ON DELETE SET NULL;
    END IF;
END $$;

-- 步骤3: 检查并删除错误的外键约束
DO $$
BEGIN
    -- 检查是否存在错误的外键约束
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'toll_stations_company_id_fkey'
    ) THEN
        -- 删除现有约束
        ALTER TABLE toll_stations
        DROP CONSTRAINT IF EXISTS toll_stations_company_id_fkey;
    END IF;
    
    -- 创建正确的外键约束
    ALTER TABLE toll_stations
    ADD CONSTRAINT toll_stations_company_id_fkey 
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL;
END $$;

-- 步骤4: 插入测试分公司数据
INSERT INTO companies (name, code) VALUES
    ('平原分公司', 'PY001'),
    ('南区分公司', 'NQ001'),
    ('北区分公司', 'BQ001')
ON CONFLICT (code) DO NOTHING;

-- 步骤5: 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_toll_stations_company_id ON toll_stations(company_id);
CREATE INDEX IF NOT EXISTS idx_companies_name ON companies(name);
CREATE INDEX IF NOT EXISTS idx_companies_code ON companies(code);

-- 步骤6: 验证修复结果
SELECT 
    'companies' AS table_name,
    (SELECT COUNT(*) FROM companies) AS total_records,
    (SELECT string_agg(name, ', ') FROM companies LIMIT 5) AS sample_data
UNION ALL
SELECT 
    'toll_stations' AS table_name,
    (SELECT COUNT(*) FROM toll_stations) AS total_records,
    (SELECT string_agg(name, ', ') FROM toll_stations LIMIT 5) AS sample_data;

-- 步骤7: 测试关联查询
SELECT 
    s.id AS station_id,
    s.name AS station_name,
    s.code AS station_code,
    s.company_id,
    c.name AS company_name,
    CASE WHEN s.company_id IS NOT NULL THEN '已关联' ELSE '未关联' END AS status
FROM toll_stations s
LEFT JOIN companies c ON s.company_id = c.id
ORDER BY s.created_at DESC
LIMIT 10;

-- 操作说明：
-- 1. 在Supabase控制台的SQL编辑器中执行此脚本
-- 2. 执行前请先备份数据
-- 3. 执行后验证数据关联是否正确
-- 4. 重启应用后测试编辑功能

-- 预期效果：
-- 1. 分公司表(companies)被创建或更新
-- 2. 收费站表(toll_stations)添加了company_id字段
-- 3. 正确的外键约束被创建
-- 4. 测试分公司数据被插入
-- 5. 索引被创建，提高查询性能
-- 6. 可以看到收费站与分公司的关联情况
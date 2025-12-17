-- 完整的分公司与收费站关联修复脚本
-- 1. 检查并修复外键约束
-- 2. 确保分公司数据存在
-- 3. 确保收费站的company_id能正确关联

-- 步骤1: 查看当前外键约束状态
SELECT conname, conrelid::regclass AS table_name, confrelid::regclass AS referenced_table
FROM pg_constraint
WHERE conname = 'toll_stations_company_id_fkey';

-- 步骤2: 删除可能存在的错误外键约束
ALTER TABLE toll_stations 
DROP CONSTRAINT IF EXISTS toll_stations_company_id_fkey;

-- 步骤3: 重新创建正确的外键约束
ALTER TABLE toll_stations
ADD CONSTRAINT toll_stations_company_id_fkey 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL;

-- 步骤4: 验证外键约束创建成功
SELECT conname, conrelid::regclass AS table_name, confrelid::regclass AS referenced_table
FROM pg_constraint
WHERE conname = 'toll_stations_company_id_fkey';

-- 步骤5: 检查分公司数据
SELECT * FROM companies;

-- 步骤6: 检查收费站数据，查看company_id是否为空
SELECT id, name, code, company_id FROM toll_stations;

-- 步骤7: 如果分公司表为空，添加默认分公司数据
INSERT INTO companies (name, code) VALUES
    ('平原分公司', 'PY001'),
    ('南区分公司', 'NQ001'),
    ('北区分公司', 'BQ001')
ON CONFLICT (code) DO NOTHING;

-- 步骤8: 查看更新后的分公司数据
SELECT * FROM companies;

-- 步骤9: 修复现有收费站的company_id（根据需要修改）
-- 例如：将南佐收费站关联到平原分公司
-- UPDATE toll_stations 
-- SET company_id = (SELECT id FROM companies WHERE name = '平原分公司') 
-- WHERE name = '南佐收费站';

-- 步骤10: 验证修复结果
SELECT s.id, s.name, s.code, s.company_id, c.name AS company_name
FROM toll_stations s
LEFT JOIN companies c ON s.company_id = c.id;

-- 步骤11: 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_toll_stations_company_id ON toll_stations(company_id);
CREATE INDEX IF NOT EXISTS idx_companies_name ON companies(name);

-- 步骤12: 验证所有表和约束
\d companies
\d toll_stations

-- 操作说明：
-- 1. 在Supabase控制台的SQL编辑器中执行此脚本
-- 2. 执行前请先备份数据
-- 3. 根据实际情况调整步骤9中的更新语句
-- 4. 执行后验证数据关联是否正确
-- 5. 重启应用后测试编辑功能

-- 预期效果：
-- 1. 外键约束正确创建
-- 2. 分公司数据存在
-- 3. 收费站可以正常关联分公司
-- 4. 编辑收费站所属分公司后，数据会正确保存到数据库
-- 5. 刷新页面后，所属分公司仍会正确显示
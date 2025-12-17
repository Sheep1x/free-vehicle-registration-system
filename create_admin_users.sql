-- 创建admin_users表
CREATE TABLE IF NOT EXISTS admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('super_admin', 'company_admin', 'station_admin')),
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  station_id UUID REFERENCES toll_stations(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 插入初始超级管理员用户
INSERT INTO admin_users (username, password, role)
VALUES ('Sheep1x', 'Yyx19960517', 'super_admin')
ON CONFLICT (username) DO NOTHING;

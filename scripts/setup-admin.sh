#!/bin/bash

# 从.env文件读取Supabase配置并更新admin.js

ENV_FILE=".env"
ADMIN_JS="admin/admin.js"

if [ ! -f "$ENV_FILE" ]; then
  echo "错误: 找不到 .env 文件"
  exit 1
fi

if [ ! -f "$ADMIN_JS" ]; then
  echo "错误: 找不到 admin/admin.js 文件"
  exit 1
fi

# 读取环境变量
SUPABASE_URL=$(grep "^TARO_APP_SUPABASE_URL=" "$ENV_FILE" | cut -d '=' -f2)
SUPABASE_ANON_KEY=$(grep "^TARO_APP_SUPABASE_ANON_KEY=" "$ENV_FILE" | cut -d '=' -f2)

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
  echo "错误: 无法从 .env 文件读取 Supabase 配置"
  exit 1
fi

# 更新admin.js文件
sed -i.bak "s|const SUPABASE_URL = '.*'|const SUPABASE_URL = '$SUPABASE_URL'|" "$ADMIN_JS"
sed -i.bak "s|const SUPABASE_ANON_KEY = '.*'|const SUPABASE_ANON_KEY = '$SUPABASE_ANON_KEY'|" "$ADMIN_JS"

# 删除备份文件
rm -f "${ADMIN_JS}.bak"

echo "✅ 成功更新 admin.js 配置"
echo "   SUPABASE_URL: $SUPABASE_URL"
echo "   SUPABASE_ANON_KEY: ${SUPABASE_ANON_KEY:0:20}..."
echo ""
echo "现在可以部署后台管理系统了！"
echo "本地测试: cd admin && python3 -m http.server 8080"

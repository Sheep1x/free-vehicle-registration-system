Write-Output "🔧 开始修复后台管理系统..."
Write-Output ""

# 1. 重新配置
Write-Output "1️⃣ 重新配置Supabase连接..."
Set-Location "d:\app-84zvdc9gufwh"

# 检查setup-admin.sh是否存在，如果存在则尝试运行
if (Test-Path ".\scripts\setup-admin.sh") {
    Write-Output "   正在运行setup-admin.sh..."
    bash ".\scripts\setup-admin.sh"
} else {
    Write-Output "   未找到setup-admin.sh，跳过配置步骤"
}

Write-Output ""

# 2. 清除浏览器缓存提示
Write-Output "2️⃣ 请手动执行以下操作："
Write-Output "   - 打开浏览器"
Write-Output "   - 按 Ctrl+Shift+Delete (Windows/Linux) 或 Cmd+Shift+Delete (Mac)"
Write-Output "   - 清除缓存和Cookie"
Write-Output ""

# 3. 启动服务器
Write-Output "3️⃣ 启动本地服务器..."
Write-Output ""
Write-Output "✅ 服务器将启动在 http://localhost:8080"
Write-Output "📊 诊断页面: http://localhost:8080/clear-cache.html"
Write-Output "🎛️ 管理页面: http://localhost:8080/index.html"
Write-Output ""
Write-Output "按 Ctrl+C 停止服务器"
Write-Output "=========================================="
Write-Output ""

Set-Location "admin"
python -m http.server 8080
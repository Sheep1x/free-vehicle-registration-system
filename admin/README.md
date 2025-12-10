# 免费车登记 - 后台管理系统

## 功能说明

### 1. 登记记录管理
- 查看所有免费车辆登记记录
- 搜索记录（按车牌号、免费原因等）
- 查看记录详情
- 删除记录
- 导出Excel/PDF

### 2. 收费站管理
- 添加/编辑/删除收费站
- 收费站编码和名称管理

### 3. 班组管理
- 添加/编辑/删除收费班组
- 班组归属收费站
- 班组编码和名称管理

### 4. 收费员管理
- 添加/编辑/删除收费员
- 收费员归属班组
- 工号和姓名管理

### 5. 监控员管理
- 添加/编辑/删除监控员
- 监控员归属收费站
- 工号和姓名管理

### 6. 班次设置
- 白班时间设置（默认：7:30-15:30）
- 中班时间设置（默认：15:30-23:30）
- 夜班时间设置（默认：23:30-7:30）
- 支持自定义修改时间段

## 使用说明

### 配置步骤

1. **获取Supabase配置**
   - 登录Supabase控制台
   - 找到项目的URL和anon key
   - 在`.env`文件中查看：
     ```
     TARO_APP_SUPABASE_URL=你的URL
     TARO_APP_SUPABASE_ANON_KEY=你的KEY
     ```

2. **配置后台管理系统**
   - 打开 `admin/admin.js` 文件
   - 修改第2-3行的配置：
     ```javascript
     const SUPABASE_URL = '你的SUPABASE_URL'
     const SUPABASE_ANON_KEY = '你的SUPABASE_ANON_KEY'
     ```

3. **部署后台管理系统**
   
   **方法一：本地运行**
   ```bash
   # 在admin目录下启动简单HTTP服务器
   cd admin
   python3 -m http.server 8080
   # 或使用Node.js
   npx http-server -p 8080
   ```
   然后访问：http://localhost:8080

   **方法二：部署到服务器**
   - 将`admin`文件夹上传到Web服务器
   - 通过域名访问index.html

   **方法三：使用Vercel/Netlify等平台**
   - 将admin文件夹部署到静态托管平台
   - 获得在线访问地址

## 数据结构

### 收费站表 (toll_stations)
- id: UUID
- name: 收费站名称
- code: 收费站编码
- created_at: 创建时间

### 班组表 (toll_groups)
- id: UUID
- station_id: 所属收费站ID
- name: 班组名称
- code: 班组编码
- created_at: 创建时间

### 收费员表 (toll_collectors_info)
- id: UUID
- name: 姓名
- code: 工号
- group_id: 所属班组ID
- created_at: 创建时间

### 监控员表 (monitors_info)
- id: UUID
- name: 姓名
- code: 工号
- station_id: 所属收费站ID
- created_at: 创建时间

### 班次设置表 (shift_settings)
- id: UUID
- shift_name: 班次名称（白班/中班/夜班）
- start_time: 开始时间
- end_time: 结束时间
- created_at: 创建时间

## 使用流程

1. **初始设置**
   - 添加收费站
   - 在收费站下添加班组
   - 设置班次时间（可选，已有默认值）

2. **人员管理**
   - 添加收费员到对应班组
   - 添加监控员到对应收费站

3. **记录管理**
   - 小程序端登记的记录会自动显示
   - 可以查看、搜索、导出记录
   - 支持删除无效记录

## 注意事项

1. **数据安全**
   - 后台管理系统目前无登录验证
   - 建议部署在内网或添加访问控制
   - 不要将Supabase密钥泄露

2. **数据关联**
   - 删除收费站会同时删除其下属班组
   - 删除班组不会删除收费员，但会解除关联
   - 删除收费站不会删除监控员，但会解除关联

3. **班次识别**
   - 班次时间可以跨天（如夜班23:30-7:30）
   - 修改班次时间会立即生效
   - 建议在非工作时间修改班次设置

4. **导出功能**
   - Excel导出支持所有中文字符
   - PDF导出可能对中文支持有限
   - 建议使用Excel格式导出

## 技术栈

- HTML5 + CSS3 + JavaScript
- Supabase (数据库)
- SheetJS (Excel导出)
- jsPDF (PDF导出)

## 浏览器兼容性

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 常见问题

**Q: 无法加载数据？**
A: 检查Supabase配置是否正确，确保URL和KEY正确填写。

**Q: 导出功能不工作？**
A: 确保浏览器允许下载文件，检查浏览器控制台是否有错误。

**Q: 如何备份数据？**
A: 使用导出Excel功能定期导出数据，或在Supabase控制台进行数据库备份。

**Q: 如何添加登录验证？**
A: 可以使用Supabase Auth或其他认证服务，在admin.js中添加登录逻辑。

## 更新日志

### v1.0.0 (2025-12-10)
- 初始版本发布
- 完整的CRUD功能
- 导出Excel/PDF功能
- 班次时间设置
- 统计数据展示

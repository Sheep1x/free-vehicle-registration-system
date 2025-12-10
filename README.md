# 智票通 - 车辆通行费票据识别小程序

专门用于识别车辆通行费票据信息的微信小程序，通过拍照或上传图片自动提取票据中的关键信息，提高缴费记录管理和报销效率。

---

## 项目概述

智票通是一款基于 Taro + React + TypeScript 开发的微信小程序，集成了文心一言多模态AI能力，能够智能识别车辆通行费票据中的关键信息。

### 核心功能

1. **票据识别**
   - 支持拍照或从相册选择票据图片
   - 自动识别车牌号、车型、轴数、吨位
   - 提取入口信息、通行时间、缴费金额
   - 支持手动编辑修正识别结果

2. **历史记录**
   - 保存所有识别记录到云端数据库
   - 支持按车牌号搜索筛选
   - 批量删除管理功能
   - 记录详情查看

3. **个人中心**
   - 使用说明和帮助文档
   - 关于应用信息
   - 导出功能（规划中）

---

## 技术栈

- **前端框架**: Taro 4.1.5 + React 18
- **开发语言**: TypeScript
- **样式方案**: Tailwind CSS + SCSS
- **状态管理**: Zustand
- **数据库**: Supabase
- **AI能力**: 文心一言多模态大模型
- **包管理器**: pnpm

---

## 项目结构

```
├── src/
│   ├── app.config.ts               # Taro应用配置（路由、TabBar）
│   ├── app.scss                    # 全局样式和主题配色
│   ├── app.tsx                     # 应用入口文件
│   ├── client/
│   │   └── supabase.ts             # Supabase客户端配置
│   ├── db/                         # 数据库操作
│   │   ├── api.ts                  # 数据库API封装
│   │   └── types.ts                # 数据类型定义
│   ├── pages/                      # 页面目录
│   │   ├── home/                   # 首页（票据识别）
│   │   ├── result/                 # 识别结果页
│   │   ├── history/                # 历史记录页
│   │   └── profile/                # 个人中心页
│   ├── utils/                      # 工具函数
│   │   ├── imageUtils.ts           # 图片处理工具
│   │   └── ocrUtils.ts             # OCR识别工具
│   └── assets/
│       └── images/                 # 图片资源（TabBar图标）
├── supabase/
│   └── migrations/                 # 数据库迁移文件
├── package.json
├── tailwind.config.js              # Tailwind配置
└── tsconfig.json                   # TypeScript配置
```

---

## 数据库设计

### toll_records 表

存储车辆通行费票据识别记录

| 字段 | 类型 | 说明 |
|------|------|------|
| id | uuid | 主键 |
| plate_number | text | 车牌号 |
| vehicle_type | text | 车型 |
| axle_count | text | 轴数 |
| tonnage | text | 吨位 |
| entry_info | text | 入口信息 |
| entry_time | timestamptz | 通行时间 |
| amount | numeric | 金额 |
| image_url | text | 票据图片URL |
| created_at | timestamptz | 创建时间 |

---

## 页面路由

### TabBar页面

- `/pages/home/index` - 票据识别（首页）
- `/pages/history/index` - 历史记录
- `/pages/profile/index` - 我的

### 其他页面

- `/pages/result/index` - 识别结果页

---

## 安装和使用

```bash
# 安装依赖
pnpm install

# 代码检查
pnpm run lint
```

---

## 配色方案

采用蓝色系主题，体现专业可靠的科技感：

- **主色**: #1890FF (蓝色)
- **背景色**: 浅蓝渐变
- **卡片**: 白色带阴影
- **文字**: 深灰色

---

## 环境变量

项目使用 `.env` 文件管理环境变量：

```
TARO_APP_NAME=智票通
TARO_APP_APP_ID=app-84zvdc9gufwh
TARO_APP_SUPABASE_URL=<Supabase项目URL>
TARO_APP_SUPABASE_ANON_KEY=<Supabase匿名密钥>
```

---

## 开发说明

### OCR识别流程

1. 用户选择或拍摄票据图片
2. 图片压缩处理
3. 转换为Base64格式
4. 调用文心一言多模态API进行识别
5. 解析AI返回的结构化数据
6. 展示识别结果供用户确认编辑
7. 保存到Supabase数据库

### 关键依赖

- `miaoda-taro-utils`: 提供流式AI对话能力
- `@supabase/supabase-js`: Supabase客户端
- `@tarojs/*`: Taro框架核心包

---

## 版权信息

© 2025 智票通

专业的车辆通行费票据识别工具

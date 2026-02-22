# AID-AIDiary
A Brand New Form of Journaling.  
作为一个喜欢玩AI和写日记的人，能把它们结合起来作为人生中的第一个项目，是一件多么激动人心的事情！

## 功能特性 (Features)
- 📝 **日记时间线** — 极简深色风格，支持创建、浏览日记
- 📅 **日历视图** — 按月展示日期，有日记的天显示小红点
- ⚙️ **设置页面** — 深/浅色切换、6色主题色、多语言选择
- 👤 **账号系统** — 账密注册/登录，JWT Token 鉴权（bcrypt 加密）
- 🎨 **主题联动** — 所有设置全局生效，持久化存储

## 项目架构 (Architecture)
- **Frontend**: 基于 [Expo](https://expo.dev/) (React Native Web) 构建的跨平台极简日记界面，风格参考 Journey。全局状态通过 `AppContext` 管理。
- **Backend**: 基于 [FastAPI](https://fastapi.tiangolo.com/) 构建，SQLite 存储日记数据，支持用户注册/登录（JWT）。

## 快速启动 (Getting Started)

### 1. 后端 (Backend)
```bash
cd backend
# 激活虚拟环境
.\.venv\Scripts\activate
# 安装依赖
pip install -r requirements.txt
# 启动服务
uvicorn main:app --reload
```
后端服务运行在 `http://localhost:8000`

### 2. 前端 (Frontend)
```bash
cd frontend
npm install
npm run web
```
在浏览器打开 `http://localhost:8081`

## 环境变量
复制 `backend/.env.example` 为 `backend/.env` 并填入：
```
OPENAI_API_KEY=sk-...
SECRET_KEY=your-jwt-secret
```

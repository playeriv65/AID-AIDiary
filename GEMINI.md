保持使用中文回答

提交之前必须向我报告

提交之前维护配置文件，包括但不限于根目录下的gitignore，README.md，GEMINI.md

运行之前杀掉无用进程（比如 `taskkill /F /IM node.exe /T`）清理端口占用
运行之前检查端口占用，如果有旧进程直接杀掉

使用内置浏览器调试UI

## 运行项目指南
**后端**: `cd backend && uv run uvicorn main:app --reload`
**前端**: `cd frontend && npm run web`
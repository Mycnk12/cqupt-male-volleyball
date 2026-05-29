# 🏐 排球队管理系统

一个**完全免费**的排球队数据管理系统，基于 GitHub Pages。

## 功能

- 📊 **实时记分网页** — `scoreboard.html`，浏览器打开即用
- ✍️ **自动赛报生成** — 配合 Reasonix Code skill，JSON → 赛报
- 🌐 **GitHub Pages 展示** — 赛季战绩、队员名单、比赛列表
- 👥 **队员管理** — `roster.json` 统一管理，支持在役/退役

## 快速开始

### 1. Fork 并克隆

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

### 2. 修改队伍信息

编辑 `roster.json`，填入你的队员信息：

```json
{
  "team": "你的队名",
  "players": [
    {"num":"7","name":"张三","pos":"主攻","height":185,"dept":"通信","grade":"本2023","birth":"2004-07-09","phone":"138...","hometown":"北京","status":"active"}
  ]
}
```

然后运行构建脚本：

```bash
bash build.sh
```

### 3. 部署 GitHub Pages

在仓库 Settings → Pages → Source 选择 `main` 分支，保存。几分钟后访问 `https://YOUR_USERNAME.github.io/YOUR_REPO/`。

### 4. 比赛日

1. 打开 `scoreboard.html`，记录比赛
2. 比赛结束点「导出」→ 得到 JSON
3. 把 JSON 放到 `matches/` 目录
4. 更新 `matches/list.json`（添加一行比赛记录）
5. 运行 `bash build.sh` 更新记分板
6. 用 Reasonix Code skill 生成赛报：

```
/skill volleyball-match-report
生成赛报 matches/2025-07-11-清华.json
```

7. `git commit && git push` → Pages 自动更新

## 文件结构

```
├── index.html          # GitHub Pages 首页
├── roster.json         # 队员档案（手动编辑）
├── scoreboard.html     # 实时记分网页
├── build.sh            # 构建脚本
├── skill.md            # Reasonix Code skill
├── matches/
│   ├── list.json       # 比赛索引
│   └── *.json          # 比赛数据
└── reports/
    └── *.md            # 赛报
```

## 依赖

- **记分网页**：浏览器即可（无需服务器）
- **赛报生成**：需要 [Reasonix Code](https://reasonix.com)
- **展示页面**：GitHub Pages（免费）

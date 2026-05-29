# 🏐 重庆邮电大学排球队

> 🌐 **数据看板：** [点击查看球队首页](https://mycnk12.github.io/cqupt-male-volleyball/)

队员资料、比赛记录、赛报存档。数据由 `scoreboard.html` 实时记录，赛报由 Reasonix Code 自动生成。

💡 **想了解这支球队？** 在 Reasonix Code 中调用 `/skill team-facts`，可以问：队里有几个主攻？和清华赢过几次？谁扣球最好？

---

## 🛠 这也是一个开源管理系统

如果你也想给自己的排球队搭一套，Fork → 改 `roster.json` → 开启 Pages 即可。

### 快速上手

```bash
git clone https://github.com/你的用户名/仓库名.git
```

编辑 `roster.json`：

```json
{
  "team": "你的队名",
  "players": [
    {"num":"7","name":"张三","pos":"主攻","height":185,"dept":"通信学院","grade":"本2023","birth":"2004-07","hometown":"北京","status":"active"}
  ]
}
```

```bash
bash build.sh          # 注入队员数据
git push               # 部署
```

仓库 Settings → Pages → Source 选 `main` → 等 2 分钟上线。

### 文件结构

```
├── index.html                          # Pages 首页
├── roster.json                         # 队员档案
├── scoreboard.html                     # 实时记分网页
├── build.sh
├── skills/
│   ├── volleyball-match-report.md      # 赛报生成 & 数据分析 skill
│   └── team-facts.md                   # 球队信息查询 skill（重邮专用）
├── matches/
│   ├── list.json
│   └── *.json                          # 比赛原始数据
└── reports/
    └── *.md                            # 赛报 Markdown
```

### 两个 Skill

| Skill | 用途 | 谁用 |
|-------|------|------|
| `volleyball-match-report` | 赛报生成、数据分析、队员管理 | 球队管理员 |
| `team-facts` | 查询球队信息（问答式） | 任何人 |

### 比赛日流程

1. 打开 `scoreboard.html` → 记分 → 导出 JSON
2. 把 JSON 放 `matches/`，运行 `bash build.sh`
3. Reasonix Code 中说「生成赛报 matches/xxx.json」
4. `git push` → Pages 自动更新

---

📊 记分网页浏览器即用 · ✍️ 赛报由 Reasonix Code 生成 · 🌐 页面由 GitHub Pages 免费托管

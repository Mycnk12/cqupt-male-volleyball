#!/bin/bash
# 构建脚本：将 roster.json 数据内联到 scoreboard.html，更新比赛索引
set -e

cd "$(dirname "$0")"

# 1. 更新 scoreboard.html 中的 roster 数据
echo "📋 内联 roster.json → scoreboard.html ..."

python3 << 'PYEOF'
import json, re

# 读取 roster，只保留记分板需要的字段
roster = json.load(open('roster.json'))
players = [{'num': p['num'], 'name': p['name'], 'pos': p['pos']} for p in roster['players']]
roster_compact = json.dumps({'team': roster['team'], 'players': players}, ensure_ascii=False)

# 读取 HTML
html = open('scoreboard.html').read()

# 替换 script#roster-data 内容
new_tag = '<script id="roster-data" type="application/json">\n' + roster_compact + '\n</script>'
html = re.sub(
    r'<script id="roster-data" type="application/json">.*?</script>',
    new_tag,
    html,
    flags=re.DOTALL
)

open('scoreboard.html', 'w').write(html)
print('✅ scoreboard.html 已更新')
PYEOF

# 2. 更新 matches/list.json
echo "📊 更新比赛索引 ..."

python3 << 'PYEOF'
import json, os, glob

matches = []
for f in sorted(glob.glob('matches/*.json')):
    if f.endswith('list.json'): continue
    try:
        d = json.load(open(f))
        scores = [f'{s["us"]}:{s["them"]}' for s in d.get('setScores', [])]
        us_wins = sum(1 for s in d.get('setScores', []) if s['us'] > s['them'])
        them_wins = sum(1 for s in d.get('setScores', []) if s['them'] > s['us'])
        report_file = f'reports/{os.path.basename(f).replace(".json", ".md")}'
        matches.append({
            'date': d.get('date', ''),
            'opponent': d.get('opponent', ''),
            'file': f,
            'report': report_file if os.path.exists(report_file) else '',
            'result': f'{us_wins}:{them_wins}',
            'scores': scores
        })
    except: pass

json.dump(matches, open('matches/list.json', 'w'), ensure_ascii=False, indent=2)
print(f'✅ 共 {len(matches)} 场比赛')
PYEOF

echo ""
echo "🎉 构建完成！"
echo "   git add . && git commit -m '更新数据' && git push"

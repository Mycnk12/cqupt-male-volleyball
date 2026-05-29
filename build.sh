#!/bin/bash
# 构建脚本：将 roster.json 数据内联到 scoreboard.html，更新比赛索引
set -e

cd "$(dirname "$0")"

# 1. 更新 scoreboard.html 中的 roster 数据
echo "📋 内联 roster.json → scoreboard.html ..."

ROSTER_JSON=$(cat roster.json | python3 -c "
import json,sys
d = json.load(sys.stdin)
# 只保留 scoreboard 需要的字段
players = [{'num':p['num'],'name':p['name'],'pos':p['pos']} for p in d['players']]
out = json.dumps({'team':d['team'],'players':players}, ensure_ascii=False)
print(out)
")

# 用 Python 替换 HTML 中的 roster 数据块
python3 -c "
import re, sys
html = open('scoreboard.html','r').read()
# 替换 script#roster-data 内容
new_script = f'<script id=\"roster-data\" type=\"application/json\">\n{'''$ROSTER_JSON'''}\n</script>'
html = re.sub(
  r'<script id=\"roster-data\" type=\"application/json\">.*?</script>',
  new_script,
  html,
  flags=re.DOTALL
)
open('scoreboard.html','w').write(html)
"

echo "✅ scoreboard.html 已更新"

# 2. 更新 matches/list.json（扫描 matches/ 目录）
echo "📊 更新比赛索引 ..."

python3 -c "
import json, os, glob

matches = []
for f in sorted(glob.glob('matches/*.json')):
    if f.endswith('list.json'): continue
    try:
        d = json.load(open(f))
        scores = [f'{s[\"us\"]}:{s[\"them\"]}' for s in d.get('setScores',[])]
        us_wins = sum(1 for s in d.get('setScores',[]) if s['us'] > s['them'])
        them_wins = sum(1 for s in d.get('setScores',[]) if s['them'] > s['us'])
        report_file = f'reports/{os.path.basename(f).replace(\".json\",\".md\")}'
        matches.append({
            'date': d.get('date',''),
            'opponent': d.get('opponent',''),
            'file': f,
            'report': report_file if os.path.exists(report_file) else '',
            'result': f'{us_wins}:{them_wins}',
            'scores': scores
        })
    except: pass

json.dump(matches, open('matches/list.json','w'), ensure_ascii=False, indent=2)
print(f'✅ 共 {len(matches)} 场比赛')
"

echo ""
echo "🎉 构建完成！"
echo "   git add . && git commit -m '更新数据' && git push"

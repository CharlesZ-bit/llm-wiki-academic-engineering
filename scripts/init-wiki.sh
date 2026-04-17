#!/bin/bash
# llm-wiki 初始化脚本
# 自动创建知识库的目录结构
# 用法：bash init-wiki.sh <知识库路径> <主题>

set -e

WIKI_ROOT="${1:-$HOME/Documents/我的知识库}"
TOPIC="${2:-我的知识库}"
LANGUAGE="${3:-中文}"
DATE=$(date +%Y-%m-%d)
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 安全的模板变量替换函数（用 perl 替代 sed，避免中文/空格/特殊字符问题）
replace_vars() {
    local input_file="$1"
    local output_file="$2"
    TOPIC_VALUE="$TOPIC" \
    DATE_VALUE="$DATE" \
    WIKI_ROOT_VALUE="$WIKI_ROOT" \
    LANGUAGE_VALUE="$LANGUAGE" \
    perl -pe '
        s/\{\{TOPIC\}\}/$ENV{TOPIC_VALUE}/g;
        s/\{\{DATE\}\}/$ENV{DATE_VALUE}/g;
        s/\{\{WIKI_ROOT\}\}/$ENV{WIKI_ROOT_VALUE}/g;
        s/\{\{LANGUAGE\}\}/$ENV{LANGUAGE_VALUE}/g;
    ' "$input_file" > "$output_file"
}

echo "正在创建知识库..."
echo "   路径：$WIKI_ROOT"
echo "   主题：$TOPIC"
echo "   语言：$LANGUAGE"
echo ""

# 创建目录结构（学术工程文献知识库专用）
mkdir -p "$WIKI_ROOT"/raw/{literature,notes,assets}
mkdir -p "$WIKI_ROOT"/wiki/{literature,entities,topics,methods,comparisons,synthesis}

cat > "$WIKI_ROOT/.gitignore" <<'EOF'
.wiki-tmp/
EOF

echo "[完成] 目录结构已创建"

# 从模板生成文件
replace_vars "$SKILL_DIR/templates/schema-template.md" "$WIKI_ROOT/.wiki-schema.md"
echo "[完成] Schema 文件已生成"

replace_vars "$SKILL_DIR/templates/index-template.md" "$WIKI_ROOT/index.md"
echo "[完成] 索引文件已生成"

replace_vars "$SKILL_DIR/templates/log-template.md" "$WIKI_ROOT/log.md"
echo "[完成] 日志文件已生成"

replace_vars "$SKILL_DIR/templates/overview-template.md" "$WIKI_ROOT/wiki/overview.md"
echo "[完成] 总览文件已生成"

# purpose.md 不再由脚本生成，改由 AI 根据用户问答生成个性化版本

cat > "$WIKI_ROOT/vocabulary-academic.md" <<'EOF'
# 领域专有名词表

> 用于提升知识图谱和文献整理的精度。你可以随时补充和修改这个列表。

## 核心领域术语

- 船舶推进轴系振动
- 电磁-结构耦合
- 有限元模态分析
- 实验模态分析
- 扭转振动
- 横向振动
- 纵向振动
- 轴系对中
- 轴承动力学
- 螺旋桨激励

## 常用方法

- 传递矩阵法
- 有限元法 (FEM)
- 边界元法 (BEM)
- 多体动力学
- 子结构模态综合法
- 谐响应分析
- 瞬态动力学分析

## 待补充

（在整理文献过程中持续添加新术语）
EOF
echo "[完成] 领域专有名词表已生成"

cat > "$WIKI_ROOT/.wiki-cache.json" <<'EOF'
{
  "version": 1,
  "entries": {}
}
EOF
echo "[完成] 缓存文件已生成"

echo ""
echo "知识库创建完成！"
echo ""
echo "目录结构："
echo "   $WIKI_ROOT/"
echo "   ├── raw/              （原始素材）"
echo "   │   ├── literature/   学术文献 Markdown"
echo "   │   ├── notes/         研究笔记 Markdown"
echo "   │   └── assets/        图片等附件"
echo "   ├── wiki/             （知识库）"
echo "   ├── index.md          （索引）"
echo "   ├── log.md            （日志）"
echo "   ├── purpose.md        （研究方向）"
echo "   ├── vocabulary-academic.md （领域专有名词表）"
echo "   ├── .wiki-cache.json  （缓存）"
echo "   └── .wiki-schema.md   （配置）"
echo ""
echo "下一步：把文献 Markdown 放到 raw/literature/，告诉我消化它们！"

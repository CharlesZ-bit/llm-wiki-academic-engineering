---
name: llm-wiki-upgrade
version: 1.1.0
description: |
  升级 llm-wiki-academic-engineering 到最新版本。专为电气、机械、船舶、振动等工科领域设计的学术文献知识库。
  从 GitHub 拉取最新代码并通过官方 install.sh 升级。
  触发词：upgrade llm-wiki、更新 llm-wiki、llm-wiki 升级、llm-wiki update
allowed-tools:
  - Bash
  - Read
---

# /llm-wiki-upgrade

升级 llm-wiki-academic-engineering 到最新版本。

## 升级流程

### Step 1：读取当前版本

```bash
SKILL_DIR="$HOME/.claude/skills/llm-wiki"
OLD_VERSION=$(grep -m1 "^## v" "$SKILL_DIR/CHANGELOG.md" 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "unknown")
echo "CURRENT_VERSION=$OLD_VERSION"
```

如果 `SKILL_DIR` 不存在，告知用户尚未安装 llm-wiki，停止流程。

### Step 2：Clone 最新版本到临时目录

```bash
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/CharlesZ-bit/llm-wiki-academic-engineering.git "$TMP_DIR/llm-wiki-skill" 2>&1
echo "CLONE_EXIT=$?"
```

如果 clone 失败（`CLONE_EXIT` 非 0），告知用户网络问题，停止流程。

### Step 3：读取新版本号

```bash
NEW_VERSION=$(grep -m1 "^## v" "$TMP_DIR/llm-wiki-skill/CHANGELOG.md" 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "unknown")
echo "NEW_VERSION=$NEW_VERSION"
```

如果 `OLD_VERSION == NEW_VERSION`，告知用户已是最新版本，清理临时目录后结束：

```bash
rm -rf "$TMP_DIR"
```

### Step 4：执行官方升级

从临时目录（带 `.git`）执行 `install.sh --upgrade`。

```bash
bash "$TMP_DIR/llm-wiki-skill/install.sh" --upgrade --platform claude 2>&1
echo "UPGRADE_EXIT=$?"
```

如果 `UPGRADE_EXIT` 非 0，告知用户升级失败，展示关键信息，清理临时目录后停止流程。

### Step 5：清理临时目录

```bash
rm -rf "$TMP_DIR"
```

### Step 6：展示更新内容

读取 `$HOME/.claude/skills/llm-wiki/CHANGELOG.md`，提取 `OLD_VERSION` 到 `NEW_VERSION` 之间的变更，提炼 3-5 条用户最关心的变化。

输出格式：

```text
llm-wiki $NEW_VERSION 升级完成（从 $OLD_VERSION）

更新内容：
- [变化1]
- [变化2]
- ...
```

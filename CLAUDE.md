# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 Claude Code skill，基于 Karpathy llm-wiki 方法论构建个人知识库系统。核心理念：知识"一次编译，持续维护"，而非每次查询时重新推导。

**不是传统代码项目**，没有编译/测试/lint 流程。主要文件是 Markdown 格式的 skill 规范。

## 安装与部署

```bash
# 安装到 Claude Code
git clone <repo> ~/.claude/skills/llm-wiki && bash ~/.claude/skills/llm-wiki/setup.sh
```

`setup.sh` 做了什么：
- 将 `deps/` 中的 3 个依赖 skill 复制到 `~/.claude/skills/`
- 在 `deps/baoyu-url-to-markdown/scripts/` 中运行 `bun install`（失败则回退到 npm）
- 检查 Chrome 是否运行（URL 提取需要）

## 核心文件架构

| 文件 | 作用 |
|------|------|
| `SKILL.md` | Skill 完整规范（~930行），定义 8 个工作流、路由逻辑、模板、双语支持 |
| `scripts/init-wiki.sh` | 初始化 wiki 目录结构，用 `perl` 做变量替换（支持中文路径） |
| `templates/` | 7 个 Markdown 模板（entity/topic/source/index/overview/log/schema） |
| `.wiki-schema.md` | 用户 wiki 的配置文件（由 init 生成，存在于用户的 wiki 目录中） |
| `deps/` | 打包的依赖 skill（baoyu-url-to-markdown、x-article-extractor、youtube-transcript） |

## 8 个工作流（SKILL.md 中定义）

1. **init** — 初始化新 wiki，支持语言选择（zh/en）
2. **ingest** — 消化单条素材（URL 自动路由到对应提取器）
3. **batch-ingest** — 批量处理文件夹中的素材
4. **query** — 从 wiki 搜索并回答问题
5. **digest** — 跨素材生成深度综合报告
6. **lint** — 健康检查（孤立页面、断链、矛盾、索引一致性）
7. **status** — 查看 wiki 统计和近期活动
8. **graph** — 生成 Mermaid 知识图谱可视化

## 内容处理策略

- **完整处理**（> 1000 字符）：保存原始素材 → 生成 source 摘要页 → 提取 3-5 个概念创建/更新 entity 页 → 识别主题更新 topic 页 → 更新 index/log
- **简化处理**（≤ 1000 字符，如推文）：保存原始素材 → 简化摘要页 → 提取 1-3 个概念（标记 `[待创建]`）→ 仅更新 index/log

## 关键技术细节

- **模板变量替换**：`init-wiki.sh` 用 `perl` 而非 `sed`，原因是 `sed` 在 macOS 处理中文字符和特殊路径时不稳定
- **CWD 感知**：所有工作流先检查当前目录是否有 `.wiki-schema.md`，支持多 wiki 并存
- **双语支持**：从 `.wiki-schema.md` 读取 `language` 字段，所有输出跟随该语言
- **双向链接**：使用 `[[page-name]]` 语法（兼容 Obsidian）

## 修改 SKILL.md 时的注意事项

- 工作流路由逻辑在文件顶部的"触发词"部分定义
- 每个工作流有独立的"步骤"章节，修改时注意保持步骤编号连续
- 模板内容在 `templates/` 目录，SKILL.md 中引用模板路径
- 双语模板分别在各模板文件中用注释区分 zh/en 部分

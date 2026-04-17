# llm-wiki-academic-engineering - 学术工程文献知识库

> **学术文献专用版**：专为**电气、机械、船舶、振动**等传统工科领域设计的结构化学术文献知识库系统。

## 它做什么

把手工整理的学术文献 Markdown 转化为持续增长、互相链接的结构化知识库。你只需要提供文献文件，agent 会自动提取核心概念，研究方法、关键发现，并构建支持文献综述、方法对比的 wiki 网络。

核心区别：知识被**编译一次，持续维护**，而不是每次查询都从原始文档重新推导。

## 学术专用增强

- **学术文献模板**：`literature-template.md` 强制包含 DOI、年份、作者、期刊、置信度
- **方法论页**：独立的 `wiki/methods/` 目录，支持方法复用和可重复性标记
- **强制双向链接**：每篇文献必须链接到至少 3 个 entities/topics/methods
- **引用一致性检查**：文献引用自动建立 `[[文献标题]]` 链接
- **学术 Digest 格式**：支持文献综述、方法对比表、研究路线图（Mermaid Gantt）

## 你怎么用

把这个仓库链接扔给 agent，让它自己安装：

```bash
bash install.sh --platform claude
```

## 快速开始

### 1. 初始化知识库

告诉 agent："帮我初始化一个知识库"

Agent 会通过**交互式问答**引导你完成初始化：

**问题 1：知识库主题**
> "你的知识库要围绕什么主题？比如'船舶振动控制研究'、'机械系统动力学'"

**问题 2：研究领域**
> "你主要研究哪个具体领域？"
> - 船舶推进系统振动与控制
> - 电磁-结构耦合动力学
> - 有限元模态分析与实验验证
> - 机械系统动力学建模
> - 其他（自定义）

**问题 3：研究内容**
> "你目前是否有确定的研究问题或方案？"
> - 如果有：描述研究问题和目标、打算用什么方法
> - 如果没有：先积累文献、了解领域现状

**问题 4：整理原则**（可选）
> "你希望知识库在整理时遵循什么原则？"
> - 优先提取可重复的实验方法和验证数据
> - 关注理论与方法的演进历史
> - 重视工程应用和实践案例
> - 追踪最新研究进展

### 2. 添加文献

将学术文献 Markdown 放入 `raw/literature/` 目录：

```bash
cp my-paper.md ~/Documents/我的知识库/raw/literature/
```

告诉 agent："请消化这篇文献"

### 3. 批量处理

将多篇文献放入 `raw/literature/` 后：

> "请批量消化 `raw/literature/` 文件夹里的所有文献"

### 4. 生成综述

> "给我写一篇关于 [主题] 的文献综述"

## 来源边界

**只接收以下两类 Markdown 文件进入知识库：**

| 来源 | raw 目录 | 处理方式 |
|------|----------|----------|
| 学术文献 Markdown | `raw/literature/` | 直接读取，走学术专用摄取流程 |
| 研究笔记 Markdown | `raw/notes/` | 直接读取 |

**不支持的类型**（会拒绝处理）：网页链接、微信公众号、社交媒体、YouTube、PDF 等。

## 功能

- **交互式初始化**：通过问答引导明确研究方向，自动生成个性化 purpose.md
- **研究方向引导**：`purpose.md` 让 agent 在整理和查询时有明确方向
- **学术文献专用摄取**：针对 Markdown 文献强制提取 DOI、方法、结果、结论、引用文献
- **方法论页**：独立的 `wiki/methods/` 支持方法复用，标注可重复性（高/中/低/未说明）
- **强制双向链接**：每篇文献必须链接到至少 3 个 entities/topics/methods
- **两步式整理**：先分析后生成，长内容走两步链式思考
- **置信度标注**：每个知识点标注来源可信度（EXTRACTED / INFERRED / AMBIGUOUS / UNVERIFIED）
- **智能去重**：SHA256 缓存跳过未变化的文献
- **缓存可靠性**：写入即更新 + 自愈安全网
- **文献删除**：级联删除文献时自动清理关联页面、断链和缓存
- **Obsidian 兼容**：所有内容都是本地 markdown，直接用 Obsidian 打开查看

## 使用示例

### 1. 消化文献

```bash
cp my-paper.md ~/Documents/我的知识库/raw/literature/
```

> "请消化 `raw/literature/my-paper.md`"

### 2. 批量处理

> "请批量消化 `raw/literature/` 文件夹里的所有文献"

### 3. 生成综述

> "给我写一篇船舶振动控制方法的文献综述"

### 4. 健康检查

> "检查一下知识库的健康状态"

## 目录结构

```
你的知识库/
├── raw/
│   ├── literature/         # 学术文献 Markdown
│   ├── notes/             # 研究笔记 Markdown
│   └── assets/            # 图片等附件
├── wiki/
│   ├── literature/         # 文献摘要页
│   ├── entities/           # 实体页
│   ├── topics/            # 主题页
│   ├── methods/            # 方法论页
│   ├── comparisons/        # 对比分析
│   └── synthesis/          # 综合分析
├── vocabulary-academic.md  # 领域专有名词表
├── purpose.md              # 研究方向
├── index.md                # 索引
├── log.md                  # 操作日志
└── .wiki-cache.json       # 缓存
```

## 核心方法论

来自 [Andrej Karpathy](https://karpathy.ai/) - [llm-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)

## 致谢

本项目基于 [llm-wiki-skill](https://github.com/sdyckjq-lab/llm-wiki-skill) 修改而来。

## 更新方法

安装后如果想更新到最新版本，执行：

```bash
bash install.sh --upgrade --platform claude
```

或者让 Claude 执行 `/llm-wiki-upgrade`。

## License

MIT

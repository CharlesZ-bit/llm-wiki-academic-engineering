# Wiki Schema（学术工程文献知识库配置规范）

> 这个文件告诉 AI 如何维护你的知识库。你和 AI 可以一起调整它。

## 知识库信息

- 主题：{{TOPIC}}
- 创建日期：{{DATE}}
- 语言：{{LANGUAGE}}
- 版本：1.2-academic

## 目录结构

```
{{WIKI_ROOT}}/
├── raw/                    # 原始素材（AI 只读，不会修改）
│   ├── literature/         # 手工整理的学术文献（Markdown 格式）
│   ├── articles/           # 网页文章
│   ├── tweets/             # X/Twitter 内容
│   ├── wechat/             # 微信公众号文章
│   ├── xiaohongshu/        # 小红书内容
│   ├── zhihu/              # 知乎内容
│   ├── pdfs/               # PDF 文件
│   ├── notes/              # 手写笔记
│   └── assets/             # 图片等附件
├── wiki/                   # 知识库主体（AI 写，你看）
│   ├── literature/         # 学术文献摘要页（每篇文献一篇）
│   ├── entities/           # 实体页（概念、方法、理论、设备）
│   ├── topics/             # 主题页（研究主题、知识领域）
│   ├── methods/            # 方法论页（实验方法、建模方法、分析方法）
│   ├── comparisons/        # 对比分析页
│   └── synthesis/          # 综合分析页
├── vocabulary-academic.md  # 领域专有名词表
├── index.md                # 内容索引（目录）
├── log.md                  # 操作日志（时间线）
└── .wiki-schema.md         # 本文件（配置规范）
```

## 页面命名规范

- 文献页：`wiki/literature/{年份}-{短标题}.md`
  - 例：`wiki/literature/2025-ship-shaft-vibration-control.md`
- 实体页：`wiki/entities/{名称}.md`
  - 例：`wiki/entities/有限元模态分析.md`、`wiki/entities/电磁-结构耦合.md`
- 主题页：`wiki/topics/{主题名}.md`
  - 例：`wiki/topics/船舶推进系统振动控制.md`
- 方法论页：`wiki/methods/{方法名}.md`
  - 例：`wiki/methods/实验模态分析.md`
- 对比分析：`wiki/comparisons/{对比主题}.md`
  - 例：`wiki/comparisons/振动控制方法对比.md`
- 综合分析：`wiki/synthesis/{分析主题}.md`
  - 例：`wiki/synthesis/船舶振动控制研究综述.md`

## 交叉引用规范

- 页面间使用 `[[页面名]]` 语法（Obsidian 兼容的双向链接）
- 文献引用格式：`[来源: 文献标题](../literature/xxx.md)`
- 每篇文献必须链接到至少 3 个 entities/topics/methods
- 每个页面底部维护"相关页面"列表

## 页面格式规范

每个 wiki 页面应包含：

```markdown
---
title: 
doi: 
authors: 
year: 
journal: 
tags: [标签1, 标签2]
confidence: EXTRACTED/INFERRED/AMBIGUOUS/UNVERIFIED
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [关联文献列表]
---

# 页面标题

> 一句话摘要

## 正文内容

...

## 相关页面

- [[另一个页面]]
- [[又一个页面]]
```

## Ingest（消化素材）规则

### 学术文献专用规则

1. **文献页必须包含**：DOI、年份、作者、期刊、置信度
2. **强制双向链接**：每篇文献必须链接到至少 3 个 entities/topics/methods
3. **方法可重复性标记**：提取的实验/建模方法需标注可重复性（高/中/低/未说明）
4. **引用一致性检查**：文献中引用的其他文献尽量建立 [[文献标题]] 链接

### 分级处理

根据素材长度和信息密度自动分级：

**完整处理**（文献 > 1000 字）：
1. 每个新素材**必须**生成文献页（`wiki/literature/` 下）
2. 从素材中提取 3-5 个关键概念/方法
3. 检查是否需要创建新的实体页（`wiki/entities/`）
4. 检查是否需要创建或更新主题页（`wiki/topics/`）
5. 检查是否需要创建或更新方法论页（`wiki/methods/`）
6. 更新 `index.md`（添加新条目）
7. 更新 `log.md`（记录操作）
8. 更新 `overview.md`（如果知识库全貌有变化）

**简化处理**（素材 < 1000 字）：
1. 生成文献页（`wiki/literature/` 下）
2. 提取 1-3 个关键概念
3. 如果关键概念已有实体页，追加信息；如果没有，在文献页中标记 `[待创建]`
4. 更新 `index.md` 和 `log.md`
5. 跳过主题页、方法页和 overview 更新

### 来源边界

| 分类 | 当前来源 | 处理原则 |
|------|----------|----------|
| 核心主线 | `学术文献 Markdown`、`PDF / 本地 PDF`、`Markdown/文本/HTML`、`纯文本粘贴` | 不依赖外挂，直接进入主线 |
| 可选外挂 | `网页文章`、`X/Twitter`、`微信公众号`、`YouTube`、`知乎` | 先自动提取；失败时退回手动入口 |
| 手动入口 | `小红书` | 只接受用户手动粘贴 |

### 素材类型路由

| 来源 | raw 目录 | 提取方式 |
|------|----------|----------|
| 学术文献 Markdown | `raw/literature/` | 直接读取，走学术专用两步摄取 |
| 网页文章 | `raw/articles/` | baoyu-url-to-markdown skill |
| X/Twitter | `raw/tweets/` | baoyu-url-to-markdown skill（需 Chrome 登录） |
| 微信公众号 | `raw/wechat/` | wechat-article-to-markdown |
| YouTube | `raw/articles/` | youtube-transcript skill |
| 小红书 | `raw/xiaohongshu/` | 用户手动粘贴内容 |
| 知乎 | `raw/zhihu/` | 用户手动粘贴内容 或 baoyu-url-to-markdown skill |
| PDF / 本地 PDF | `raw/pdfs/` | 直接读取 |
| Markdown/文本/HTML | `raw/notes/` | 直接读取 |
| 纯文本粘贴 | `raw/notes/` | 直接使用 |

## Query（查询）规则

1. 先读 `index.md`，定位相关条目
2. 用 Grep 在 `wiki/` 下搜索关键词
3. 阅读相关页面后综合回答
4. 回答中标注来源页面（引用链接）
5. 有价值的分析建议保存为新的 wiki 页面

## Lint（健康检查）规则

1. 检查范围：随机抽查 10 个页面 + 最近更新的 10 个页面
2. 检查项：
   - 页面间矛盾（不同页面说法不一致）
   - 孤立页面（没有其他页面链接到它）
   - 缺失概念页（被 `[[某概念]]` 链接但实际不存在）
   - 缺少交叉引用（相关页面之间没有互相链接）
   - index 一致性（index.md 记录与实际文件是否对应）
   - **引用一致性**（文献页中的引用是否建立了对应链接）
   - **方法可重复性标记**（实验/建模方法页是否有可重复性标注）
3. 输出中文报告，对每个问题给出修复建议
4. 如果发现问题，询问用户是否自动修复

## 领域专有名词词汇表

详见 `vocabulary-academic.md`。AI 生成图谱时应优先使用该文件中的术语，以提升 Mermaid 知识图谱的精度。

## 关系类型词汇表（可选，用于手动标注知识图谱）

| 类型关键词 | 含义 | Mermaid 写法示例 |
|-----------|------|-----------------|
| 实现       | A 是 B 的具体实现 | `A -->|实现| B` |
| 依赖       | A 依赖 B 才能工作 | `A -->|依赖| B` |
| 对比       | A 与 B 是同类可以比较 | `A -->|对比| B` |
| 矛盾       | A 与 B 存在观点冲突 | `A -->|矛盾| B` |
| 衍生       | A 从 B 演化而来 | `A -->|衍生| B` |
| 应用于     | A 被应用于 B | `A -->|应用于| B` |
| 改进       | A 改进了 B | `A -->|改进| B` |

使用原则：
- 只标最重要的 3-5 条关系，不要强行给所有箭头打标
- 不确定的关系保持默认 `-->` 箭头
- 自定义类型控制在 2 个以内，避免词汇表膨胀
- 标注后在 Obsidian / VS Code（Markdown Preview Enhanced）/ Typora 里重新渲染就能看到标签

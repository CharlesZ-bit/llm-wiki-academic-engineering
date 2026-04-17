# 后续优化规划

## Zotero 集成

### 目标
利用 Zotero MCP 服务，当用户搜索文献时，自动从 Zotero 中筛选相关条目并导入知识库。

### 工作流程

```
用户发起文献搜索请求
       │
       ▼
┌─────────────────────────────┐
│  1. Zotero MCP 筛选条目     │
│     - 根据关键词搜索 Zotero │
│     - 筛选带 #MinerU-Parse  │
│       标签的笔记文件        │
└─────────────────────────────┘
       │
       ▼
┌─────────────────────────────┐
│  2. 传输到知识库            │
│     - 将 MD 文件传到        │
│       raw/literature/      │
│     - 自动触发 ingest      │
└─────────────────────────────┘
```

### 插件依赖
- [cookjohn/zotero-mcp](https://github.com/cookjohn/zotero-mcp) - MCP 服务器
- [lisontowind/zotero-mineru](https://github.com/lisontowind/zotero-mineru) - 文献条目转 MD

### 待实现功能
- [ ] Zotero MCP 连接配置
- [ ] 关键词搜索与条目筛选逻辑
- [ ] #MinerU-Parse 标签识别
- [ ] MD 文件自动传输到 `raw/literature/`
- [ ] ingest 触发机制

---

## 参考文献管理

### 目标
在综述模板的工作流中，建立一套规范的学术引用体系。参考论文应放在最后，单独创建参考文献列表，并使用连接笔记（`[[链接]]`）进行关联。

### 待实现功能
- [ ] 综述模板增加参考文献章节
- [ ] 规范引用格式（作者、年份、标题、期刊/会议）
- [ ] 使用 `[[文献标题]]` 链接到 literature 页面
- [ ] 自动从 literature 页面提取参考文献元数据

---

## Literature 与 RAW 文件夹关联

### 目标
当 AI 在消化后的内容中遇到不详细或不明确的地方时，能够快速定位到 RAW 文件夹中的原始文献进行查阅。RAW 文件是最详细、最准确的来源。

### 设计思路
```
wiki/literature/  ←──link──→  raw/literature/
    摘要页              │           源文件
    (已消化)            │        (最详细)
                        │
                        ▼
              AI 可追溯到原始文献
```

### 待实现功能
- [ ] literature 页面增加指向 raw 文件的 `[[link]]`
- [ ] 设计从 literature 页面快速打开 raw 文件的方式
- [ ] ingest 时保留 raw 文件路径引用

---

*更新时间：2026-04-17*

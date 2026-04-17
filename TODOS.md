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
- [minerU-parse](https://github.com/TinManTex/zotero-MinerU) - 文献条目转 MD

### 待实现功能
- [ ] Zotero MCP 连接配置
- [ ] 关键词搜索与条目筛选逻辑
- [ ] #MinerU-Parse 标签识别
- [ ] MD 文件自动传输到 `raw/literature/`
- [ ] ingest 触发机制

---

*更新时间：2026-04-17*

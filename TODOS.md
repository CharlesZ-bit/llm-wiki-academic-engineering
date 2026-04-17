# 后续优化规划

## Zotero 集成

### 目标
利用 Zotero MCP 服务，自动将 Markdown 文献文件导入知识库。

### 工作流程
1. 用户通过 [Zotero MindMap](https://github.com/ter表现mindmap) 插件提取文献条目并转换为 MD 文件
2. 系统自动识别 MD 文件中的标签
3. 通过 MCP 服务器根据标签关联相关文献
4. 将处理后的 MD 文件传输到知识库的 `raw/literature/` 目录

### 待实现功能
- [ ] MCP 服务器配置与 Zotero 连接
- [ ] 标签识别与文献关联逻辑
- [ ] 自动导入工作流
- [ ] 增量同步机制

---

*更新时间：2026-04-17*

# TODOs

## After Multi-Platform Adaptation

- 评估是否需要为 OpenClaw 增加 workspace-skill fallback，而不只支持 shared skill 路径。
- 评估是否需要把安装器拆分成更正式的 `doctor` / `migrate` / `uninstall` 子命令。

## Phase B - 核心主线与外挂分离（已完成）

- 已冻结统一素材入口和单一来源总表
- 已明确外挂失败状态和统一回退路径
- 已锁住旧知识库兼容与迁移规则
- 已对齐安装、状态、说明和回归测试

## Phase C - 学术工程文献专用化（已完成）

- 已简化为学术文献专用版本（电气、机械、船舶、振动等工科领域）
- 已移除 URL/网页提取等非文献来源
- 已添加学术文献模板（DOI、置信度、可重复性标记）
- 已更新 README 添加致谢

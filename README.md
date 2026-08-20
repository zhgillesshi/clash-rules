# clash-rules

可版本化维护 OpenClash/Mihomo 的额外规则。

目录说明：

- `rules/providers/`：需要发布并由 OpenClash 定时拉取的规则集。
- `rules/openclash-priority.yaml`：本地开发时参考的覆写模板；实际部署时由 `render` 使用发布 URL 生成。

推荐流程：修改 provider → `uv run clash-rules validate` → 提交并推送 → 在 OpenClash 中点更新配置。

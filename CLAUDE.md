# clash-rules

## 职责

以 Git 管理 Mihomo/OpenClash 的额外 Rule Provider，并生成可粘贴进 OpenClash「Overwrite Settings → Custom Clash Rules」的覆写片段。

订阅负责节点和基础规则；本包只维护需要长期保留的例外规则。

## 用法

```bash
# 校验本地规则集
uv run clash-rules validate

# 生成 OpenClash 覆写片段（将 URL 换成该仓库发布后的 raw 地址）
uv run clash-rules render \
  --provider-url https://raw.githubusercontent.com/<owner>/<repo>/main/packages/clash-rules/rules/providers/mine-proxy.yaml
```

将生成内容粘贴到「Custom Clash Rules (Priority)」，勾选 `Use Custom Rules`，再依次点击 `Commit Settings` 和 `Apply Settings`。

## 规则约定

- `rules/providers/*.yaml` 使用 Mihomo Rule Provider 格式，根键为 `payload`。
- 每条 payload 使用 classical 规则语法，示例：`DOMAIN-SUFFIX,example.com`。
- 规则文件不写策略组；策略组在 OpenClash 覆写中统一指定。默认是当前路由器的 `auto` 组。
- 不在覆写中写 `MATCH`，避免覆盖订阅自身的兜底规则。

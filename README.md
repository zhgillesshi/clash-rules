# clash-rules

可版本化维护 OpenClash/Mihomo 的额外规则。

目录说明：

- `rules/providers/`：需要发布并由 OpenClash 定时拉取的规则集。
- `rules/openclash-priority.yaml`：本地开发时参考的覆写模板；实际部署时由 `render` 使用发布 URL 生成。

推荐流程：修改 provider → `uv run clash-rules validate` → 提交并推送 → 在 OpenClash 中点更新配置。

## 路由器侧持久策略组

`rules/openclash_custom_overwrite.sh` 是部署到路由器
`/etc/openclash/custom/openclash_custom_overwrite.sh` 的覆写脚本。它在每次
订阅更新后注入三个独立策略组：

- `ChatGPT`：日本节点可选组，并使用 `oc_openai` 远程规则集；
- `Reddit`：可手动选择节点，优先匹配 `reddit.com`、`redditstatic.com` 和
  `redditmedia.com`。
- `Steam`：默认使用 `auto`，也可切换为直连或任意节点；匹配 Steam 商店、
  社区、聊天、内容下载、Valve 网络、Steamworks 常用 TCP/UDP 端口，以及
  PICO PARK 2 跨平台联机使用的 Photon 域名和端口。

必须使用脚本中的 `ruby_arr_insert_hash`、`ruby_merge_hash` 和
`ruby_arr_insert` helper 写入最终配置；仅在 MetaCubeXD 或 OpenClash 的自定义
规则文本框中添加 YAML，不能保证订阅更新后仍然生效。

当前路由器可用 legacy SCP 部署并重启：

```sh
scp -O packages/clash-rules/rules/openclash_custom_overwrite.sh \
  root@192.168.8.1:/etc/openclash/custom/openclash_custom_overwrite.sh
ssh root@192.168.8.1 '/etc/init.d/openclash restart'
```

将当前 package 发布为独立仓库：

```bash
./scripts/publish-clash-rules
```

该脚本以 `packages/clash-rules` 为 Git subtree 的根目录推送到
`zhgillesshi/clash-rules`。独立仓库不包含 `daily_tools` 的其他内容。

# HarborCheck

HarborCheck 是一个 MoonBit 原生的 Mooncakes 发布就绪审计库。它把 `moon.mod`、README、GitHub Actions、测试说明、示例入口、许可证和发布记录整理成一个项目快照，然后输出可读的 Markdown 报告或机器可读的 JSON 摘要。

## 解决什么问题

MoonBit 包在参加开源大赛或发布到 mooncakes.io 前，常见风险不是代码无法写出来，而是 README 缺项、CI 不完整、示例不可运行、包名不一致、许可证说明不清楚。HarborCheck 将这些验收要求固化成可测试的 MoonBit 规则，帮助包作者在提交前用同一套标准检查项目。

## 适用场景

- MoonBit 库作者检查 Mooncakes 发布材料；
- 黑客松项目维护者整理 README、CI、测试和示例；
- 教学项目展示如何用 MoonBit 实现规则校验、报告导出和 smoke test；
- 外部脚本或 Web UI 收集仓库文件后，调用 HarborCheck 生成审计报告。

## 安装方式

```bash
moon add WVYT-ai-nb/harborcheck
```

Mooncakes 包名：`WVYT-ai-nb/harborcheck`

## 最小使用示例

```moonbit
test {
  let snapshot = @harborcheck.example_snapshot()
  let report = @harborcheck.audit(snapshot)
  inspect(report.verdict, content="ready")
}
```

一个完整的可运行示例位于 `examples/basic`：

```bash
moon run examples/basic
```

CLI smoke 入口位于 `cmd/main`：

```bash
moon run cmd/main
```

## 本地运行方式

```bash
moon check
moon build
moon test
moon run examples/basic
moon run cmd/main
moon publish --dry-run
```

## API 与核心功能

- `ProjectSnapshot(...)`：描述一个项目的审计输入，包含 `moon.mod`、README、CI、测试、示例、许可证和发布状态等字段；
- `parse_manifest(text)`：从 `moon.mod` 文本中提取包名、版本、README、仓库、许可证和描述；
- `audit(snapshot)`：运行所有内置规则，生成 `AuditReport`；
- `audit_markdown(snapshot)` / `AuditReport::to_markdown()`：导出 Markdown 审计报告；
- `audit_json(snapshot)` / `AuditReport::to_json()`：导出 JSON 摘要，便于 CI 或页面集成；
- `release_checklist(snapshot)` / `AuditReport::to_release_checklist()`：导出阻塞项和修复步骤；
- `example_snapshot()`：提供可运行、可测试的完整示例输入。

## 支持范围

- MoonBit 包配置字段检查：`name`、`version`、`readme`、`repository`、`license`、`description`；
- README 完整性检查：用途、安装、使用示例、API、支持范围、暂不支持范围、测试命令、许可证说明；
- GitHub Actions 内容检查：安装 MoonBit、`moon check`、`moon build`、`moon test`、示例运行；
- 测试与示例覆盖形态检查：正常输入、错误输入、边界情况、导出结果、示例 smoke；
- Git 和维护记录检查：公开仓库、提交数量、CHANGELOG、设计说明、Issue 记录；
- Mooncakes 发布一致性检查：包名和 owner 与 `moon.mod` 同步。

## 暂不支持范围

- 不直接访问 GitHub、Mooncakes 或本地文件系统；
- 不替代 `moon check`、`moon build`、`moon test` 的真实构建结果；
- 不执行 `moon login` 或 `moon publish`；
- 不做通用 TOML/YAML/Markdown 语法解析，只检查发布审计所需字段和关键词。

## 测试与验收命令

当前项目包含黑盒测试、白盒测试、示例 smoke 和 CLI smoke。验收前建议执行：

```bash
moon check
moon build
moon test
moon run examples/basic
moon run cmd/main
moon publish --dry-run
```

## 开源许可证和第三方说明

HarborCheck 使用 MIT License。项目为原创 MoonBit 实现，不移植第三方源码，不包含外部图片、音频、字体或私有素材。运行时仅依赖 MoonBit 标准核心库。

## Mooncakes 发布

发布命令：

```bash
moon login
moon publish --dry-run
moon publish
```

发布后检查：

```text
https://mooncakes.io/docs/WVYT-ai-nb/harborcheck
https://mooncakes.io/api/v0/manifest/WVYT-ai-nb/harborcheck
```

## 维护资料

- `CHANGELOG.md`：版本发布记录；
- `SUBMISSION.md`：项目申报书；
- `docs/API.md`：API 说明；
- `docs/design.md`：设计说明；
- `docs/research.md`：选题调研与差异化；
- `docs/issues.md`：Issue 记录；
- `docs/test-record.md`：测试记录；
- `docs/release-checklist.md`：发布检查清单。

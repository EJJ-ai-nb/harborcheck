# HarborCheck

HarborCheck 是一个 MoonBit 原生的 README 示例验证与开源来源证明工具包。它把文档里的 MoonBit 代码块、可运行示例、第三方来源记录、许可证说明和项目快照整理成可测试的数据模型，帮助维护者证明“文档能复现、来源可追踪、许可证说得清楚”。

## 解决什么问题

很多 MoonBit 项目的风险不是只有构建失败，还包括 README 示例无法复现、文档中的命令和源码状态不一致、测试数据或素材来源没有说明、许可证边界不清楚。HarborCheck 的重点是把这些证据变成 MoonBit 可检查的报告，而不是替代发布平台或自动发布工具。

## 项目边界

HarborCheck 现在主打两个能力：

- 文档示例证明：提取 README / docs 中的 fenced code block，识别 MoonBit 示例是否具备可运行形态；
- 来源证明：记录自有代码、第三方代码、数据集、素材和生成文本的来源、许可证和说明，输出合规风险。

项目仍保留 `audit` 快照检查，作为附属的提交材料清单能力，用来确认 README、CI、测试、示例、许可证和 Mooncakes 元数据是否完整。

## 安装方式

```bash
moon add EJJ-ai-nb/harborcheck
```

Mooncakes 包名：`EJJ-ai-nb/harborcheck`

## 最小使用示例

```moonbit
test {
  let markdown =
    #|# Usage
    #|
    #|```moonbit
    #|fn main {
    #|  println("verified")
    #|}
    #|```
    #|
  let report = @harborcheck.doc_proof(
    markdown,
    [
      @harborcheck.SourceEvidence(
        name="HarborCheck source",
        kind=@harborcheck.OwnedCode,
        license="MIT",
        note="Original MoonBit implementation by the project applicant",
      ),
    ],
  )
  inspect(report.verdict, content="ready")
}
```

完整示例位于 `examples/basic`：

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

- `extract_doc_snippets(markdown)`：提取 Markdown 代码块并标注语言、序号和可运行信号；
- `SourceEvidence(...)`：记录自有代码、第三方代码、数据、素材或生成文本的来源证明；
- `doc_proof(markdown, sources)`：生成文档示例与来源证明报告；
- `doc_proof_markdown(markdown, sources)` / `DocProofReport::to_markdown()`：导出 Markdown 证明报告；
- `ProjectSnapshot(...)`：描述一个项目的提交材料快照；
- `parse_manifest(text)`：从 `moon.mod` 文本中提取包名、版本、仓库、许可证和描述；
- `snapshot_from_bundle(text)`：解析 `--- file: path` 分隔的仓库快照文本；
- `audit(snapshot)`：对 README、CI、测试、示例、许可证和 Mooncakes 元数据做附属清单检查；
- `audit_markdown(snapshot)` / `audit_json(snapshot)`：导出提交材料检查报告；
- `release_checklist(snapshot)`：导出阻塞项和修复步骤。

## 支持范围

- README / docs 中 Markdown 代码块提取；
- MoonBit 示例可运行形态识别；
- 自有代码、第三方代码、数据集、素材、生成文本的来源证明建模；
- 许可证信号检查，支持常见 OSI 许可证和开放素材许可证；
- MoonBit 包配置字段检查：`name`、`version`、`readme`、`repository`、`license`、`description`；
- CI、测试、示例、维护记录和 Mooncakes 发布元数据清单检查；
- Markdown 和 JSON 风格的报告导出。

## 暂不支持范围

- 不直接联网访问 GitHub、Mooncakes 或本地文件系统；
- 不替代 `moon check`、`moon build`、`moon test` 的真实执行结果；
- 不自动执行 README 里的任意命令；
- 不执行 `moon login` 或 `moon publish`；
- 不做通用 Markdown 语法解析，只处理开源证明所需的 fenced code block 和证据字段。

## 测试与验收命令

当前项目包含黑盒测试、白盒测试、README 示例证明测试、来源证明风险测试、示例 smoke 和 CLI smoke。验收前建议执行：

```bash
moon check --deny-warn
moon build
moon test --deny-warn
moon fmt --check
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
https://mooncakes.io/docs/EJJ-ai-nb/harborcheck
https://mooncakes.io/api/v0/manifest/EJJ-ai-nb/harborcheck
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

# HarborCheck 项目申报书

## 基本信息

- 项目名称：HarborCheck：MoonBit README 示例验证与开源来源证明工具包
- 参赛者：张雨晴
- 联系方式：18055754016 / 2327797191@qq.com
- GitHub 仓库链接：https://github.com/EJJ-ai-nb/harborcheck
- Mooncakes 包名：EJJ-ai-nb/harborcheck
- 项目方向：MoonBit 原生文档验证工具 / 示例可复现检查 / 开源合规来源证明
- 是否为移植项目：否，原创 MoonBit 开源项目
- 开源许可证：MIT

## 项目简介

HarborCheck 面向 MoonBit 包作者和黑客松项目维护者，重点解决 README 示例不可复现、文档与代码状态不一致、第三方来源和许可证说明不完整、提交材料身份容易混淆的问题。项目核心由 MoonBit 实现，可以提取 Markdown 代码块、识别 MoonBit 示例的可运行形态、记录来源证明，并输出文档证明、身份一致性证明和最终验收总览报告。

## 项目边界调整说明

当前版本已将项目边界从通用发布材料检查，调整为“README 示例验证与开源来源证明”。`audit` 快照检查仍保留为附属能力，但项目核心卖点是文档示例和来源证明，不是自动发布工具，也不是通用发布审计替代品。

## 项目方向与适用场景

项目适合 MoonBit 库作者、黑客松参赛者、教学项目和工具开发者。维护者可以把 README、docs、来源记录和项目快照转换为 HarborCheck 输入，用同一套 MoonBit API 生成可复查的证明报告。

## 已实现核心功能

- 提取 README / docs 中的 fenced code block；
- 识别 MoonBit 示例是否具备 `fn main`、`test`、`inspect` 等可运行信号；
- 建模自有代码、第三方代码、数据集、素材和生成文本的来源证明；
- 检查来源链接、许可证和说明是否清晰；
- 生成文档示例与来源证明 Markdown 报告；
- 检查申报书、GitHub 仓库、`moon.mod`、Mooncakes 包名和 git 提交身份是否使用同一套信息；
- 合并仓库审计、文档证明、身份一致性、远程 CI、Mooncakes 构建状态、提交记录和有效代码规模，生成最终验收总览；
- 保留 MoonBit 包配置、README、CI、测试、示例、许可证和 Mooncakes 元数据清单检查；
- 提供黑盒测试、白盒测试、示例 smoke、CLI smoke、README、API 文档、设计说明、Issue 记录、CHANGELOG 和 GitHub Actions CI。

## 技术实现

项目以 MoonBit 为主要实现语言，运行时仅依赖 MoonBit 标准核心库。核心数据结构包括 `DocSnippet`、`SourceEvidence`、`DocProofReport`、`ProjectSnapshot`、`SubmissionIdentity`、`IdentityReport`、`AcceptanceProfile` 和 `AcceptanceReview`。核心 API 包括 `extract_doc_snippets`、`doc_proof`、`doc_proof_markdown`、`audit`、`audit_markdown`、`audit_json`、`acceptance_identity_report` 和 `final_acceptance_review`。

## 可运行示例与测试

本地可执行：

```bash
moon check --deny-warn
moon build
moon test --deny-warn
moon fmt --check
moon run examples/basic
moon run cmd/main
moon publish --dry-run
```

当前测试覆盖正常示例、错误来源、边界输入、Markdown 导出、JSON 导出、快照解析、身份一致性、最终验收总览和 smoke 入口。扩展后有效 MoonBit 代码约 3631 行，超过 3000 行目标，距离 4000 行参考规模约差 369 行。

## 原创或参考说明

本项目为原创 MoonBit 实现，不移植第三方源码，不包含来源不明素材或私有代码。项目使用 MIT License，运行时仅依赖 MoonBit 标准核心库。仓库中如出现示例文本，均作为项目测试夹具使用，并在代码与文档中说明来源边界。

## 后续维护价值

后续可以扩展 README 示例执行结果记录、更多许可证规则、CI 中的文档证明报告导出，以及与外部页面或脚本集成的 JSON 输出。项目功能边界清晰，能够持续服务 MoonBit 包文档质量、示例可复现性和开源合规证明。

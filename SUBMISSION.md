# HarborCheck 项目申报书

## 基本信息

- 项目名称：HarborCheck：MoonBit 包发布就绪审计库
- 参赛者：请填写参赛者姓名
- 联系方式：请填写联系方式
- GitHub 仓库链接：https://github.com/WVYT-ai-nb/harborcheck
- 项目方向：MoonBit 原生开发工具 / 规则校验库 / Mooncakes 发布辅助
- 是否为移植项目：否，原创 MoonBit 开源项目
- 开源许可证：MIT

## 项目简介

HarborCheck 面向 MoonBit 包作者，将 README、CI、测试、示例、许可证、Git 记录和 Mooncakes 发布要求抽象为一个可复用审计模型。项目核心由 MoonBit 实现，可输出 Markdown 和 JSON 报告，帮助参赛项目在验收前发现材料缺口。

## 项目方向与适用场景

项目适合 MoonBit 库作者、黑客松参赛者、教学项目和工具开发者。外部脚本可以收集仓库文件内容并构造 `ProjectSnapshot`，HarborCheck 负责执行规则校验和报告导出。

## 拟实现的核心功能

- 解析 `moon.mod` 中的包名、版本、仓库、许可证和描述；
- 校验 README、CI、测试、示例、许可证和维护记录完整性；
- 生成带评分、结论、问题和修复建议的审计报告；
- 提供 Markdown 与 JSON 两种导出格式；
- 提供测试、示例、README、CI 和 Mooncakes 发布配置。

## 项目现有基础与本次计划

项目已包含 MoonBit 工程、核心审计模型、规则引擎、报告导出、黑盒/白盒测试、`examples/basic` 示例、`cmd/main` smoke 入口、README、API 文档、设计说明、Issue 记录、CHANGELOG、GitHub Actions CI 和 Mooncakes 发布元数据。

## 原创或参考说明

本项目为原创 MoonBit 实现，不移植第三方源码，不包含来源不明素材或私有代码。已通过 Mooncakes 模块列表和关键词调研确认无同名包；相近的 release、doctor、audit 类包更偏自动发布、模块检查或其他领域审计，HarborCheck 的差异点是面向验收材料的纯 MoonBit 快照审计和修复清单。项目使用 MIT License，运行时仅依赖 MoonBit 标准核心库。

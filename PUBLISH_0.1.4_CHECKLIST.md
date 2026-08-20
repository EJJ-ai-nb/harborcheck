# HarborCheck 0.1.4 推送与发布清单

日期：2026-08-20

## 固定信息

- 参赛者：张雨晴
- 联系方式：18055754016 / 2327797191@qq.com
- GitHub 仓库：https://github.com/EJJ-ai-nb/harborcheck
- Mooncakes 包名：EJJ-ai-nb/harborcheck
- 本次准备发布版本：0.1.4

## 本次新增

- 新增维护证据模型：Issue、测试记录、更新日志、版本发布、CI、设计说明和许可证记录。
- 新增维护证据 Markdown / JSON 导出。
- 示例和 CLI 增加 `maintenance=trace-ready` 输出。
- 有效 MoonBit 代码超过 4000 行参考规模。

## 发布前本地证据

- 有效 MoonBit 代码：4411 行
- 超过 4000 行参考规模：411 行
- 本地测试：29 passed, 0 failed
- `moon check --deny-warn`：通过
- `moon build`：通过
- `moon fmt --check`：通过
- `moon doc`：通过
- `moon run examples/basic`：通过
- `moon run cmd/main`：通过
- `moon publish --dry-run`：服务端返回 202 Accepted，0.1.4 发布前校验通过，未实际发布

## 发布步骤

1. 确认 GitHub 登录和凭据为 `EJJ-ai-nb`。
2. 提交本地改动，建议提交信息：`feat: add maintenance evidence review`.
3. 推送到 `https://github.com/EJJ-ai-nb/harborcheck` 的 `main` 分支。
4. 等 GitHub Actions CI 跑绿。
5. 确认 Mooncakes 登录可发布 `EJJ-ai-nb/harborcheck`。
6. 执行 `moon publish` 发布 `0.1.4`。
7. 检查 Mooncakes manifest 中最新版本为 `0.1.4` 且构建状态为 `success`。

## 不需要更改

- 项目名称不用改。
- GitHub 仓库链接不用改。
- Mooncakes 包名不用改。
- 申报人、手机号、邮箱不用改。

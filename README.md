# KazumiRules
Kazumi的规则托管仓库，欢迎贡献 ^•ﻌ•^

## Contributing Guidelines 贡献指南

- 仅提交或更新规则文件（*.json）
  > Only submit or update rule files (*.json)
- 请勿手动修改 `index.json` 和 `README.md`
  > DO NOT manually modify `index.json` or `README.md`
- 这些文件会在您的 PR 被合并后自动更新
  > These files will be automatically updated after your PR is merged

| API Level | Kazumi Version   | Post Support*     | Referer Support | Legacy Parser Support†   |
|-----------|------------------|-------------------|-----------------|--------------------------|
| 1         | >= 1.0.0         | ❌                |❌              | ❌                      |
| 2         | >= 1.3.0         | ✅                |❌              | ❌                      |
| 3         | >= 1.3.6         | ✅                |✅              | ✅                      |

### Feature Descriptions:

**Post Support***: Available from API Level 2 and above.  
  This feature allows the use of POST requests instead of GET for querying search results, enabling more flexible data transmission. For example, see the implementation in mandao.json.

**Legacy Parser Support**†: Available from API Level 3 and above.  
  This feature introduces a legacy parser using an iframe src-based approach, which can outperform the common JavaScript hook-based parser in certain scenarios. It’s particularly useful for cases like xfdm.json.

## Available Rules

| Name | Version | Last Update |
|------|---------|-------------|
| 1ANI | 1.4 | 2024-11-13 |
| 9ciyuan | 1.3 | 2025-03-03 |
| AGE | 1.1 | 2024-07-20 |
| akiamime | 1.1 | 2024-11-07 |
| AnFuns | 0.1 | 2024-11-16 |
| ant | 0.0.2 | 2025-01-11 |
| ciyuancheng | 1.4 | 2025-01-11 |
| clicli | 0.5 | 2024-11-01 |
| DM84 | 1.1 | 2025-04-14 |
| dms | 1.0 | 2024-09-03 |
| FQDM | 1.1 | 2024-11-05 |
| giriGiriLove | 0.0.5 | 2024-11-05 |
| kimani | 0.0.1 | 2024-05-25 |
| libvio | 0.1 | 2025-04-14 |
| mandao | 1.1 | 2024-09-07 |
| mcy | 1.0 | 2024-09-29 |
| mwcy | 0.0.6 | 2024-11-20 |
| MXdm | 1.1 | 2024-07-30 |
| NT | 1.2 | 2025-03-21 |
| omofunz | 1.0 | 2024-09-30 |
| pekolove | 1.0 | 2024-09-26 |
| qdm | 1.0 | 2025-04-11 |
| WEDM | 1.1 | 2024-09-01 |
| xfdm | 1.3 | 2024-12-18 |
| xiapidm | 1.0 | 2024-07-20 |
| xigua | 1.0 | 2025-04-14 |
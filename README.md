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
| 4         | >= 1.6.8         | ✅                |✅              | ✅                      |

### Feature Descriptions:

**Post Support***: Available from API Level 2 and above.  
  This feature allows the use of POST requests instead of GET for querying search results, enabling more flexible data transmission. For example, see the implementation in mandao.json.

**Legacy Parser Support**†: Available from API Level 3 and above.  
  This feature introduces a legacy parser using an iframe src-based approach, which can outperform the common JavaScript hook-based parser in certain scenarios. It’s particularly useful for cases like xfdm.json.

## Available Rules

| Name | Version | Last Update |
|------|---------|-------------|
| 7sefun | 1.1 | 2025-06-07 |
| aafun | 1.0 | 2025-04-30 |
| AGE | 1.4 | 2025-07-19 |
| ant | 0.0.2 | 2025-01-11 |
| ciyuancheng | 1.5 | 2025-06-22 |
| dlma | 1.0 | 2025-05-18 |
| DM84 | 1.1 | 2025-04-14 |
| ffdm | 1.0 | 2025-04-24 |
| giriGiriLove | 0.0.6 | 2025-06-09 |
| libvio | 0.2 | 2025-04-14 |
| mandao | 1.2 | 2025-06-07 |
| mwcy | 0.0.6 | 2024-11-20 |
| MXdm | 2.1 | 2025-07-19 |
| NT | 1.2 | 2025-03-21 |
| qdm | 1.0 | 2025-04-11 |
| qimi | 1.1 | 2025-04-30 |
| WYDM | 1.2 | 2025-07-27 |
| xfdm | 1.6 | 2025-06-07 |
| yinghua | 1.2 | 2025-06-07 |
| ylsp | 1.0 | 2025-06-21 |
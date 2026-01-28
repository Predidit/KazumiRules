# KazumiRules
Kazumi的规则托管仓库，欢迎贡献 ^•ﻌ•^

## Contributing Guidelines 贡献指南

- 仅提交或更新规则文件（*.json）
  > Only submit or update rule files (*.json)
- 请勿手动修改 `index.json` 和 `README.md`
  > DO NOT manually modify `index.json` or `README.md`
- 这些文件会在您的 PR 被合并后自动更新
  > These files will be automatically updated after your PR is merged

| API Level | Kazumi Version   | Post Support*     | Referer Support | Legacy Parser Support†   | HLS Ad Filtering |
|-----------|------------------|-------------------|-----------------|--------------------------|------------------|
| 1         | >= 1.0.0         | ❌                |❌              | ❌                      | ❌               |
| 2         | >= 1.3.0         | ✅                |❌              | ❌                      | ❌               |
| 3         | >= 1.3.6         | ✅                |✅              | ✅                      | ❌               |
| 4         | >= 1.6.8         | ✅                |✅              | ✅                      | ❌               |
| 5         | >= 1.9.3         | ✅                |✅              | ✅                      | ✅               |

### Feature Descriptions:

**Post Support***: Available from API Level 2 and above.  
  This feature allows the use of POST requests instead of GET for querying search results, enabling more flexible data transmission. For example, see the implementation in mandao.json.

**Legacy Parser Support**†: Available from API Level 3 and above.  
  This feature introduces a legacy parser using an iframe src-based approach, which can outperform the common JavaScript hook-based parser in certain scenarios. It’s particularly useful for cases like xfdm.json.

**HLS Ad Filtering**: Available from API Level 5 and above.  
  Filters advertisements in HLS manifests before playback, reducing ad segments without impacting main content delivery.

## Available Rules

| Name | Version | Last Update |
|------|---------|-------------|
| 7sefun | 1.1 | 2025-06-07 |
| aafun | 1.0 | 2025-04-30 |
| AGE | 1.5 | 2025-09-17 |
| aowu | 1.0 | 2025-11-15 |
| giriGiriLove | 1.0 | 2025-11-04 |
| gugu3 | 1.2 | 2025-12-17 |
| hfkzm | 1.1 | 2025-12-11 |
| libvio | 0.3 | 2025-07-30 |
| MXdm | 2.1 | 2025-07-19 |
| NT | 1.2 | 2025-03-21 |
| omofun03 | 1.0 | 2025-10-13 |
| skr | 0.5 | 2025-09-20 |
| WYDM | 1.2 | 2025-07-27 |
| xfdm | 1.7 | 2025-09-22 |
| yishijie | 1.1 | 2025-08-03 |
| ylsp | 1.1 | 2025-10-05 |
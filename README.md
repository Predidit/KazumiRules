# KazumiRules
Kazumi的规则托管仓库，欢迎贡献 ^•ﻌ•^

## Index File Management
The `index.json` file in this repository is automatically generated and maintained. **DO NOT edit it manually**.

To update the index file, run:
```bash
dart run script/update_index.dart
```

The script will automatically:
- Scan all rule files (*.json)
- Extract essential information (name, version, etc.)
- Record last update time
- Sort by name
- Commit changes

| API Level | Kazumi Version   | Post Support*     | Referer Support | Legacy Parser Support†   |
|-----------|------------------|-------------------|-----------------|--------------------------|
| 1         | >= 1.0.0         | ❌                |❌              | ❌                      |
| 2         | >= 1.3.0         | ✅                |❌              | ❌                      |
| 3         | >= 1.3.6         | ✅                |✅              | ✅                      |

### Feature Descriptions:

**Post Support***: Available from API Level 2 and above.  
  This feature allows the use of POST requests instead of GET for querying search results, enabling more flexible data transmission. For example, see the implementation in mandao.json.

**Legacy Parser Support**†: Available from API Level 3 and above.  
  This feature introduces a legacy parser using an iframe src-based approach, which can outperform the common JavaScript hook-based parser in certain scenarios. It's particularly useful for cases like xfdm.json.

## Available Rules

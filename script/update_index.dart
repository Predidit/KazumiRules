import 'dart:io';
import 'dart:convert';

void main() async {
  // 获取脚本和项目根目录路径
  final scriptFile = File(Platform.script.toFilePath());
  final scriptDir = scriptFile.parent;
  final rootDir = scriptDir.parent;

  // 保存当前工作目录
  final originalDir = Directory.current;
  
  try {
    // 切换到项目根目录
    Directory.current = rootDir;
    
    // 获取所有JSON文件
    final List<FileSystemEntity> files = Directory.current
        .listSync()
        .where((file) =>
            file.path.toLowerCase().endsWith('.json') &&
            !file.path.endsWith('index.json'))
        .toList();

    // 用于存储结果的数组
    final List<Map<String, dynamic>> result = [];

    // 处理每个文件
    for (final file in files) {
      final filename = file.path.split(Platform.pathSeparator).last;
      print('处理文件: $filename');

      try {
        // 读取并解析JSON
        final content = File(filename).readAsStringSync();
        final Map<String, dynamic> json = jsonDecode(content);

        // 检查是否已过时
        if (json['deprecated'] == true) {
          print('跳过已过时的规则: $filename');
          continue;
        }

        // 检查必需字段
        final name = json['name'];
        final version = json['version'];
        final useNativePlayer = json['useNativePlayer'];

        // 检查字段是否存在且有效
        if (name == null || name.toString().isEmpty) {
          print('警告: $filename 缺少name字段，跳过');
          continue;
        }

        if (version == null || version.toString().isEmpty) {
          print('警告: $filename 缺少version字段，跳过');
          continue;
        }

        if (useNativePlayer == null) {
          print('警告: $filename 缺少useNativePlayer字段，跳过');
          continue;
        }

        if (useNativePlayer is! bool) {
          print('警告: $filename 的useNativePlayer字段不是布尔值，跳过');
          continue;
        }

        // 获取git最后修改时间
        int timestamp;
        try {
          final result = await Process.run('git', [
            'log',
            '-1',
            '--format=%at',
            filename
          ]);
          if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
            timestamp = int.parse(result.stdout.toString().trim()) * 1000;
          } else {
            print('警告: $filename 无法获取git时间戳，使用当前时间');
            timestamp = DateTime.now().millisecondsSinceEpoch;
          }
        } catch (e) {
          print('警告: $filename 无法获取git时间戳，使用当前时间');
          timestamp = DateTime.now().millisecondsSinceEpoch;
        }

        // 构建条目
        final entry = {
          'name': name,
          'version': version,
          'useNativePlayer': useNativePlayer,
          'author': json['author'] ?? '',
          'lastUpdate': timestamp,
        };

        result.add(entry);

        // 格式化时间输出
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final formattedTime =
            '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} '
            '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}:${_pad(dateTime.second)}';

        print('✓ ${entry['name']} (v${entry['version']}) - 最后更新: $formattedTime');
      } catch (e) {
        print('警告: $filename 处理失败，跳过 ($e)');
        continue;
      }
    }

    // 按name排序（不区分大小写）
    result.sort((a, b) =>
        a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));

    // 写入 index.json
    final encoder = JsonEncoder.withIndent('  ');
    File('index.json').writeAsStringSync(encoder.convert(result) + '\n');

    print('\nindex.json 更新完成！');

    // 更新 README.md 中的规则表格
    await updateReadmeTable(result);

    print('\nREADME.md 更新完成！\n');

    // 检查是否有更改并提交
    final statusResult = await Process.run('git', ['status', '--porcelain', 'index.json', 'README.md']);
    if (statusResult.stdout.toString().trim().isNotEmpty) {
      print('检测到文件有更新，准备提交...');
      
      // 添加并提交更改
      await Process.run('git', ['add', 'index.json', 'README.md']);
      final commitResult = await Process.run(
          'git', ['commit', '-m', 'chore: update index.json and README.md']);
      
      if (commitResult.exitCode == 0) {
        print('Git提交成功！');
      } else {
        print('警告: Git提交失败 (${commitResult.stderr})');
      }
    } else {
      print('文件无更新，无需提交。');
    }
  } catch (e) {
    print('错误: 处理失败 ($e)');
    exit(1);
  } finally {
    // 恢复原始工作目录
    Directory.current = originalDir;
  }
}

// 辅助函数：补零
String _pad(int number) {
  return number.toString().padLeft(2, '0');
}

// 更新 README.md 中的规则表格
Future<void> updateReadmeTable(List<Map<String, dynamic>> rules) async {
  final readmeFile = File('README.md');
  if (!readmeFile.existsSync()) {
    print('警告: README.md 不存在');
    return;
  }

  final content = readmeFile.readAsStringSync();
  final lines = content.split('\n');

  // 找到 "## Available Rules" 的位置
  final rulesSectionIndex = lines.indexWhere((line) => line.trim() == '## Available Rules');
  if (rulesSectionIndex == -1) {
    print('警告: 在 README.md 中未找到 "## Available Rules" 部分');
    return;
  }

  // 构建新的表格内容
  final tableLines = [
    '',
    '| Name | Version | Last Update |',
    '|------|---------|-------------|',
  ];

  // 添加规则行
  for (final rule in rules) {
    final timestamp = rule['lastUpdate'] as int;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formattedDate = '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)}';
    
    tableLines.add('| ${rule['name']} | ${rule['version']} | $formattedDate |');
  }

  // 找到下一个标题或文件末尾
  var nextSectionIndex = lines.indexWhere((line) => line.startsWith('#') && line != '## Available Rules', rulesSectionIndex + 1);
  if (nextSectionIndex == -1) {
    nextSectionIndex = lines.length;
  }

  // 替换旧的表格内容
  final newLines = [
    ...lines.sublist(0, rulesSectionIndex + 1),
    ...tableLines,
    if (nextSectionIndex < lines.length) '',
    ...lines.sublist(nextSectionIndex),
  ];

  // 写入文件
  readmeFile.writeAsStringSync(newLines.join('\n'));
} 
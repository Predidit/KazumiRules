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

    // 读取 index.json
    final indexContent = File('index.json').readAsStringSync();
    final indexList = json.decode(indexContent) as List;
    
    // 创建活跃规则名称集合
    final activeRules = Set<String>.from(
      indexList.map((rule) => rule['name'] as String)
    );

    // 获取所有规则JSON文件
    final List<FileSystemEntity> files = Directory.current
        .listSync()
        .where((file) =>
            file.path.toLowerCase().endsWith('.json') &&
            !file.path.endsWith('index.json'))
        .toList();

    // 记录修改的文件
    final List<String> modifiedFiles = [];

    // 处理每个文件
    for (final file in files) {
      final filename = file.path.split(Platform.pathSeparator).last;
      final ruleName = filename.substring(0, filename.length - 5);
      
      print('处理文件: $filename');

      try {
        // 读取并解析JSON
        final content = File(filename).readAsStringSync();
        Map<String, dynamic> ruleContent = json.decode(content);

        final bool isDeprecated = !activeRules.contains(ruleName);
        
        // 检查是否需要更新
        bool needsUpdate = false;
        if (isDeprecated && !ruleContent.containsKey('deprecated')) {
          needsUpdate = true;
          final newContent = {
            'deprecated': true,
            ...ruleContent,
          };
          File(filename).writeAsStringSync(
            JsonEncoder.withIndent('    ').convert(newContent) + '\n'
          );
          print('✓ 已标记 $filename 为过时');
          modifiedFiles.add(filename);
        } else if (!isDeprecated && ruleContent.containsKey('deprecated')) {
          needsUpdate = true;
          ruleContent.remove('deprecated');
          File(filename).writeAsStringSync(
            JsonEncoder.withIndent('    ').convert(ruleContent) + '\n'
          );
          print('✓ 已移除 $filename 的过时标记');
          modifiedFiles.add(filename);
        } else {
          print('✓ $filename 无需更新');
        }
      } catch (e) {
        print('警告: $filename 处理失败，跳过 ($e)');
        continue;
      }
    }

    // 如果有文件被修改，统一提交到git
    if (modifiedFiles.isNotEmpty) {
      // 添加所有修改的文件
      for (final filename in modifiedFiles) {
        await Process.run('git', ['add', filename]);
      }
      
      // 提交修改
      final commitResult = await Process.run(
          'git', ['commit', '-m', 'chore: update deprecated status for rules']);
      
      if (commitResult.exitCode == 0) {
        print('\nGit提交成功！');
      } else {
        print('\n警告: Git提交失败 (${commitResult.stderr})');
      }
    } else {
      print('\n没有文件需要更新。');
    }

    print('\n处理完成！');
  } catch (e) {
    print('错误: 处理失败 ($e)');
    exit(1);
  } finally {
    // 恢复原始工作目录
    Directory.current = originalDir;
  }
} 
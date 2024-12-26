#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# 获取项目根目录的绝对路径
ROOT_DIR=$(cd ${SCRIPT_DIR}/..; pwd)
# 临时文件路径
TEMP_FILE="${ROOT_DIR}/script/.temp_index.json"

# 切换到项目根目录
cd "${ROOT_DIR}"

# 创建一个临时数组用于存储结果
echo "[]" > "${TEMP_FILE}"

# 获取所有json文件（除了index.json和临时文件）
for file in ${ROOT_DIR}/*.json; do
    filename=$(basename "$file")
    if [[ "$filename" != "index.json" && "$filename" != ".temp_index.json" ]]; then
        echo "处理文件: $filename"
        
        # 检查文件是否为有效的JSON
        if ! jq empty "$file" 2>/dev/null; then
            echo "警告: $filename 不是有效的JSON文件，跳过"
            continue
        fi
        
        # 检查是否已过时
        deprecated=$(jq '.deprecated' "$file")
        if [ "$deprecated" = "true" ]; then
            echo "跳过已过时的规则: $filename"
            continue
        fi
        
        # 检查必需字段
        name=$(jq -r '.name' "$file")
        version=$(jq -r '.version' "$file")
        useNativePlayer=$(jq '.useNativePlayer' "$file")
        
        # 检查字段是否存在且有效
        if [ "$name" = "null" ] || [ -z "$name" ]; then
            echo "警告: $filename 缺少name字段，跳过"
            continue
        fi
        
        if [ "$version" = "null" ] || [ -z "$version" ]; then
            echo "警告: $filename 缺少version字段，跳过"
            continue
        fi
        
        if [ "$useNativePlayer" = "null" ]; then
            echo "警告: $filename 缺少useNativePlayer字段，跳过"
            continue
        fi
        
        # 获取git最后修改时间戳（Unix时间戳，毫秒）
        timestamp=$(git log -1 --format="%at" "$file" 2>/dev/null | xargs -I{} echo "{}"000)
        if [ -z "$timestamp" ]; then
            echo "警告: $filename 无法获取git时间戳，使用当前时间"
            timestamp=$(date +%s000)
        fi
        
        # 构建新的JSON对象
        new_entry=$(jq -n \
            --arg name "$name" \
            --arg version "$version" \
            --argjson useNativePlayer "$useNativePlayer" \
            --arg author "$(jq -r '.author // empty' "$file")" \
            --arg lastUpdate "$timestamp" \
            '{
                name: $name,
                version: $version,
                useNativePlayer: $useNativePlayer,
                author: $author,
                lastUpdate: ($lastUpdate|tonumber)
            }')
        
        # 将新对象添加到数组中
        jq --argjson new "$new_entry" '. + [$new]' "${TEMP_FILE}" > "${TEMP_FILE}.new"
        if [ $? -ne 0 ]; then
            echo "警告: $filename 处理失败，跳过"
            continue
        fi
        
        mv "${TEMP_FILE}.new" "${TEMP_FILE}"
        
        # 转换时间戳为可读格式（去掉毫秒部分并转换为本地时间）
        readable_time=$(date -r $(echo $timestamp | cut -c1-10) '+%Y-%m-%d %H:%M:%S')
        echo "✓ $name (v$version) - 最后更新: $readable_time"
    fi
done

# 按name字段排序（确保大小写不敏感）并格式化输出
jq 'sort_by(.name|ascii_downcase)' "${TEMP_FILE}" > "${ROOT_DIR}/index.json"

# 清理临时文件
rm -f "${TEMP_FILE}"
rm -f "${TEMP_FILE}.new"

echo -e "\nindex.json 更新完成！"

# 检查是否有更改并提交
if [ -n "$(git status --porcelain index.json)" ]; then
    echo "检测到index.json有更新，准备提交..."
    
    # 添加并提交更改
    git add index.json
    if git commit -m "chore: update index.json"; then
        echo "Git提交成功！"
    else
        echo "警告: Git提交失败"
    fi
else
    echo "index.json 无更新，无需提交。"
fi 
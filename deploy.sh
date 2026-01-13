#!/bin/bash
echo "🚀 开始发布到 GitHub Pages..."

# 检查是否已初始化 git
if [ ! -d ".git" ]; then
    echo "初始化 Git 仓库..."
    git init
fi

# 添加所有文件
git add .

# 提交
read -p "请输入提交信息（直接回车使用默认）: " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="更新项目"
fi
git commit -m "$commit_msg"

# 检查是否已设置远程仓库
if ! git remote | grep -q origin; then
    read -p "请输入你的 GitHub 用户名: " username
    git remote add origin https://github.com/$username/cost_calc.git
fi

# 推送
git branch -M main
git push -u origin main

echo "✅ 代码已推送到 GitHub！"
echo "📝 现在去 GitHub 仓库设置中启用 Pages："
echo "   Settings → Pages → Source: main → Save"
echo "   几分钟后访问：https://yourusername.github.io/cost_calc/"

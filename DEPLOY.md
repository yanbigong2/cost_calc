# 🚀 快速发布指南

## 最简单的方式：GitHub Pages（5分钟搞定）

### 1️⃣ 准备 Git（如果还没有）

```bash
# 检查是否已安装 git
git --version

# 如果没有，Mac 用户：
# brew install git

# Windows 用户：下载安装 https://git-scm.com/
```

### 2️⃣ 初始化并推送到 GitHub

```bash
# 进入项目目录
cd /Users/yanbin/Desktop/cost_calc

# 初始化 git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: 全球生活成本计算器"

# 在 GitHub 创建新仓库后，执行（替换 yourusername）
git remote add origin https://github.com/yourusername/cost_calc.git
git branch -M main
git push -u origin main
```

### 3️⃣ 启用 GitHub Pages

1. 打开你的 GitHub 仓库页面
2. 点击 `Settings` → `Pages`
3. Source 选择 `main` 分支，文件夹选择 `/ (root)`
4. 点击 `Save`
5. 等待 2-3 分钟，访问：`https://yourusername.github.io/cost_calc/`

### 4️⃣ 配置 defaults.json 加载（可选）

编辑 `index.html`，找到第 714 行，取消注释并替换 URL：

```javascript
const response = await fetch('https://raw.githubusercontent.com/yourusername/cost_calc/main/defaults.json');
```

然后重新提交：

```bash
git add index.html
git commit -m "启用 GitHub Raw JSON 加载"
git push
```

## 🎯 一键发布脚本

创建一个 `deploy.sh` 文件（Mac/Linux）：

```bash
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
```

使用方法：

```bash
chmod +x deploy.sh
./deploy.sh
```

## 🌐 其他发布选项

### Netlify（推荐，支持自动部署）

1. 访问 https://www.netlify.com/
2. 点击 "Add new site" → "Import an existing project"
3. 连接 GitHub，选择你的仓库
4. 构建设置留空，直接 Deploy
5. 完成！每次 push 会自动更新

### Vercel

1. 访问 https://vercel.com/
2. 导入 GitHub 仓库
3. 框架选择 "Other"
4. Deploy

## 📱 在微信中使用

1. 发布到 GitHub Pages 或 Netlify
2. 获取网站 URL
3. 在微信中打开链接即可使用
4. 或者在小程序中嵌入 WebView

## ✅ 发布检查清单

- [ ] 代码已推送到 GitHub
- [ ] GitHub Pages 已启用
- [ ] 网站可以正常访问
- [ ] defaults.json URL 已配置（可选）
- [ ] 测试所有功能是否正常

## 🎉 完成！

发布成功后，你可以：
- 分享链接给朋友使用
- 在微信中打开
- 嵌入到其他网站
- 继续更新和维护

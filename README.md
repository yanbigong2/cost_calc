# 全球生活成本与收入锚定计算器

一个单页 HTML 应用，用于对比不同城市在同一收入基准下的生活成本和储蓄潜力。

## 🚀 快速开始

直接在浏览器中打开 `index.html` 即可使用，无需服务器。

## 📦 发布到 GitHub Pages（推荐）

### 步骤 1：创建 GitHub 仓库

1. 登录 GitHub，点击右上角 `+` → `New repository`
2. 仓库名称：`cost_calc`（或你喜欢的名字）
3. 选择 `Public`（GitHub Pages 免费版需要公开仓库）
4. **不要**勾选 "Initialize this repository with a README"
5. 点击 `Create repository`

### 步骤 2：上传代码到 GitHub

在项目目录下执行：

```bash
# 初始化 git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: 全球生活成本计算器"

# 添加远程仓库（替换 yourusername 为你的 GitHub 用户名）
git remote add origin https://github.com/yourusername/cost_calc.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 步骤 3：启用 GitHub Pages

1. 在 GitHub 仓库页面，点击 `Settings`（设置）
2. 左侧菜单找到 `Pages`
3. 在 `Source` 下选择：
   - Branch: `main`
   - Folder: `/ (root)`
4. 点击 `Save`
5. 等待几分钟，GitHub 会显示你的网站地址：
   ```
   https://yourusername.github.io/cost_calc/
   ```

### 步骤 4：配置 defaults.json 的 GitHub Raw URL

1. 打开 `index.html`
2. 找到 `loadDefaults()` 函数（约第 708 行）
3. 取消注释并替换 URL：

```javascript
async function loadDefaults() {
    const statusEl = document.getElementById('loadStatus');
    statusEl.innerHTML = '<span class="loading"></span> 加载中...';
    
    try {
        // 替换 yourusername 为你的 GitHub 用户名
        const response = await fetch('https://raw.githubusercontent.com/yourusername/cost_calc/main/defaults.json');
        const data = await response.json();
        mergeDefaults(data);
        
        // 尝试从 localStorage 加载用户参数
        loadFromLocalStorage();
        
        statusEl.innerHTML = '<span style="color:#16a34a;">✓ 已加载</span>';
        setTimeout(() => { statusEl.innerHTML = ''; }, 2000);
    } catch (e) {
        console.error('加载默认值失败:', e);
        useBuiltinDefaults();
        loadFromLocalStorage();
        statusEl.innerHTML = '<span style="color:#dc2626;">⚠ 使用内置默认值</span>';
        setTimeout(() => { statusEl.innerHTML = ''; }, 3000);
    }
}
```

4. 保存并重新提交：

```bash
git add index.html
git commit -m "配置 GitHub Raw URL"
git push
```

## 🌐 其他发布方式

### 方式 2：Netlify（推荐，支持自定义域名）

1. 访问 [Netlify](https://www.netlify.com/)
2. 注册/登录账号
3. 点击 `Add new site` → `Import an existing project`
4. 连接 GitHub 仓库，选择 `cost_calc`
5. 构建设置：
   - Build command: （留空）
   - Publish directory: `/`（根目录）
6. 点击 `Deploy site`
7. 几分钟后即可访问，Netlify 会提供一个免费域名

**优点：**
- 自动部署（每次 push 自动更新）
- 免费 HTTPS
- 支持自定义域名
- 全球 CDN 加速

### 方式 3：Vercel

1. 访问 [Vercel](https://vercel.com/)
2. 注册/登录账号
3. 点击 `New Project`
4. 导入 GitHub 仓库
5. 框架预设选择 `Other`
6. 点击 `Deploy`

### 方式 4：直接托管到服务器

如果你有自己的服务器：

1. 将 `index.html` 和 `defaults.json` 上传到服务器
2. 确保服务器支持静态文件访问
3. 通过域名访问即可

### 方式 5：微信小程序 WebView

如果要在微信中使用：

1. 发布到 GitHub Pages 或 Netlify
2. 在小程序中嵌入 WebView 组件
3. 设置 `src` 为你的网站地址

## 📝 更新项目

发布后，如果需要更新：

```bash
# 修改代码后
git add .
git commit -m "更新说明"
git push
```

- **GitHub Pages**: 自动更新（可能需要几分钟）
- **Netlify/Vercel**: 自动部署（通常几秒钟）

## 🔧 自定义配置

### 修改默认数据

编辑 `defaults.json` 文件，修改：
- 城市配置（Big Mac 价格、平均收入等）
- 默认生活成本
- 货币汇率
- 香港折扣系数

### 添加新城市

1. 在 `defaults.json` 的 `cities` 中添加新城市
2. 在 `defaultCosts.single` 和 `defaultCosts.family` 中添加对应的成本数据
3. 在 `index.html` 的 `CITIES_CONFIG` 中添加配置
4. 更新税务计算引擎（如果需要）

## 📱 移动端优化

项目已包含响应式设计，支持：
- ✅ 移动浏览器
- ✅ 微信内置浏览器
- ✅ 平板设备
- ✅ 桌面浏览器

## 🐛 故障排除

### GitHub Pages 显示 404

- 确保仓库是 `Public`
- 确保 `index.html` 在根目录
- 等待 5-10 分钟让 GitHub 完成部署

### defaults.json 加载失败

- 检查 GitHub Raw URL 是否正确
- 确保 `defaults.json` 文件在仓库中
- 检查浏览器控制台错误信息
- 应用会自动回退到内置默认值

### 数据不保存

- 检查浏览器是否允许 localStorage
- 尝试清除浏览器缓存后重试

## 📄 许可证

MIT License - 可自由使用和修改

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**提示**: 推荐使用 **GitHub Pages** 或 **Netlify**，两者都免费且设置简单。

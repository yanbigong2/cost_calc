# 全球生活成本与收入锚定计算器 - Cursor Agent 执行指令

## 🎯 项目目标

构建一个**单页 HTML 应用**（无后端），在浏览器/微信内置浏览器中运行，用于对比不同城市在同一收入基准下的：
- 税前/税后收入（USD/年）
- 税后可购买 Big Mac 数量
- 年度生活成本（由生活成本表计算）
- 年度结余 = 税后收入 - 年度生活成本
- 当地人均收入倍数（税前）

**默认城市：** 纽约、伦敦、香港、迪拜、上海（5个）

---

## 📋 核心功能清单（按优先级）

### P0 - 必须实现
- [ ] 全局控制区（家庭模式切换、统一基准输入、货币选择）
- [ ] 生活成本明细表（表1，位于上方）
- [ ] 收入对比表（表2，位于下方）
- [ ] 统一基准输入：税前/税后/BigMac/倍数（任意一个输入，反推其他）
- [ ] 税务计算引擎（5城市，支持 Single/Family）
- [ ] 生活成本联动开关（列级同步比例调整）
- [ ] 两表数据联动（成本表 → 主表结余）

### P1 - 重要功能
- [ ] 多货币支持（USD/CNY/HKD/GBP/AED）
- [ ] 香港生活成本优化系数（深圳/拼多多折扣）
- [ ] 默认参数从 GitHub Raw JSON 拉取
- [ ] localStorage 保存用户参数

### P2 - 增强功能
- [ ] 参数导入/导出 JSON
- [ ] 税制版本显示
- [ ] 自定义城市行（可选）

---

## 🏗️ 页面结构（从上到下）

### 1. 全局控制区（顶部固定）

```
┌─────────────────────────────────────────────────┐
│ 标题：全球生活成本锚定计算器                    │
│                                                 │
│ [家庭模式: Single ▼] [货币: USD ▼]            │
│                                                 │
│ 说明：所有金额将根据所选货币自动换算...        │
└─────────────────────────────────────────────────┘
```

**实现要点：**
- 家庭模式下拉：`Single` / `Family (2人1孩)`
- 货币下拉：`USD / CNY / HKD / GBP / AED`
- 切换时触发 `changeMode()` / `changeCurrency()`

---

### 2. 生活成本明细表（表1 - 位于上方）

**⚠️ 重要：此表必须在收入对比表之前显示**

```
┌─────────────────────────────────────────────────────────────┐
│ 生活成本明细表 (月度/年度)                                  │
│ 🔗 联动开启 - 修改任意城市数值，其他城市按比例自动调整      │
└─────────────────────────────────────────────────────────────┘

┌──────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ 城市 │ 🏠 房租  │ 🚗 交通  │ 🍔 餐饮  │ 🍷 社交  │ ...      │
│      │ [🔗]     │ [🔗]     │ [🔗]     │ [🔗]     │          │
├──────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ 纽约 │ 面积×单价│ 公交+打车│ 自做+外食│ 月金额   │ ...      │
│ 伦敦 │ [输入]   │ [输入]   │ [输入]   │ [输入]   │ ...      │
│ ...  │          │          │          │          │          │
└──────┴──────────┴──────────┴──────────┴──────────┴──────────┘
```

**列定义：**
1. **房租（月）**：面积(㎡) × 单价(USD/㎡/月) → 年化 = ×12
2. **交通（月）**：公交(USD/月) + 打车(USD/月) → 年化 = ×12
3. **餐饮（月）**：自做(顿×单价) + 外食(顿×单价) → 年化 = ×12
4. **社交酒水（月）**：USD/月 → 年化 = ×12
5. **日用杂货（月）**：USD/月 → 年化 = ×12（香港可应用折扣）
6. **休闲旅游（年）**：USD/年（直接）
7. **总计（年）**：所有项年化之和

**联动开关逻辑：**
- 每列上方有 `🔗`（ON）/ `🔓`（OFF）按钮
- ON：修改某城市 → 计算 ratio = new/old → 其他城市同列 × ratio
- OFF：只修改当前单元格

**香港特殊处理：**
- 默认启用"跨境/网购节省"开关
- 对日用杂货、餐饮（部分）、旅游应用折扣系数（可配置）

---

### 3. 收入对比表（表2 - 位于下方）

```
┌─────────────────────────────────────────────────────────────┐
│ 收入与储蓄对比表                                             │
│ 在蓝色区域输入任意一项，系统会自动反推其他列                │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ 统一基准设定 ➔                                              │
│ [税前年薪] [税后年薪] [收入倍数] [Big Mac] [成本] [结余]   │
│ [输入框]   [输入框]   [输入框]   [输入框]  [自动] [自动]   │
└──────────────────────────────────────────────────────────────┘

┌──────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ 城市 │ 税前年薪 │ 税后年薪 │ 收入倍数 │ Big Mac  │ 年结余   │
├──────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ 纽约 │ $XXX     │ $XXX     │ X.Xx     │ XXXX 🍔  │ $XXX     │
│ 伦敦 │ $XXX     │ $XXX     │ X.Xx     │ XXXX 🍔  │ $XXX     │
│ ...  │          │          │          │          │          │
└──────┴──────────┴──────────┴──────────┴──────────┴──────────┘
```

**列定义：**
1. **城市**
2. **税前年薪**：USD/年
3. **税后年薪**：USD/年（含阶梯税率/社保）
4. **当地收入倍数**：税前 / 当地平均税前收入
5. **Big Mac 指数**：税后 / Big Mac 单价（个/年）
6. **年生活消费**：来自上方生活成本明细表总计
7. **年结余**：税后 - 年生活消费（正数绿色，负数红色）

**统一基准输入逻辑：**
- 用户在任意输入框输入 → 该列所有城市统一为该值
- 系统反推其他列：
  - 输入税前 → 直接计算税后、倍数、Big Mac
  - 输入税后 → 二分法反推税前 → 计算倍数、Big Mac
  - 输入倍数 → 税前 = 倍数 × 当地平均 → 计算税后、Big Mac
  - 输入 Big Mac → 税后 = 数量 × 单价 → 反推税前 → 计算倍数

---

## 💻 技术实现规范

### 代码结构

```javascript
// 1. 基础配置（USD 基准）
const CITIES_CONFIG = {
    nyc: { name: "🇺🇸 纽约", bigMac: 5.69, avgIncome: 85000, taxRegion: 'us_ny' },
    ldn: { name: "🇬🇧 伦敦", bigMac: 5.39, avgIncome: 58000, taxRegion: 'uk' },
    hk:  { name: "🇭🇰 香港", bigMac: 2.95, avgIncome: 38000, taxRegion: 'hk' },
    dxb: { name: "🇦🇪 迪拜", bigMac: 4.90, avgIncome: 50000, taxRegion: 'uae' },
    sh:  { name: "🇨🇳 上海", bigMac: 3.56, avgIncome: 24000, taxRegion: 'cn' }
};

const CURRENCIES = {
    USD: { rate: 1, symbol: '$' },
    CNY: { rate: 7.23, symbol: '¥' },
    HKD: { rate: 7.82, symbol: 'HK$' },
    GBP: { rate: 0.79, symbol: '£' },
    AED: { rate: 3.67, symbol: 'AED' }
};

// 2. 状态管理
let state = {
    mode: 'single',           // 'single' | 'family'
    currency: 'USD',          // 当前显示货币
    costs: {},                // 生活成本（USD 存储）
    links: {                  // 联动开关状态
        rent: true,
        transport: true,
        food: true,
        social: true,
        misc: true,
        travel: true
    },
    incomes: {},              // 各城市税前收入（USD）
    hkDiscount: {             // 香港折扣系数
        misc: 0.75,
        food: 0.90,
        travel: 0.95
    }
};

// 3. 核心函数
function handleGlobalInput(type, value) { ... }      // 统一基准输入处理
function calculateNetIncome(gross, region) { ... }   // 税务计算
function calculateGrossFromNet(targetNet, region) { ... } // 反推税前
function updateCost(city, category, value) { ... }   // 生活成本更新
function calculateTotalCost(city) { ... }            // 计算年总成本
function renderAll() { ... }                         // 渲染所有表格
```

### 税务计算引擎

**要求：**
- 所有计算以 USD 为基准
- 支持 Single/Family 模式（影响扣除额/税档）
- 反推税前使用二分法（迭代 20 次，精度足够）

**税制实现（参考 basic_cost_cal.html）：**
- **纽约 (us_ny)**：联邦税 + FICA + 州税 + 市税
- **伦敦 (uk)**：Income Tax + National Insurance
- **香港 (hk)**：Salaries Tax（累进 vs 标准税率取低）
- **迪拜 (uae)**：0%（无个人所得税）
- **上海 (cn)**：个税 + 社保

**可配置化：**
- 税档、扣除额、社保比例写入 JSON
- UI 显示"税率依据版本：2025"

### 生活成本联动逻辑

```javascript
function updateCost(sourceCity, category, subField, displayValue) {
    // 1. 转换为 USD（数量类不转换）
    const isQuantity = (subField === 'Area' || subField === 'HomeMeals' || subField === 'OutMeals');
    const usdValue = isQuantity ? parseFloat(displayValue) : fromDisplay(parseFloat(displayValue));
    
    // 2. 计算比例
    const oldValue = getOldValue(sourceCity, category, subField);
    const ratio = (oldValue === 0) ? 1 : (usdValue / oldValue);
    
    // 3. 应用联动（如果开关开启）
    Object.keys(state.costs).forEach(cityKey => {
        if (!state.links[category] && cityKey !== sourceCity) return;
        
        if (cityKey === sourceCity) {
            setValue(cityKey, category, subField, usdValue);
        } else {
            multiplyValue(cityKey, category, subField, ratio);
        }
    });
    
    // 4. 重新渲染
    renderAll();
}
```

### 数据持久化

**GitHub Raw JSON 拉取：**
```javascript
async function loadDefaults() {
    try {
        const response = await fetch('https://raw.githubusercontent.com/.../defaults.json');
        const data = await response.json();
        mergeDefaults(data);
        localStorage.setItem('defaults_cache', JSON.stringify(data));
    } catch (e) {
        // 回退到内置默认值
        useBuiltinDefaults();
    }
}
```

**用户参数保存：**
- localStorage key: `user_params`
- 导出：`JSON.stringify(state)`
- 导入：`Object.assign(state, JSON.parse(json))`

---

## 📐 UI/UX 要求

### 响应式设计
- 移动端优先（适配微信内置浏览器）
- 表格横向滚动（`overflow-x: auto`）
- 输入框适配触摸操作

### 视觉反馈
- 统一基准输入框：深色背景（`#334155`），白色文字
- 正数结余：绿色（`#16a34a`）
- 负数结余：红色（`#dc2626`）
- 联动开关：`🔗`（蓝色，active）/ `🔓`（灰色）

### 提示信息
- 显示当前 Active 基准类型
- 显示税制版本和数据更新时间
- 货币切换时刷新所有显示值

---

## 📦 输出要求

### 必须生成的文件

1. **index.html**
   - 完整的单页应用（内嵌 CSS + JS）
   - 可直接在浏览器打开使用
   - 包含所有 P0 功能

2. **defaults.json**（示例）
   ```json
   {
     "version": "2025.1",
     "updated": "2025-01-15",
     "currencies": { ... },
     "cities": { ... },
     "taxRates": { ... },
     "defaultCosts": {
       "single": { ... },
       "family": { ... }
     },
     "hkDiscount": { ... }
   }
   ```

### 代码质量要求
- 原生 HTML/CSS/JS（无框架依赖）
- 代码注释清晰
- 函数模块化（便于维护）
- 错误处理完善（GitHub 拉取失败、JSON 解析错误等）

---

## 🔍 参考实现

**基础版参考：** `basic_cost_cal.html`

已实现功能：
- ✅ 多货币支持
- ✅ 5城市对比
- ✅ 统一基准输入（税前/税后/倍数/Big Mac）
- ✅ 生活成本明细表（联动开关）
- ✅ 收入对比表（结余计算）
- ✅ Single/Family 切换
- ✅ **表格顺序：生活成本表在上，收入对比表在下**

**可复用代码：**
- 货币转换函数（`toDisplay`, `fromDisplay`, `formatMoney`）
- 税务计算引擎（`calculateNetIncome`, `calculateGrossFromNet`）
- 生活成本更新逻辑（`updateCost`）
- 渲染函数（`renderMainTable`, `renderCostTable`）

---

## ✅ 验收标准

### 功能验收
- [ ] 切换家庭模式，所有城市成本参数自动更新
- [ ] 切换货币，所有金额正确换算显示
- [ ] 输入统一税前，所有城市税前统一，税后按本地税制计算
- [ ] 输入统一税后，系统反推各城市税前（二分法）
- [ ] 输入统一倍数，各城市税前 = 倍数 × 当地平均
- [ ] 输入统一 Big Mac，系统反推税后和税前
- [ ] 修改生活成本（联动开启），其他城市按比例调整
- [ ] 修改生活成本（联动关闭），只影响当前城市
- [ ] 生活成本总计正确回填到收入对比表
- [ ] 年结余 = 税后 - 年生活成本（正数绿色，负数红色）

### 兼容性验收
- [ ] Chrome/Edge 正常显示
- [ ] Safari（iOS）正常显示
- [ ] 微信内置浏览器正常显示
- [ ] 移动端表格可横向滚动
- [ ] 输入框可正常输入和计算

---

## 🚀 开发步骤建议

1. **Phase 1：基础框架**
   - 创建 HTML 骨架（控制区 + 两个表格）
   - 实现基础数据结构和状态管理
   - 实现货币转换工具函数

2. **Phase 2：税务引擎**
   - 实现 5 城市税务计算函数
   - 实现反推税前（二分法）
   - 测试 Single/Family 模式差异

3. **Phase 3：生活成本表**
   - 实现成本明细表渲染
   - 实现联动开关逻辑
   - 实现香港折扣系数

4. **Phase 4：收入对比表**
   - 实现统一基准输入处理
   - 实现收入对比表渲染
   - 实现两表数据联动

5. **Phase 5：数据持久化**
   - 实现 GitHub Raw JSON 拉取
   - 实现 localStorage 保存/加载
   - 实现参数导入/导出

6. **Phase 6：优化与测试**
   - 响应式布局优化
   - 错误处理完善
   - 跨浏览器测试

---

## 📝 注意事项

1. **表格顺序必须正确**：生活成本表在上，收入对比表在下
2. **所有金额内部存储为 USD**，显示时按当前货币转换
3. **税务计算必须支持反推**（给定税后，反推税前）
4. **联动开关默认开启**，用户可手动关闭
5. **香港折扣系数可配置**，UI 提供调整入口
6. **GitHub 拉取失败时**，必须回退到内置默认值
7. **代码必须原生 JS**，保证微信 WebView 兼容性

---

**开始实现时，请先阅读 `basic_cost_cal.html` 作为参考，然后按照上述规范构建完整应用。**

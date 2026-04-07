# DineRank UI设计提示词

## 一、APP图标设计提示词（给Figma AI）

### 提示词（英文版 - 推荐）

```
Design an iOS app icon for "DineRank", a social dining coordination app with gamification elements.

Core concept: Combine dining + ranking/achievement system

Visual elements to include:
- A minimalist fork and knife OR chopsticks silhouette
- A rank badge/medal/trophy element subtly integrated
- Clean geometric shapes (circle, hexagon, or shield)

Style requirements:
- Modern, flat design with subtle gradients
- Vibrant but sophisticated color palette
- iOS design guidelines compliant (rounded square with proper margins)
- Recognizable at small sizes (60x60px)

Color direction:
- Primary: Warm orange/coral (#FF6B35 to #FF8C42) - represents food and energy
- Accent: Gold/yellow (#FFD23F) - represents achievement and ranking
- Optional: Deep purple/blue gradient for premium feel

Reference style:
- Splitwise (clean, friendly, purposeful)
- Notion (simple geometric, memorable)
- Duolingo (playful but professional)

Avoid:
- Overly complex illustrations
- Generic food emojis
- Text or letters in the icon
- Dark or muted colors

Output: 1024x1024px, transparent background, ready for iOS app icon export
```

### 提示词（中文版）

```
为"DineRank（约饭）"设计iOS应用图标，这是一款带游戏化段位系统的熟人聚餐协调工具。

核心概念：餐饮 + 排名/成就系统

视觉元素：
- 极简的餐具轮廓（叉勺或筷子）
- 段位徽章/奖牌/奖杯元素巧妙融合
- 干净的几何形状（圆形、六边形或盾牌）

风格要求：
- 现代扁平设计，带微妙渐变
- 鲜艳但不失精致的配色
- 符合iOS设计规范（圆角方形，留白合理）
- 小尺寸下可识别（60x60px）

配色方向：
- 主色：暖橙色/珊瑚色（#FF6B35 到 #FF8C42）- 代表美食和活力
- 点缀色：金色/黄色（#FFD23F）- 代表成就和段位
- 可选：深紫/蓝色渐变增加高级感

参考风格：
- Splitwise（简洁、友好、目的明确）
- Notion（简单几何、易记）
- Duolingo（有趣但专业）

避免：
- 过于复杂的插画
- 通用食物emoji
- 图标中包含文字或字母
- 暗色或灰暗配色

输出：1024x1024px，透明背景，可直接导出为iOS图标
```

---

## 二、APP UI风格设计提示词（给Figma AI）

### 整体风格提示词

```
Design a complete UI style guide for "DineRank", an iOS app for coordinating group dining with a gamification ranking system.

App personality: Friendly, trustworthy, achievement-oriented, social

Design system requirements:

1. COLOR PALETTE
Primary colors:
- Coral Orange #FF6B35 (CTA buttons, active states)
- Warm Peach #FFB88C (backgrounds, highlights)
- Gold #FFD23F (rank badges, achievements)

Secondary colors:
- Deep Navy #1A2238 (text, headers)
- Soft Gray #F5F5F7 (backgrounds, cards)
- Success Green #34C759 (attendance confirmed)
- Alert Red #FF3B30 (no-show warnings)

Rank-specific colors:
- Newcomer: #A8DADC (soft teal)
- Bronze: #CD7F32
- Silver: #C0C0C0
- Gold: #FFD700
- Platinum: #00CED1
- Diamond: #4169E1
- Legend: #9370DB (purple)

2. TYPOGRAPHY
- Headings: SF Pro Display Bold (iOS native)
- Body: SF Pro Text Regular
- Numbers/Stats: SF Pro Rounded Medium (for rank percentages)
- Hierarchy: Clear size contrast (32pt/24pt/17pt/15pt)

3. COMPONENTS STYLE

Cards:
- Rounded corners: 16px
- Shadow: subtle (0 2px 8px rgba(0,0,0,0.08))
- Padding: 16px
- Background: white with slight gradient

Buttons:
- Primary: Coral orange, rounded 12px, bold text
- Secondary: Outlined, 2px border
- Height: 48px (touch-friendly)

Rank Badges:
- Circular or hexagonal shape
- Emoji icon + text label
- Subtle glow effect matching rank color
- Size: 64x64px for profile, 32x32px for lists

Progress Indicators:
- Circular progress rings (like Apple Fitness)
- Color matches current rank
- Percentage in center

4. LAYOUT PRINCIPLES
- Generous whitespace (24px margins)
- Card-based content organization
- Bottom sheet modals for actions
- Native iOS navigation patterns
- Tab bar with 3 items max

5. MICRO-INTERACTIONS
- Rank up animation: confetti + badge scale
- Vote submitted: checkmark bounce
- Pull to refresh: custom loader
- Haptic feedback on important actions

6. REFERENCE APPS
Study these for inspiration:
- Splitwise: Clean expense cards, friendly colors
- Strava: Achievement badges, stats presentation
- Airbnb: Card layouts, imagery treatment
- Apple Health: Ring progress, data visualization
- Notion: Minimalist, purposeful design

7. SCREENS TO DESIGN
Priority order:
1. Home (event list with status cards)
2. Create Event (3-step form)
3. Event Detail (voting interface)
4. My Rank (profile with stats)
5. Attendance Confirmation (post-event)

Design for iOS 17+, light mode first (dark mode optional for MVP)
Use SF Symbols for icons where possible
Maintain 8pt grid system
```

---

## 三、关键页面设计提示词

### 3.1 首页（约饭局列表）

```
Design the home screen for DineRank iOS app.

Layout:
- Large title "约饭" at top
- Floating "+" button (bottom right, coral orange)
- Event cards in vertical list
- Empty state illustration when no events

Event Card design:
- White background, 16px rounded corners
- Left: Event emoji icon (🍜🍕🍱)
- Center: Title (bold), date range, participant count
- Right: Status badge (voting/confirmed/completed)
- Bottom: Mini avatars of participants (emoji faces)
- Subtle shadow for depth

Status indicators:
- Voting: Orange dot + "投票中"
- Confirmed: Green checkmark + "已确定"
- Completed: Gray + "已结束"

Reference: Apple Reminders list view + Splitwise group cards
```

### 3.2 创建约饭局（3步流程）

```
Design a 3-step event creation flow for DineRank.

Step indicator:
- Top: Progress dots (1/3, 2/3, 3/3)
- Active dot: coral orange, larger
- Completed: gold with checkmark

Step 1 - Basic Info:
- Large emoji picker for event icon
- Text field: Event title
- Time slot picker: 2-3 selectable cards
- Cuisine tags: horizontal scrollable chips
- Budget slider: ¥50 - ¥500

Step 2 - Restaurant Search (optional):
- Search bar with map icon
- Results: cards with name, distance, price
- "Skip" button at bottom
- Max 3 selections with checkmarks

Step 3 - Share:
- Large preview card of created event
- "Copy Link" button (primary)
- Native share sheet trigger
- "Done" to return home

Visual style: Clean forms, large touch targets (min 44pt), inline validation
Reference: Airbnb booking flow + Apple Calendar event creation
```

### 3.3 我的段位页

```
Design a gamified profile page showing attendance rank and stats.

Hero section:
- Large rank badge (128x128px) with glow effect
- Rank name in bold below badge
- Attendance rate in large numbers (96%)
- Circular progress ring around badge

Stats grid (2x2):
- Total events attended
- Current streak (with 🔥 emoji)
- Longest streak (with 🏆 emoji)
- Rank level progress bar

Achievement cards:
- Horizontal scrollable
- Each card: icon + title + unlock date
- Locked achievements: grayscale with lock icon

History list:
- Timeline view with dots
- Each entry: date, event name, attended/missed
- Color coded: green (attended), red (missed)

Share button:
- "Share My Rank" at bottom
- Generates shareable card image

Visual hierarchy: Badge is focal point, stats support, history is secondary
Reference: Strava profile + Duolingo progress page + Apple Fitness rings
```

### 3.4 约饭局详情页

```
Design the event detail page with real-time voting interface.

Header:
- Event emoji + title
- Status banner (voting/confirmed)
- Creator name with small avatar
- Share button (top right)

Time Voting Section:
- Title: "选择时间" with vote count
- Time option cards (vertical stack)
- Each card: date, time period, voter avatars, vote button
- Winning option: gold border + crown icon

Restaurant Voting Section:
- Title: "选择餐厅" with vote count
- Restaurant cards with image placeholder
- Name, cuisine, price, distance
- Vote button + current vote count
- Map pin icon to view location

Participants Section:
- Title: "参与者 (4人)"
- Horizontal scrollable avatars
- Each: emoji avatar, name, rank badge (small), vote status

Bottom Actions:
- "Confirm Event" (creator only, primary button)
- "Leave Event" (secondary, text button)

Real-time updates: Subtle pulse animation when new votes arrive
Reference: Doodle poll interface + Meetup event page
```

---

## 四、设计资产清单

### 需要设计的组件

1. **图标集**
   - App icon (1024x1024)
   - 7个段位徽章（newcomer到legend）
   - Tab bar icons (3个)
   - 常用操作icons（投票、分享、AA、确认）

2. **插画**
   - 空状态插画（无约饭局）
   - 首次使用引导（3张）
   - 段位升级庆祝动画

3. **UI组件库**
   - 按钮（primary/secondary/text）
   - 输入框（text/search/number）
   - 卡片（event/restaurant/participant）
   - 徽章（rank/status）
   - 进度条（circular/linear）

4. **配色方案**
   - Light mode完整色板
   - Dark mode色板（可选）
   - 段位专属颜色

---

## 五、国外优秀参考APP分析

### 1. Splitwise（费用分摊）
**借鉴点**：
- 清晰的卡片式布局
- 友好的配色（绿色主题）
- 简洁的金额展示
- 易懂的图标系统

**应用到DineRank**：
- AA计算器界面参考其金额输入
- 参与者列表的头像展示方式
- 结算状态的视觉反馈

### 2. Doodle（时间投票）
**借鉴点**：
- 直观的时间网格投票界面
- 实时更新的投票结果
- 清晰的可用性标识（✓/✗）

**应用到DineRank**：
- 时间投票的交互逻辑
- 投票结果的可视化
- 多人协作的状态同步

### 3. Strava（运动社交）
**借鉴点**：
- 成就徽章系统设计
- 个人统计数据展示
- 排行榜视觉层级
- 分享卡片的设计

**应用到DineRank**：
- 段位徽章的视觉风格
- 我的段位页的布局
- 战绩卡片的信息架构

### 4. Notion（生产力工具）
**借鉴点**：
- 极简的图标设计
- 清晰的信息层级
- 灵活的卡片系统
- 优雅的空状态

**应用到DineRank**：
- 整体UI的克制感
- 图标的几何简洁风格
- 内容组织方式

### 5. Apple Health（健康）
**借鉴点**：
- 圆环进度指示器
- 数据可视化方式
- 成就系统的呈现
- 原生iOS设计语言

**应用到DineRank**：
- 守约率的圆环展示
- 统计数据的卡片设计
- 动画和过渡效果

---

## 六、Figma设计检查清单

### 设计前准备
- [ ] 安装SF Pro字体
- [ ] 设置8pt网格系统
- [ ] 创建颜色样式库
- [ ] 创建文本样式库

### 必须交付物
- [ ] App icon（1024x1024 + 各尺寸）
- [ ] 5个核心页面设计稿（iPhone 14 Pro尺寸）
- [ ] 组件库（buttons, cards, badges）
- [ ] 7个段位徽章设计
- [ ] 配色方案文档
- [ ] 间距规范（8pt grid）

### 可选交付物
- [ ] 原型交互演示
- [ ] Dark mode适配
- [ ] 动画效果说明
- [ ] 开发标注

---

## 七、快速启动建议

### 如果使用Figma AI生成

**Step 1**: 先生成App icon
```
使用"APP图标设计提示词"，生成3-5个方案，选最佳
```

**Step 2**: 建立设计系统
```
使用"整体风格提示词"，让AI生成color palette和typography
```

**Step 3**: 逐页设计
```
按优先级使用"关键页面设计提示词"：
1. 首页
2. 我的段位页
3. 创建约饭局
4. 约饭局详情页
5. AA计算器
```

**Step 4**: 提取组件
```
将重复元素提取为components，建立设计系统
```

### 如果手动设计

1. 在Figma创建新文件
2. 设置frame: iPhone 14 Pro (393 x 852)
3. 导入SF Pro字体
4. 按提示词中的配色创建color styles
5. 参考Splitwise/Strava截图，临摹布局
6. 逐步替换为DineRank的内容

---

**核心设计理念**：友好但不幼稚，游戏化但不浮夸，简洁但有记忆点。

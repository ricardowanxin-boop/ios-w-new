# 最新 iOS 通用模版

这个目录沉淀的是一个可复用的 iOS 通用基础骨架，已经移除了具体业务页面、领域模型和平台耦合实现，保留的是更适合作为新项目起点的通用部分：

- SwiftUI App 入口和三 Tab 根结构
- 主题系统、背景层、按钮样式、状态徽标、指标卡片
- 首页骨架、组件库页、设置页
- `UserDefaults` 设置持久化和本地 JSON 快照缓存
- App Store 版本检查占位能力
- UI Test 启动与基础导航验证

## 目录结构

```text
最新IOS通用模版
├── UniversalAppTemplate.xcodeproj
├── UniversalAppTemplate
│   ├── App
│   ├── Models
│   ├── Resources
│   ├── Services
│   ├── Support
│   ├── ViewModels
│   └── Views
└── UniversalAppTemplateUITests
```

## 已做的去业务化处理

- 删除了原项目中的业务领域模型、流程页面和场景化文案
- 删除了云端同步、分享链接、地图、排行榜等业务能力实现
- 删除了定位、推送、Associated Domains、App Group 等集成依赖
- 把首页改成通用 Dashboard 骨架
- 把原来的“组件页”保留并改造成真正的模板组件沉淀区
- 把设置页改成通用外观、功能开关、调试动作、模板信息结构

## 你接下来通常要改的地方

1. 打开 `UniversalAppTemplate.xcodeproj`
2. 修改 `UniversalAppTemplate/Support/AppConfig.swift`
3. 替换 `UniversalAppTemplate/Support/SampleData.swift` 为你的真实首页数据结构
4. 根据业务改造 `Views/HomeScreen.swift`
5. 如果需要上架，补齐真实的 Bundle ID、团队签名、支持页和隐私页
6. 如果不需要组件库页，可以在 `FeatureFlags` 里默认关闭

## 当前占位项

- `AppConfig.bundleIdentifier` 仍是占位值 `com.example.UniversalAppTemplate`
- App Store 更新检查默认会提示“当前模板还没有公开条目”
- 支持页、文档页、隐私页都是 `example.com` 占位链接
- App Icon 建议在正式项目里替换成你自己的品牌图标

## 构建命令

```bash
xcodebuild -project UniversalAppTemplate.xcodeproj \
  -scheme UniversalAppTemplate \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

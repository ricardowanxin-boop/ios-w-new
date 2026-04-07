# Sidebar TOC Fix

## Problem
The current left sidebar item is too dense and reads like a content card.

Symptoms:
- selected item contains too much text
- hierarchy label and article body are mixed together
- one row visually dominates the whole sidebar
- navigation becomes harder to scan

## Target
Make the left sidebar feel like a Notion-style directory:
- fast to scan
- low cognitive load
- one item = one navigation target
- selected state is clear without becoming bulky

## Correct item anatomy

Each sidebar item should contain only:
1. leading icon
2. title
3. one short secondary line
4. optional trailing affordance

It should not contain:
1. full paragraph preview
2. markdown fragments
3. repeated editor content
4. more than two text blocks

## Recommended structure

### Normal item
- icon: 16-18 pt
- title: single line
- meta line: one short line such as:
  - `1 个子项`
  - `一级目录`
  - `今日摘录`

### Selected item
- same structure as normal item
- same text length limits
- add warm outline or slightly darker neutral fill
- do not expand vertically just because it is selected

## Line clamp rules
- title: `lineLimit(1)`
- subtitle: `lineLimit(1)` or `lineLimit(2)`
- body preview: removed from sidebar

## Spacing spec

| Element | Value |
| --- | --- |
| row horizontal padding | 16 pt |
| row vertical padding | 14 pt |
| icon-to-text gap | 12 pt |
| title-to-subtitle gap | 4 pt |
| row corner radius | 20 pt |
| row-to-row gap | 8 pt |

## Visual hierarchy
- Sidebar section header:
  - use a separate container from row items
  - for example `页面目录`
- Row content:
  - keep quiet and compact
- Main editor:
  - owns all long-form reading content

## Before vs after

### Before
- `今日摘录`
- `拖到这里，放成一级目录`
- then a long wrapped paragraph inside the same card

### After
- `今日摘录`
- `一级目录`

Or:

- `今日摘录`
- `1 个子项`

## Interaction notes
- tap row: jump to section
- hover row: optional preview popover
- selected row: outline only, no huge layout shift
- nested rows: show hierarchy through indentation, not more text

## SwiftUI guidance
- Avoid default `List` row rendering if it resists compact layout.
- Prefer a dedicated `SidebarTOCRow` view.
- Keep row height stable across states.
- If you want body preview, put it in:
  - a tooltip
  - a right-side inspector
  - a temporary hover card

## Proposed row model

```swift
struct SidebarTOCItem {
    let id: UUID
    let icon: String
    let title: String
    let subtitle: String
    let level: Int
    let isSelected: Bool
}
```

## Proposed rendering rule

```swift
if item.isSelected {
    showCompactHighlightedRow()
} else {
    showCompactDefaultRow()
}
```

Never do this:

```swift
showRowWithLongBodyPreview()
```

## Decision
The sidebar should optimize for scanability, not readability.

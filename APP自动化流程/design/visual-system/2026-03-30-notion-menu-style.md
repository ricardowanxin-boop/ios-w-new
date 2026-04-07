# Notion Menu Style Reference

## Goal
Align the app's list or menu rows to a Notion-like visual style:
- soft neutral background
- large rounded row containers
- compact but breathable spacing
- low-contrast borders
- calm selection state instead of heavy shadows

## Visual traits from the reference
- Row feels like a rounded card, not a plain table cell.
- Background uses warm light gray instead of pure white.
- Selected row uses a thin warm outline, not a strong fill.
- Left icon, title, subtitle, and trailing actions sit on one clear horizontal axis.
- Text is bold enough to feel structured, but not dense.
- Vertical spacing between rows is small and even.

## Current mismatch in the screenshot
- The sidebar card is trying to show too much body content.
- The row behaves like a content preview block, not a menu item.
- Title, hierarchy hint, and long paragraph are competing inside one container.
- The result feels crowded and much heavier than Notion's navigation lists.

## Important correction
For a Notion-like sidebar, one menu item should represent navigation state, not document reading state.

That means:
- keep the card compact
- show only the node label and one short supporting line
- never dump a full paragraph into the directory item
- let the main content pane carry the reading load

## Recommended tokens

| Token | Value | Notes |
| --- | --- | --- |
| row height | 92-104 pt | Large enough for title + subtitle |
| horizontal padding | 18-22 pt | Keep the content block relaxed |
| vertical padding | 14-16 pt | Prevent a cramped look |
| corner radius | 22-26 pt | Key part of the Notion-like softness |
| row gap | 8-12 pt | Rows should feel grouped |
| background | `#F3F1ED` | Warm neutral fill |
| selected border | `#E5C9A6` | Thin warm outline |
| default border | transparent or `#ECE7DF` | Keep it subtle |
| title color | `#2C2B29` | Strong but not black |
| subtitle color | `#787774` | Muted neutral |
| icon color | `#6F6E69` | Slightly darker than subtitle |
| action color | `#6F6E69` | Same tone family as icon |

## Sidebar directory item spec

For the left "page directory" style list, use a tighter spec than the larger page cards:

| Token | Value | Notes |
| --- | --- | --- |
| compact row min height | 68-84 pt | Better for navigation lists |
| content padding | 14-16 pt | Enough air without bloat |
| compact corner radius | 18-22 pt | Slightly tighter than large cards |
| title size | 15-16 pt | Smaller than main page cards |
| subtitle size | 12-13 pt | Quiet supporting info only |
| title lines | 1 | Always truncate |
| subtitle lines | 1-2 | Max two lines |
| body preview | hidden | Do not show paragraph content in the menu |

## Sidebar content hierarchy
- First line:
  - section or page title
- Second line:
  - optional hierarchy label, child count, or short state
- Never include:
  - full body copy
  - multi-sentence preview
  - long markdown fragments
  - repeated content already visible in the editor pane

## What the menu item should look like
- Good:
  - "今日摘录"
  - "拖到这里，放成一级目录"
- Also good:
  - "今日摘录"
  - "1 个子项"
- Not good:
  - "今日摘录"
  - followed by half a screen of article body text

## Layout spec
- Leading area:
  - 16-20 pt left inset before the disclosure affordance or icon.
  - If expandable, the chevron sits first and is vertically centered.
  - Document icon width should stay visually aligned across rows.
- Content area:
  - Title on first line.
  - Metadata or item count on second line.
  - Use 4-6 pt spacing between title and subtitle.
- Trailing area:
  - Keep the kebab or drag handle pinned to the right edge.
  - Preserve at least 16 pt right inset.

## Typography
- Title:
  - weight: semibold
  - size: 17-18 pt
  - line height: visually compact
- Subtitle:
  - weight: regular
  - size: 14-15 pt
  - lower contrast than title

## State behavior
- Default:
  - filled neutral background
  - no strong border
- Hover or focus:
  - slightly darker fill, not dramatic
- Selected:
  - keep same neutral fill
  - add 1-1.5 pt warm border
  - optional ultra-light outer glow, but avoid obvious shadow
- Pressed:
  - lower scale change is optional, but keep it restrained

## Truncation rules
- Title should use single-line truncation.
- Subtitle should use at most two lines.
- If the user needs a fuller preview, show it in a hover card, popover, or separate inspector.
- The active row should still remain compact even when selected.

## Spacing fixes for the sidebar screenshot
- Reduce the text block width pressure by limiting visible copy.
- Add 8-10 pt spacing between the icon/title group and the subtitle.
- Keep the card's bottom padding equal to the top padding.
- Increase space between sibling items instead of increasing text inside a single item.
- If nested items exist, express hierarchy with indentation, not with more text.

## What to avoid
- Pure white rows on white page background
- Sharp 12 pt card radius
- Heavy gray divider lines
- High-saturation accent colors
- Overly dark text and icons
- Tight list density
- Turning a navigation item into a mini article reader
- Showing long wrapped text inside every selected sidebar item

## SwiftUI implementation notes
- Prefer a custom row component over `List` default styling if you need precise control.
- Use a parent background slightly lighter than the rows so the cards remain visible.
- Hide default separators.
- Keep selected state driven by border + subtle fill change instead of strong shadow.
- In a sidebar TOC, clamp text aggressively and keep preview content out of the row.

## Suggested sidebar row structure

```swift
HStack(alignment: .top, spacing: 12) {
    Image(systemName: "lightbulb")
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(iconColor)

    VStack(alignment: .leading, spacing: 4) {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .lineLimit(1)

        Text(subtitle)
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(subtitleColor)
            .lineLimit(2)
    }

    Spacer(minLength: 0)
}
.padding(.horizontal, 16)
.padding(.vertical, 14)
```

## Suggested SwiftUI styling recipe

```swift
RoundedRectangle(cornerRadius: 24, style: .continuous)
    .fill(Color(red: 0.95, green: 0.945, blue: 0.93))
    .overlay {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(
                isSelected
                ? Color(red: 0.90, green: 0.79, blue: 0.65)
                : .clear,
                lineWidth: isSelected ? 1.2 : 0
            )
    }
```

## Conclusion
If you want the menu to feel closer to Notion, the two most important adjustments are:
1. Increase the row corner radius and internal padding.
2. Use a warm neutral card fill with a very light selected border instead of a standard list highlight.

For the specific sidebar issue in the screenshot, the highest-leverage fix is:
3. Remove long body preview text from the menu item and keep each row compact.

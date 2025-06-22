# 📄 CustomImage

## 🔍 Overview

`CustomImage` is a versatile SwiftUI abstraction that unifies static and remote image rendering into a single interface. It supports image tinting, custom placeholders, and fallback options — and internally leverages [CachedAsyncImage](https://github.com/petomuro/CachedAsyncImage) for efficient remote image handling with memory and disk caching.

## 🧱 Enum Definition

```swift
public enum CustomImage {
    case app(image: Image, color: Color?)
    case remote(url: URL?, imageColor: Color? = nil, placeholder: Image?, placeholderColor: Color? = nil)
    case remoteIncludingRemotePlaceholder(
        url: URL?,
        imageColor: Color? = nil,
        placeholderUrl: URL?,
        placeholder: Image?,
        placeholderColor: Color? = nil
    )
}
```

## 🎨 Rendering Modes

```swift
public enum CustomImageRenderingMode {
    case original
    case template(color: Color? = nil)
}
```

- `.original` - renders the image as-is.
- `.template` - renders image as template with optional color tint.

## 🧩 View Builder API

```swift
func view(isResizable: Bool = true, mode: CustomImageRenderingMode = .original) -> some View
```

- Returns a SwiftUI View representation of the image.
- Automatically handles caching, placeholders, and rendering mode.
- Behavior adapts based on the enum case and image availability.

## ✅ Recommended Usage

Outside of UI components, prefer using native `Image` for static assets — unless you're displaying a `.remote` or `.remoteIncludingRemotePlaceholder`.

In those cases, `CustomImage` is necessary to handle loading, caching, and fallback logic properly.

### ✅ Use `CustomImage` in components or when rendering remote images:

```swift
// Used inside a component – recommended:
Button(
    theme: .light,
    style: .solidPrimary,
    size: .normal,
    icon: .app(image: Image("icon-starsharp-solid"), color: nil),
    title: "Ok",
    action: {
        storeOpened = true
    },
    fullWidth: true,
    badge: false
)
.disabled(storeOpened)
```

```swift
// Used for remote image loading – also recommended:
CustomImage.remote(
    url: URL(string: "https://example.com/image.png"),
    imageColor: .blue,
    placeholder: Image(systemName: "photo"),
    placeholderColor: .gray
).view()
```

## ❌ Avoid using it for simple static images outside components:

```swift
// Overkill:
CustomImage.app(image: Image("logo"), color: .primary500)
    .view()
    .scaledToFit()
    .frame(width: 24, height: 24)

// Prefer:
Image("logo")
    .renderingMode(.template)
    .resizable()
    .scaledToFit()
    .frame(width: 24, height: 24)
    .foregroundColor(.primary500)
```

## 🧠 Remote Handling Logic

When `.remote` or `.remoteIncludingRemotePlaceholder` is used, `CachedAsyncImage` handles loading, caching, and fallback logic.

If the main URL is missing or fails, fallback images (local or remote) are rendered.

Supports recursive placeholder fallback with nested `CachedAsyncImage` usage.

## 💡 Usage Examples

### Static Image

```swift
// Overkill:
CustomImage.app(image: Image("star"), color: .yellow)
    .view()
    .scaledToFit()
    .frame(width: 24, height: 24)

// Prefer:
Image("star")
    .renderingMode(.template)
    .resizable()
    .scaledToFit()
    .frame(width: 24, height: 24)
    .foregroundColor(.yellow)
```

### Remote Image with Local Placeholder

```swift
CustomImage.remote(
    url: URL(string: "https://example.com/image.png"),
    imageColor: .blue,
    placeholder: Image(systemName: "photo"),
    placeholderColor: .gray
).view()
```

### Remote Image with Remote Placeholder

```swift
CustomImage.remoteIncludingRemotePlaceholder(
    url: URL(string: "https://example.com/image.png"),
    imageColor: .blue,
    placeholderUrl: URL(string: "https://example.com/placeholder.png"),
    placeholder: nil,
    placeholderColor: .gray
).view()
```

## ⚙️ Dependencies

- 🔄 Uses `CachedAsyncImage` under the hood for all remote image handling
- 🧱 Relies on SwiftUI's `Image`, `Color`, and view builder APIs

## 🔗 Related Documentation

See also: [CachedAsyncImage](https://github.com/petomuro/CachedAsyncImage)

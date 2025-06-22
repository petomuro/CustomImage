//
//  CustomImage.swift
//
//
//  Created by Peter Murín on 22/06/2025.
//

import CachedAsyncImage
import SwiftUI

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public enum CustomImageRenderingMode {
    case original
    case template(color: Color? = nil)

    init(color: Color?) {
        self = color.map {
            .template(color: $0)
        } ?? .original
    }
}

public enum CustomImage {
    // color argument is when you want to change color from outside e.g. from DOXXbetUI Demo app
    case app(image: Image, color: Color?)
    case remote(url: URL?, imageColor: Color? = nil, placeholder: Image?, placeholderColor: Color? = nil)
    case remoteIncludingRemotePlaceholder(
        url: URL?,
        imageColor: Color? = nil,
        placeholderUrl: URL?,
        placeholder: Image?,
        placeholderColor: Color? = nil
    )

    /// Use `mode .template(color: Color? = nil)` to set rendering mode from `inside` e.g. directly in component.
    /// If you set color in CustomImage, there is no additional set up required - do not use `mode` arguent
    ///
    /// - Parameters:
    ///   - isResizable: if content (image) should be treated as resizable
    ///   - mode: rendering mode type with color e.g. .`template(color: .white)`
    /// - Returns: View (Image)
    ///
    @ViewBuilder
    public func view(isResizable: Bool = true, mode: CustomImageRenderingMode = .original) -> some View {
        switch self {
        case let .app(image, color):
            if let color {
                render(image: image, CustomImageRenderingMode(color: color), isResizable)
            } else {
                render(image: image, mode, isResizable)
            }
        case let .remote(url, imageColor, placeholder, placeholderColor):
            remoteView(
                url: url,
                imageColor: imageColor,
                placeholder: placeholder,
                placeholderColor: placeholderColor,
                isResizable: isResizable
            )
        case let .remoteIncludingRemotePlaceholder(url, imageColor, placeholderUrl, placeholder, placeholderColor):
            remoteView(
                url: url,
                imageColor: imageColor,
                placeholderUrl: placeholderUrl,
                placeholder: placeholder,
                placeholderColor: placeholderColor,
                isResizable: isResizable
            )
        }
    }

    @ViewBuilder
    private func remoteView(
        url: URL?,
        imageColor: Color?,
        placeholder: Image?,
        placeholderColor: Color?,
        isResizable: Bool
    ) -> some View {
        if let url {
            CachedAsyncImage(url: url) { image in
                render(image: image, CustomImageRenderingMode(color: imageColor), isResizable)
            } placeholder: {
                placeholderView(image: placeholder, color: placeholderColor, isResizable: isResizable)
            }
        } else {
            placeholderView(image: placeholder, color: placeholderColor, isResizable: isResizable)
        }
    }

    @ViewBuilder
    // swiftlint:disable:next function_parameter_count
    private func remoteView(
        url: URL?,
        imageColor: Color?,
        placeholderUrl: URL?,
        placeholder: Image?,
        placeholderColor: Color?,
        isResizable: Bool
    ) -> some View {
        if let url {
            CachedAsyncImage(url: url) { image in
                render(image: image, CustomImageRenderingMode(color: imageColor), isResizable)
            } placeholder: {
                remoteView(
                    url: placeholderUrl,
                    imageColor: placeholderColor,
                    placeholder: placeholder,
                    placeholderColor: placeholderColor,
                    isResizable: isResizable
                )
            }
        } else {
            remoteView(
                url: placeholderUrl,
                imageColor: placeholderColor,
                placeholder: placeholder,
                placeholderColor: placeholderColor,
                isResizable: isResizable
            )
        }
    }

    @ViewBuilder
    private func placeholderView(image: Image?, color: Color?, isResizable: Bool) -> some View {
        if let image {
            render(image: image, CustomImageRenderingMode(color: color), isResizable)
        } else {
            Rectangle()
                .fill(color ?? .clear)
        }
    }

    @ViewBuilder
    private func render(image: Image, _ mode: CustomImageRenderingMode, _ isResizable: Bool) -> some View {
        switch mode {
        case .original:
            image
                .renderingMode(.original)
                .if(isResizable) { content in
                    content
                        .resizable()
                }
        case let .template(color):
            image
                .renderingMode(.template)
                .if(isResizable) { content in
                    content
                        .resizable()
                }
                .if(color != nil) { content in
                    content
                        .foregroundStyle(color!)
                }
        }
    }
}

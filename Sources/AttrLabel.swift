//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

import SwiftUI

@available(iOS 13.0, *)
public struct AttrLabel: View {
    public var attributedString: NSAttributedString

    public var body: some View {
        HorizontalGeometryReader { width in
            InternalAttributedLabelView(
                attributedString: attributedString,
                preferredMaxLayoutWidth: width
            )
        }
    }

    public init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
}

@available(iOS 13.0, *)
private struct InternalAttributedLabelView: UIViewRepresentable {
    var attributedString: NSAttributedString
    var preferredMaxLayoutWidth: CGFloat = .greatestFiniteMagnitude

    func makeUIView(context: UIViewRepresentableContext<InternalAttributedLabelView>) -> AttributedLabel {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()

        updateUIView(label, context: context)
        return label
    }

    func updateUIView(_ label: AttributedLabel, context _: UIViewRepresentableContext<InternalAttributedLabelView>) {
        label.attributedText = attributedString
        label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
}

@available(iOS 13.0, *)
private struct HorizontalGeometryReader<Content: View>: View {
    var content: (CGFloat) -> Content
    @State private var width: CGFloat = 0

    init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }

    var body: some View {
        content(width)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                }
            )
            .onPreferenceChange(WidthPreferenceKey.self) { width in
                self.width = width
            }
    }
}

@available(iOS 13.0, *)
private struct WidthPreferenceKey: PreferenceKey, Equatable {
    static var defaultValue: CGFloat = 0

    /// An empty reduce implementation takes the first value
    static func reduce(value _: inout CGFloat, nextValue _: () -> CGFloat) {}
}

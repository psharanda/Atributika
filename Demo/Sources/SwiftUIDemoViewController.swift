//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import AtributikaViews
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct AttrLabel: UIViewRepresentable {
    public var attributedString: NSAttributedString
    public var preferredMaxLayoutWidth: CGFloat = .greatestFiniteMagnitude

    public init(attributedString: NSAttributedString, preferredMaxLayoutWidth: CGFloat) {
        self.attributedString = attributedString
        self.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }

    public func makeUIView(context: Context) -> AttributedLabel {
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

    public func updateUIView(_ label: AttributedLabel, context _: Context) {
        label.attributedText = attributedString
        label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
}

@available(iOS 13.0, *)
public struct HorizontalGeometryReader<Content: View>: View {
    public var content: (CGFloat) -> Content
    @State private var width: CGFloat = 0

    public init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }

    public var body: some View {
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

@available(iOS 13.0, *)
struct ContentView: View {
    var body: some View {
        List {
            ForEach(tweets, id: \.self) { item in
                HorizontalGeometryReader { width in
                    AttrLabel(
                        attributedString: item.styleAsTweet().attributedString,
                        preferredMaxLayoutWidth: width
                    )
                    .padding(5)
                }
            }
        }
    }
}

@available(iOS 13.0, *)
class SwiftUIDemoViewController: UIHostingController<ContentView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftUI"
    }
}

//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import AtributikaViews
import AtributikaMarkdown
import Markdown
import UIKit

class MarkdownViewController: UIViewController {
    private let attributedTextView = AttributedTextView()

    private var currentURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Markdown"
        view.backgroundColor = .white
        view.addSubview(attributedTextView)

        attributedTextView.isScrollEnabled = true
        attributedTextView.isSelectable = true
        attributedTextView.alwaysBounceVertical = true
        attributedTextView.numberOfLines = 0
        attributedTextView.linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()
        attributedTextView.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes
        attributedTextView.onLinkTouchUpInside = { [weak self] _, val in
            if let linkStr = val as? String {
                self?.loadURL(linkStr)
            }
        }

        attributedTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            attributedTextView.topAnchor.constraint(equalTo: view.topAnchor),
            attributedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            attributedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            attributedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        loadURL("https://raw.githubusercontent.com/psharanda/Atributika/master/README.md")
    }

    private func loadURL(_ urlString: String) {
        if urlString.hasPrefix("http") {
            currentURL = URL(string: urlString)!
        } else if let baseURL = currentURL, let newURL = URL(string: urlString, relativeTo: baseURL) {
            currentURL = newURL
        } else {
            return
        }

        let task = URLSession.shared.dataTask(with: currentURL!) { data, _, error in
            if error != nil {
                return
            }
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                return
            }

            self.updateWithMarkdown(text)
        }

        task.resume()
    }

//    private func markdownToHTML(text: String) -> String {
//        let parser = MarkdownParser()
//        let result = parser.parse(text)
//        return result.html
//    }

    private func updateWithMarkdown(_ markdownString: String) {
//        let a = TagTuner {
//            Attrs().akaLink($0.tag.attributes["href"] ?? "").foregroundColor(.blue)
//        }
//
//        let base = Attrs().font(UIFont(name: "HelveticaNeue", size: 12)!)
//
//        let italicBoldTuner = TagTuner { info in
//            var set = Set<String>()
//            set.insert(info.tag.name)
//            info.outerTags.forEach { set.insert($0.name) }
//
//            let attrs = Attrs()
//            if set.contains("b") && set.contains("i") {
//                attrs.font(UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!)
//            } else if set.contains("i") {
//                attrs.font(UIFont(name: "HelveticaNeue-Italic", size: 12)!)
//            } else if set.contains("b") {
//                attrs.font(UIFont(name: "HelveticaNeue-Bold", size: 12)!)
//            }
//            return attrs
//        }
//
//        let ignore = TagTuner { _ in
//            [:]
//        } transform: {
//            switch $1 {
//            case .opening:
//                return nil
//            case .closing:
//                return nil
//            case .content:
//                return ""
//            }
//        }
//
//        let attributedText = htmlString
//            .style(tags: ["a": a,
//                          "style": ignore,
//                          "script": ignore,
//                          "head": ignore,
//                          "u": Attrs().underlineStyle(.single),
//                          "title": Attrs().font(UIFont(name: "HelveticaNeue-Bold", size: 18)!),
//                          "h1": Attrs().font(UIFont(name: "HelveticaNeue-Bold", size: 16)!),
//                          "h2": Attrs().font(UIFont(name: "HelveticaNeue-Bold", size: 14)!),
//                          "i": italicBoldTuner,
//                          "b": italicBoldTuner])
//            .styleBase(base)
//            .attributedString

        let document = Document(parsing: markdownString)

        var markdownosaur = Markdownosaur()
        let attributedText = markdownosaur.attributedString(from: document)

        DispatchQueue.main.async {
            self.attributedTextView.attributedText = attributedText
            self.attributedTextView.resetContentOffset()
        }
    }
}

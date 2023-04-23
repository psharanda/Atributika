//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import UIKit

typealias TableViewCellStyle = UITableViewCell.CellStyle

extension String {
    func styleAsTweet() -> AttributedStringBuilder {
        let baseLinkAttrs = Attrs().foregroundColor(.blue)

        let a = TagTuner { tag in
            Attrs(baseLinkAttrs).akaLink(tag.attributes["href"] ?? "")
        }

        let hashtag = DetectionTuner { d in
            Attrs(baseLinkAttrs).akaLink("https://twitter.com/hashtag/\(d.text.replacingOccurrences(of: "#", with: ""))")
        }

        let mention = DetectionTuner { d in
            Attrs(baseLinkAttrs).akaLink("https://twitter.com/\(d.text.replacingOccurrences(of: "@", with: ""))")
        }

        let link = DetectionTuner { d in
            Attrs(baseLinkAttrs).akaLink(d.text)
        }

        return style(tags: ["a": a])
            .styleHashtags(hashtag)
            .styleMentions(mention)
            .styleLinks(link)
    }
}

class AttributedLabelDemoViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()

    private var tweets: [String] = [
        "Thank you for everything. My last ask is the same",
        "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link</a>",
        "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars😊 https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link that won't detect click here</a>",
        "For every retweet this gets, Pedigree will donate one bowl of dog food to dogs in need! 😊 #tweetforbowls",
        "All the love as always. H",
        "We got kicked out of a @Delta airplane because I spoke Arabic to my mom on the phone and with my friend slim... WTFFFFFFFF please spread",
        "Thank you for everything. My last ask is the same as my first. I'm asking you to believe—not in my ability to create change, but in yours.",
        "Four more years.",
        "RT or tweet #camilahammersledge for a follow 👽",
        "Denny JA: Dengan RT ini, anda ikut memenangkan Jokowi-JK. Pilih pemimpin yg bisa dipercaya (Jokowi) dan pengalaman (JK). #DJoJK",
        "Always in my heart @Harry_Styles . Yours sincerely, Louis",
        "HELP ME PLEASE. A MAN NEEDS HIS NUGGS https://pbs.twimg.com/media/C8sk8QlUwAAR3qI.jpg",
        "Подтверждая номер телефона, вы\nпринимаете «<a>пользовательское соглашение</a>»",
        "Here's how a similar one was solved 😄 \nhttps://medium.com/@narcelio/solving-decred-mockingbird-puzzle-5366efeaeed7\n",
        "#Hello @World!",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension AttributedLabelDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? TweetCell) ?? TweetCell(style: .default, reuseIdentifier: cellId)
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AttributedLabelDemoDetailsViewController()

        var x20 = String()

        for _ in 0 ..< 20 {
            x20.append(tweets[indexPath.row])
            x20.append("\n")
        }

        vc.tweet = x20
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.flashScrollIndicators()

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: animated)
        }
    }
}

class TweetCell: UITableViewCell {
    private let tweetLabel = AttributedLabel()

    override init(style: TableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        tweetLabel.onLinkTouchUpInside = { _, val in
            if let linkStr = val as? String {
                if let url = URL(string: linkStr) {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        contentView.addSubview(tweetLabel)

        let marginGuide = contentView.layoutMarginsGuide

        tweetLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        tweetLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        tweetLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        tweetLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        // tweetLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true

        tweetLabel.numberOfLines = 0
        tweetLabel.font = .preferredFont(forTextStyle: .body)
        // tweetLabel.highlightedLinkAttributes = Attrs().underlineStyle(.single).attributes
        tweetLabel.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes
        tweetLabel.linkHighlightViewFactory = DemoLinkHighlightViewFactory()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tweet: String? {
        didSet {
            guard let tweet = tweet else {
                return
            }

            tweetLabel.attributedText = tweet.styleAsTweet().attributedString
        }
    }
}

class AttributedLabelDemoDetailsViewController: UIViewController {
    private let attributedTextView = AttributedTextView()

    var tweet: String? {
        didSet {
            guard let tweet = tweet else {
                return
            }

            attributedTextView.attributedText = tweet.styleAsTweet().attributedString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AttributedTextView"
        view.backgroundColor = .white
        view.addSubview(attributedTextView)

        attributedTextView.isScrollEnabled = true
        attributedTextView.isSelectable = true
        attributedTextView.alwaysBounceVertical = true
        attributedTextView.numberOfLines = 0
        attributedTextView.highlightedLinkAttributes = Attrs().underlineStyle(.single).foregroundColor(.init(red: 0, green: 0, blue: 0.5, alpha: 1)).attributes
        attributedTextView.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes
        attributedTextView.linkHighlightViewFactory = DemoLinkHighlightViewFactory()
        attributedTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        attributedTextView.onLinkTouchUpInside = { _, val in
            if let linkStr = val as? String {
                if let url = URL(string: linkStr) {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        attributedTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            attributedTextView.topAnchor.constraint(equalTo: view.topAnchor),
            attributedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            attributedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            attributedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    @objc private func labelOnTouchUpInside(_ sender: AttributedLabel) {
        if let linkStr = sender.highlightedLinkValue as? String {
            if let url = URL(string: linkStr) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

class HighlightView: UIView, LinkHighlightViewProtocol {
    func didAdd(to _: Atributika.BaseAttributedTextView) {
        alpha = 0

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }

    func removeFrom(textView _: Atributika.BaseAttributedTextView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState]) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

class DemoLinkHighlightViewFactory: LinkHighlightViewFactoryProtocol {
    func createView(enclosingRects: [CGRect]) -> UIView & LinkHighlightViewProtocol {
        let view = HighlightView()
        view.isUserInteractionEnabled = false

        let path = UIBezierPath()

        enclosingRects.forEach { rect in
            path.append(UIBezierPath(roundedRect: rect.insetBy(dx: -2, dy: -4), cornerRadius: 4))
        }

        let layer = CAShapeLayer()
        layer.fillColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        layer.path = path.cgPath

        view.layer.addSublayer(layer)

        return view
    }
}

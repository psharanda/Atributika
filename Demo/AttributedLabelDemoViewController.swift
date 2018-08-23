//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import UIKit
import Atributika

class AttributedLabelDemoViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
    
    private var tweets: [String] = [
        "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link</a>",
        "For every retweet this gets, Pedigree will donate one bowl of dog food to dogs in need! 😊 #tweetforbowls",
        "All the love as always. H",
        "We got kicked out of a @Delta airplane because I spoke Arabic to my mom on the phone and with my friend slim... WTFFFFFFFF please spread",
        "Thank you for everything. My last ask is the same as my first. I'm asking you to believe—not in my ability to create change, but in yours.",
        "Four more years.",
        "RT or tweet #camilahammersledge for a follow 👽",
        "Denny JA: Dengan RT ini, anda ikut memenangkan Jokowi-JK. Pilih pemimpin yg bisa dipercaya (Jokowi) dan pengalaman (JK). #DJoJK",
        "Always in my heart @Harry_Styles . Yours sincerely, Louis",
        "HELP ME PLEASE. A MAN NEEDS HIS NUGGS https://pbs.twimg.com/media/C8sk8QlUwAAR3qI.jpg"
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "AttributedLabel"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? TweetCell) ?? TweetCell(style: .default, reuseIdentifier: cellId)
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class TweetCell: UITableViewCell {
    private let tweetLabel = AttributedLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        tweetLabel.onClick = { label, detection in
            switch detection.type {
            case .hashtag(let tag):
                if let url = URL(string: "https://twitter.com/hashtag/\(tag)") {
                    UIApplication.shared.openURL(url)
                }
            case .mention(let name):
                if let url = URL(string: "https://twitter.com/\(name)") {
                    UIApplication.shared.openURL(url)
                }
            case .link(let url):
                UIApplication.shared.openURL(url)
            case .tag(let tag):
                if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                    UIApplication.shared.openURL(url)
                }
            default:
                break
            }
        }

        contentView.addSubview(tweetLabel)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        tweetLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        tweetLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        tweetLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        tweetLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        tweetLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tweet: String? {
        didSet {
            let all = Style.font(.systemFont(ofSize: 20))
            let link = Style("a")
                .foregroundColor(.blue, .normal)
                .foregroundColor(.brown, .highlighted)

            tweetLabel.attributedText = tweet?
                .style(tags: link)
                .styleHashtags(link)
                .styleMentions(link)
                .styleLinks(link)
                .styleAll(all)
        }
    }
}




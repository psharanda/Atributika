
<p align="center">
  <img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/logo@2x.png" alt="" width="392" />
</p>
<br>

[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/psharanda/Atributika)
[![CocoaPods](https://img.shields.io/cocoapods/p/Atributika.svg?style=plastic)](https://cocoapods.org/pods/Atributika)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Atributika` is an easy and painless way to build NSAttributedString. It is able to detect HTML-like tags, links, phone numbers, hashtags, any regex or even standard ios data detectors and style them with various attributes like font, color, etc. `Atributika` comes with drop-in label replacement `AttributedLabel` which is able to make any detection clickable

## Intro
NSAttributedString is really powerful but still a low level API which requires a lot of work to setup things. It is especially painful if string is template and real content is known only in runtime. If you are dealing with localizations, it is also not easy to build NSAttributedString. 

Oh wait, but you can use Atributika!

```swift
let b = Attrs.font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
        
label.attributedText = "Hello <b>World</b>!!!".style(tags: ["b": b]).attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/main.png" alt="" width="139" />

Yeah, that's much better. Atributika is easy, declarative, flexible and covers all the raw edges for you.


## Features

+ AttributedLabel` is a drop-in label replacement which **makes detections clickable** and style them dynamically for `normal/highlighted/disabled` states.
+ detect and style HTML-like **tags** using custom speedy parser
+ detect and style **hashtags** and **mentions** (i.e. #something and @someone)
+ detect and style **links** and **phone numbers**
+ detect and style regex and NSDataDetector patterns
+ style whole string or just particular ranges
+ ... and you can chain all above to parse some uber strings!
+ clean and expressive api to build styles
+ separate set of detection utils, in case you want to use just them
+ `+` operator to concatenate NSAttributedString with other attributed or regular strings
+ works on iOS, tvOS, watchOS, macOS

## V4 -> V5

V5 is a major rewrite of the project. 

NSAttributedString building
+ HTML parser completely rewritten, supports more edge cases
+ Text transforming and attributes fine tuning depening from detected text

AttributedLabel / AttributedTextView
+ proper accessibility support
+ doesn't depend from the string building code and classes
+ better performance and touch handling
+ subclass off UIControl
+ AttributedLabel based on UILabel (more lightweight, text is centered vertically), AttributedTextView based on UITextView (supports scrolling and text selections, text is aligned to the top of the frame)

`Style("xxx").`/`Style.` -> Attr.
`styleAll` -> `styleBase`

AttributedLabel api is reworked a lot see updated example below


## Examples

### Detect and style tags, provide base style for the rest of string, don't forget about special html symbols

```swift
let redColor = UIColor(red:(0xD0 / 255.0), green: (0x02 / 255.0), blue:(0x1B / 255.0), alpha:1.0)
let a = Attrs.foregroundColor(redColor)

let font = UIFont(name: "AvenirNext-Regular", size: 24)!
let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
let base = Style.font(font).foregroundColor(grayColor)

let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>"
    .style(tags: ["a": a])
    .styleBase(base)
    .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_atributika_logo.png" alt="" width="188" />

### Detect and style hashtags and mentions

```swift
let str = "#Hello @World!!!"
    .styleHashtags(Attrs.font(.boldSystemFont(ofSize: 45)))
    .styleMentions(Attrs.foregroundColor(.red))
    .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_hashtags_mentions.png" alt="" width="232" />


### Detect and style links

```swift
let str = "Check this website http://google.com"
    .styleLinks(Attrs.foregroundColor(.blue))
    .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_links.png" alt="" width="237" />

### Detect and style phone numbers

```swift
let str = "Call me (888)555-5512"
    .stylePhoneNumbers(Attrs.foregroundColor(.red))
    .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_phone_numbers.png" alt="" width="195" />

### Uber String

```swift
    let links = Attrs.foregroundColor(.blue)
    let phoneNumbers = Attrs.backgroundColor(.yellow)
    let mentions = Attrs.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
    let b = Attrs.font(.boldSystemFont(ofSize: 12))
    let u = Attrs.underlineStyle(.single)

    let base = Attrs.font(.systemFont(ofSize: 12)).foregroundColor(.gray)

    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika"
        .style(tags: ["u": u, "b": b])
        .styleMentions(mentions)
        .styleHashtags(links)
        .styleLinks(links)
        .stylePhoneNumbers(phoneNumbers)
        .styleBase(base)
        .attributedString

    return str
```    

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_uber.png" alt="" width="342" />

## Attrs

## AttributedStringBuilder

## TagTuning

## DetectionTuning

## AttributedLabel
`AttributedLabel` displays `NSAttributedString` and makes links clickable. Links needs to be added as attribute using `.attributedLabelLink` key. Value for this key can be of any type, conventional builder using String. 

```swift

let tweetLabel = AttributedLabel()

tweetLabel.numberOfLines = 0
tweetLabel.highlightedLinkAttributes = Attrs.foregroundColor(.red)

let a = TagTuner { tag in
    Attrs.foregroundColor(.blue).attributedLabelLink(tag.attributes["href"] ?? "")
}

let hashtag = DetectionTuner { d in
    Attrs.foregroundColor(.blue).attributedLabelLink("https://twitter.com/hashtag/\(d.text.replacingOccurrences(of: "#", with: ""))")
}

let mention = DetectionTuner { d in
    Attrs.foregroundColor(.blue).attributedLabelLink("https://twitter.com/\(d.text.replacingOccurrences(of: "@", with: ""))")
}

let link = DetectionTuner { d in
    Attrs.foregroundColor(.blue).attributedLabelLink(d.text)
}

let tweet = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika" 

tweetLabel.attributedText = tweet
    .style(tags: ["a": a])
    .styleHashtags(hashtag)
    .styleMentions(mention)
    .styleLinks(link)
    .attributedString

    tweetLabel.onLinkTouchUpInside = { _, val in
        if let linkStr = val as? String {
            if let url = URL(string: linkStr) {
                UIApplication.shared.openURL(url)
            }
        }
    }

view.addSubview(tweetLabel)

```
<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test_attributedlabel.png" alt="" width="361" />

## Requirements

Current version is compatible with:

* Swift 4.0+ (for Swift 3.2 use `swift-3.2` branch)
* iOS 9.0 or later
* tvOS 9.0 or later
* watchOS 2.0 or later
* macOS 10.10 or later

Note: `AttributedLabel` works only on iOS

## Why does Atributika have one 't' in its name?
Because in Belarusian/Russian we have one letter 't' (атрыбутыка/атрибутика). So basically it is transcription, not real word.

## Integration

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/psharanda/Atributika.git", .exact("5.0.0"))
  ],
  targets: [
    .target(name: "MyProject", dependencies: ["Atributika"])
  ]
)
```

```bash
$ swift build
```

### Carthage

Add `github "psharanda/Atributika"` to your `Cartfile`

### CocoaPods
Atributika is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Atributika"
```

### Manual
1. Add Atributika to you project as a submodule using `git submodule add https://github.com/psharanda/Atributika.git`
2. Open the `Atributika` folder & drag `Atributika.xcodeproj` into your project tree
3. Add `Atributika.framework` to your target's `Link Binary with Libraries` Build Phase
4. Import Atributika with `import Atributika` and you're ready to go

## License

Atributika is available under the MIT license. See the LICENSE file for more info.

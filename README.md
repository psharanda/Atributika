
<p align="center">
  <img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/logo@2x.png" alt="" width="392" height="45">
</p>
<br>
[![Build Status](https://travis-ci.org/oarrabi/SwiftRichString.svg?branch=master)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-tvos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-watchos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/psharanda/Atributika)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftRichString.svg)](https://cocoapods.org/pods/Atributika)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Atributika` is an easy and painless way to build NSAttributedString. It is able to detect HTML-like tags, hashtags, any regex or even standard ios data detectors and style them with various attributes like font, color, etc. 

## Intro
NSAttributedString is really powerful but still a low level API which requires a lot of work to setup things. It is especially painful if string is template and real content is known only in runtime. If you are dealing with localizations it is also not easy to build NSAttributedString. 

Oh wait, but you can use Atributika!

```swift
let b = Style("b").font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
let str = "Hello <b>World</b>!!!".style(tags: b)
              .styleAll(Style.font(.systemFont(ofSize: 20)))
              .attributedString
        
label.attributedText = str
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/main.png" alt="" width="139" height="56" />

Yeah, that's much better. Atributika is easy, declarative, flexible and covers all the raw edges for you.

## Features

+ detect and style HTML-like markup using custom speedy parser
+ detect and style hashtags and mentions (i.e. #something and @someone)
+ detect and style regex and NSDataDetector patterns
+ style whole string or just particular ranges
+ ... and you can chain all this to parse some uber strings!
+ clean and expressive api to build styles
+ separate set of detection utils, in case you want to use just them
+ `+` operator to concatenate NSAttributedString with other attributed or regular strings
+ works on iOS, tvOS, watchOS, macOS

## Examples

### Detect and style tags, provide base style for the rest of string, don't forget about special html symbols

```swift
let font = UIFont(name: "AvenirNext-Regular", size: 24)!

let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
let redColor = UIColor(red:(0xD0 / 255.0), green: (0x02 / 255.0), blue:(0x1B / 255.0), alpha:1.0)

let a = Style("a").foregroundColor(redColor)

let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>".style(tags: a)
            .styleAll(Style.font(font).foregroundColor(grayColor))
            .attributedString

```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test1.png" alt="" width="136" height="44" />

### Detect and style hashtags and mentions

```swift
let str = "#Hello @World!!!"
            .styleHashtags(Style.font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Style.foregroundColor(.red))
            .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test2.png" alt="" width="232" height="63" />

### Detect and style NSDataDetector patterns

```swift
let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
let str = "Call me (888)555-5512".style(textCheckingTypes: types.rawValue, style:
            Style.foregroundColor(.red))
).attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test3.png" alt="" width="196" height="38" />

### Uber String

```swift
let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is
           called <b>Atributika</b>. Call me if you want to ask any details (123)456-7890
           #swift #nsattributedstring"
    .style(tags:
        Style("u").font(.boldSystemFont(ofSize: 12)).underlineStyle(.styleSingle),
        Style("b").font(.boldSystemFont(ofSize: 12))
    )
    .styleAll(Style.font(.systemFont(ofSize: 12)).foregroundColor(.gray))
    .styleMentions(Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black))
    .styleHashtags(Style.foregroundColor(.blue))
    .style(textCheckingTypes: types.rawValue, style: Style.backgroundColor(.yellow))
    .attributedString
```    

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test4.png" alt="" width="334" height="67" />

### TTTAtributedLabel integration

```swift
let all = Style.foregroundColor(.gray).font(.systemFont(ofSize: 16))
let link = Style("a").foregroundColor(.blue)
let activeLink = Style.foregroundColor(.brown)

label.activeLinkAttributes = activeLink.attributes
label.numberOfLines = 0
label.delegate = self

let aka = "If only Bradley's arm was longer. Best photo ever. #oscars <a href=\"https://pic.twitter.com/C9U5NOtGap\">pic.twitter.com/C9U5NOtGap</a>".style(tags: link)
    .styleAll(all)
    .styleHashtags(link)

aka.detections.forEach { detection in
    switch detection.type {
    case .hashtag:
        let startIndex = aka.string.index(aka.string.startIndex, offsetBy: detection.range.lowerBound + 1)
        let endIndex = aka.string.index(aka.string.startIndex, offsetBy: detection.range.lowerBound + detection.range.count - 1)

        let hashtag = (aka.string[startIndex...endIndex])

        label.addLink(to: URL(string: "https://twitter.com/hashtag/\(hashtag)"), with: NSRange(detection.range))
    case .tag(let tag):
        if tag.name == "a", let href = tag.attributes["href"] {
            label.addLink(to: URL(string: href), with: NSRange(detection.range))
        }
    default:
        break
    }
}

label.attributedText = aka.attributedString

...

// implement TTTAttributedLabelDelegate to handle clicks
extension XXX: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}
```

## Requirements

Current version is compatible with:

* Swift 3.0+
* iOS 8.0 or later
* tvOS 9.0 or later
* watchOS 2.0 or later
* macOS 10.10 or later

## Why does Atributika have one 't' in its name?
Because in belarusian/russian we have one letter 't' (атрыбутыка/атрибутика). So basically it is transcription, not real word.

## Integration

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

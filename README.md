
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
Atributika is able to detect and style next things
+ HTML-like markup
+ hashtags (i.e. #something)
+ mentions (i.e. @someone)
+ regex
+ whatever is possible with NSDataDetector (phones, emails, addresses etc)
+ regular ranges

... and you can chain all this to parse some uber strings!

More than this Atributika:
+ works on iOS, tvOS, watchOS, macOS
+ uses high performant custom HTML-like markup parser
+ provides information about WHAT was detected and at WHERE (ranges)
+ has syntax sugar to create styles easily using chaining
+ has separate set of detection utils, in case you want to use just them
+ `+` operator to concatenate NSAttributedString with other attributed or regular strings

## Examples

### Detect and style tags, provide base style for the rest of string

```swift
let str = "Hello <b>World</b>!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 15)))
            .styleAll(Style.font(.systemFont(ofSize: 12)))
            .attributedString
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/test1.png" alt="" width="101" height="33" />

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

# Atributika
`Atributika` is an easy and painless way to build NSAttributedString. It is able to detect HTML-like tags, hashtags, any regex or even standard ios data detectors and style them with various attributes like font, color, etc. 

[![Build Status](https://travis-ci.org/oarrabi/SwiftRichString.svg?branch=master)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-tvos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-watchos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)](https://travis-ci.org/psharanda/Atributika)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/psharanda/Atributika)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftRichString.svg)](https://cocoapods.org/pods/Atributika)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Intro
NSAttributedString is really powerful but still a low level API which requires a lot of work to setup things. It is especially painful if string is template and real content is known only in runtime. If you are dealing with localizations it is also not easy to build NSAttributedString. 

Oh wait, but you can use Atributika!

```swift
let string = "Hello <b>World</b>!!!".styled(tags:
  Style("b").font(.boldSystemFont(ofSize: 45))
).attributedString
```

Yeah, that's much better. Atributika is easy, declarative, flexible and covers all the raw edges for you.

## Features
Atributika is able to detect and style next things
+ HTML-like markup
+ hashtags (i.e. #something)
+ mentions (i.e. @someone)
+ regex
+ whatever is possible with NSDataDetector (phones, emails, addresses etc)
+ regular ranges
+ and you can chain all this to parse some uber strings!

More than this Atributika:
+ not just detect and style, but also provide all information about what was detected and at what range
+ has syntax sugar to create styles easily using chaining
+ separate set of detection utils, in case you want something special
+ `+` operator to concatenate NSAttributedString with other attributed or regular strings

## Why Atributika does have one 't' in its name
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

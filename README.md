# Atributika
NSAttributedString builder using HTML-like tags written in Swift

## Intro

NSAttributedString is really powerful but still a low level API which requires a lot of work to setup things. It is especially painful when we are dealing with template string and real content is known only in runtime. If you are dealing with localizations it is also a case to build proper NSAttributedString. 

```swift
let name = "World"
let str = NSMutableAttributedString(string: "Hello \(name)!!!")
        
str.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)],
                range: NSMakeRange(6, 5)) // uh, hardcoding range...
//-OR-
str.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)],
                range: NSString(string: str.string).rangeOfString(name)) 
// uh, what if we have many %name%, still bad, and that ugly casting to NSString...
// -OR- some good solution will take like 20 lines of code, and still will be not so flexible
```
Actually other NSAttributedString wrappers will not help since we still have to deal with ranges.

What to do? Use Atributika!

```swift
let str = Atributika(text: "Hello <bold>\(name)</bold>!!!",
           tags: [
            "bold" : [
                .Font(UIFont.boldSystemFontOfSize(45)),
            ]
    ]).buildAttributedString()
```

Yeah, that's much better. Atributika is easy, declarative, flexible and covers all the raw edges for you.

## Features
+ HTML-like tags
+ tags can have any name and any style and be nested
+ leightweight and fast parser
+ swifty typesafe attributes
+ default attributes
+ support of `&amp;`, `&lt;` etc 
+ `<br>` tag

## Usage

```swift
label = UILabel()
        label.numberOfLines = 0
        label.attributedText = Atributika(text: "Hello<br><b>Wo<red>rl<u>d</u></red></b>!!!",
                                          tags: [
                                            "b" : [
                                                .Font(UIFont.boldSystemFontOfSize(45)),
                                            ],
                                            "red" : [
                                                .ForegroundColor(UIColor.redColor())
                                            ],
                                            "u" : [
                                                .UnderlineStyle(.StyleSingle)
                                            ]
                                            
            ]).buildAttributedString()
        view.addSubview(label)
```

<img src="https://raw.githubusercontent.com/psharanda/Atributika/master/README/demo.png" alt="Hello Atributika!!!" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="191" height="84" />

## Available Attributes

| Attribute  | Enum Item |
| ------------- | ------------- |
| NSAttachmentAttributeName | `Attachment(NSTextAttachment)` |
| NSBackgroundColorAttributeName | `BackgroundColor(UIColor)` |
| NSBaselineOffsetAttributeName | `BaselineOffset(Float)` |
| NSExpansionAttributeName | `Expansion(Float)` |
| NSFontAttributeName | `Font(UIFont)` |
| NSForegroundColorAttributeName | `ForegroundColor(UIColor)` |
| NSKernAttributeName | `Kern(Float)` |
| NSLigatureAttributeName | `Ligature(Int)` |
| NSLinkAttributeName | `Link(String)` |
| NSLinkAttributeName | `LinkURL(NSURL)` |
| NSObliquenessAttributeName | `Obliqueness(Float)` |
| NSParagraphStyleAttributeName | `ParagraphStyle(NSParagraphStyle)` |
| NSShadowAttributeName | `Shadow(NSShadow)` |
| NSStrikethroughColorAttributeName | `StrikethroughColor(UIColor)` |
| NSStrikethroughStyleAttributeName  | `StriketroughStyle(NSUnderlineStyle)`  |
| NSStrokeColorAttributeName | `StrokeColor(UIColor)` |
| NSStrokeWidthAttributeName| `StrokeWidth(Float)` |
| NSTextEffectAttributeName | `TextEffect(String)` |
| NSUnderlineColorAttributeName | `UnderlineColor(UIColor)` |
| NSUnderlineStyleAttributeName  | `UnderlineStyle(NSUnderlineStyle)`  |
| NSVerticalGlyphFormAttributeName | `VerticalGlyphForm(Int)` |
| NSWritingDirectionAttributeName | `WritingDirection(NSWritingDirection)` |

## Integration

### Carthage

Add `github "psharanda/Atributika"` to your `Cartfile`

### Manual

#### iOS 8+
1. Add Atributika to you project as a submodule using `git submodule add https://github.com/psharanda/Atributika.git`
2. Open the `Atributika` folder & drag `Atributika.xcodeproj` into your project tree
3. Add `Atributika.framework` to your target's `Link Binary with Libraries` Build Phase
4. Import Atributika with `import Atributika` and you're ready to go

#### iOS 7+
To manually install Atributika, download this repository and drag `Atributika.swift` and `NSScanner+Swift.swift` into your project tree.

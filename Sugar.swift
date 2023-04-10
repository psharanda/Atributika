//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public var Style: Attributes {
    return Attributes()
}

public extension String {
    func style(tags: [String: TagTuning]) -> AttributedStringBuilder {
        return AttributedStringBuilder(htmlString: self, tags: tags)
    }

    func styleBase(_ attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self, baseAttributes: attributes)
    }

    func styleHashtags(_ attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).styleHashtags(attributes)
    }

    func styleMentions(_ attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).styleMentions(attributes)
    }

    func style(regex: String, options: NSRegularExpression.Options = [], attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).style(regex: regex, options: options, attributes: attributes)
    }

    func style(textCheckingTypes: NSTextCheckingResult.CheckingType, attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).style(textCheckingTypes: textCheckingTypes, attributes: attributes)
    }

    func stylePhoneNumbers(_ attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).stylePhoneNumbers(attributes)
    }

    func styleLinks(_ attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).styleLinks(attributes)
    }

    func style(range: Range<String.Index>, attributes: AttributesProvider) -> AttributedStringBuilder {
        return AttributedStringBuilder(string: self).style(range: range, attributes: attributes)
    }
}

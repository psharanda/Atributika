//
//  AttributtedLabelView.swift
//  Demo
//
//  Created by Ernesto Rivera on 5/14/20.
//  Copyright © 2020 Atributika. All rights reserved.
//

import SwiftUI
import Atributika

@available(iOS 13.0, *)
struct AttributtedLabelView: UIViewRepresentable
{
    var attributedText: AttributedText?
    
    @State var maxWidth: CGFloat = 300
    
    typealias UIViewType = MaxWidthAttributedLabel
    
    func makeUIView(context: Context) -> MaxWidthAttributedLabel
    {
        let view = MaxWidthAttributedLabel()
        view.numberOfLines = 0
        view.textColor = .label
        return view
    }
    
    func updateUIView(_ uiView: MaxWidthAttributedLabel, context: Context)
    {
        uiView.attributedText = self.attributedText
        uiView.maxWidth = self.maxWidth
    }
    
    class MaxWidthAttributedLabel: AttributedLabel
    {
        var maxWidth: CGFloat!
        
        open override var intrinsicContentSize: CGSize
        {
            self.sizeThatFits(CGSize(width: self.maxWidth, height: .infinity))
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct AttributtedLabelView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let all = Style.font(UIFont.preferredFont(forTextStyle: .body))
        let link = Style("a")
            .foregroundColor(.blue, .normal)
            .foregroundColor(.brown, .highlighted)
        
        return List {
            AttributtedLabelView(attributedText: "Denny JA: Dengan RT ini, anda ikut memenangkan Jokowi-JK. Pilih pemimpin yg bisa dipercaya (Jokowi) dan pengalaman (JK). #DJoJK"
                .style(tags: link)
                .styleHashtags(link)
                .styleMentions(link)
                .styleLinks(link)
                .styleAll(all))
                .fixedSize(horizontal: true, vertical: true)
            AttributtedLabelView(attributedText: "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link</a>"
                .style(tags: link)
                .styleHashtags(link)
                .styleMentions(link)
                .styleLinks(link)
                .styleAll(all))
                .fixedSize(horizontal: true, vertical: true)
            AttributtedLabelView(attributedText: """
            # A big message

            - With *mentions* [Ernesto Test Account](user://91010061)
            - **Bold** text

            ## Also

            > Quotes

            1. Some `code`
            2. And data detectors  (801) 917 4444, email@dot.com and http://apple.com
            """
                .style(tags: link)
                .styleHashtags(link)
                .styleMentions(link)
                .styleLinks(link)
                .styleAll(all))
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}
#endif


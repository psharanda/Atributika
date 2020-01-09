//
//  IBViewController.swift
//  Demo
//
//  Created by Pavel Sharanda on 12/17/19.
//  Copyright © 2019 Atributika. All rights reserved.
//

import UIKit
import Atributika

class IBViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font: UIFont
        if #available(iOS 11.0, *) {
            font = UIFont.preferredFont(forTextStyle: .body)
        } else {
            font = UIFont.systemFont(ofSize: 16)
        }

        let button = Style("button")
            .underlineStyle(.styleSingle)
            .font(font)
            .foregroundColor(.black, .normal)
            .foregroundColor(.red, .highlighted)
        
        if #available(iOS 10.0, *) {
            attributedLabel.adjustsFontForContentSizeCategory = true
        }
        attributedLabel.attributedText = "Hello! <button>Need to register?</button>".style(tags: button).styleAll(.font(.systemFont(ofSize: 12)))
        
        
       setupIssue101Label()
    }
    
    private func setupIssue101Label() {
        let message = "<p>Well This is a paragraph</p><a href=\"www.google.com\" target=\"_blank\">Check this out</a><br>"
               
        let transformers: [TagTransformer] = [
           TagTransformer.brTransformer,
           TagTransformer(tagName: "p", tagType: .start, replaceValue: "\n"),
           TagTransformer(tagName: "p", tagType: .end, replaceValue: "\n")
        ]
        let isMymessage = false
        
        let p = Style("p")
        var links = Style("a")
        links = (isMymessage ? links.foregroundColor(.green, .normal) : links .foregroundColor(.yellow, .highlighted)).foregroundColor(.purple, .highlighted)
        var font = Style.font(.systemFont(ofSize: 16))
        font = isMymessage ? font.foregroundColor(.black) : font.foregroundColor(.gray)
        issue101Label.numberOfLines = 0
        issue101Label.attributedText = message
            .style(tags: p, links, transformers: transformers)
            .styleLinks(links)
            .styleAll(font)
        
        issue101Label.onClick = { label, detection in
            print(detection)
        }
    }
    
    @IBOutlet private var attributedLabel: AttributedLabel!
    @IBOutlet private var issue101Label: AttributedLabel!
}

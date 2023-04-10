//
//  IBViewController.swift
//  Demo
//
//  Created by Pavel Sharanda on 12/17/19.
//  Copyright © 2019 Atributika. All rights reserved.
//

import Atributika
import UIKit

class IBViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let font: UIFont
        if #available(iOS 11.0, *) {
            font = UIFont.preferredFont(forTextStyle: .body)
        } else {
            font = UIFont.systemFont(ofSize: 16)
        }

        let button = Attrs
            .underlineStyle(.styleSingle)
            .font(font)

        if #available(iOS 10.0, *) {
            attributedLabel.adjustsFontForContentSizeCategory = true
        }
        attributedLabel.attributedText = "Hello! <button>Need to register?</button>"
            .style(tags: ["button": button])
            .styleBase(Attrs.font(.systemFont(ofSize: 12)))
            .attributedString

        setupTopLabels()
    }

    private func setupTopLabels() {
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. <button>Need to register?</button> Cras eu auctor est. Vestibulum ornare dui ut orci congue placerat. Nunc et tortor vulputate, elementum quam at, tristique nibh. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque ut mauris eu felis venenatis condimentum finibus ac nisi. Nulla id turpis libero. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam pulvinar lorem eu metus scelerisque, non lacinia ligula molestie. Vivamus vestibulum sem sit amet pellentesque tristique. Aenean hendrerit mi turpis. Mauris tempus viverra mauris, non accumsan leo aliquet nec. Suspendisse in ipsum ut arcu mollis bibendum."

        let button = Attrs
            .underlineStyle(.styleSingle)
            .font(.systemFont(ofSize: 30))
            .foregroundColor(.black)

        issue103Label.numberOfLines = 0
        issue103Label.attributedText = message
            .style(tags: ["button": button])
            .styleBase(Attrs.font(.systemFont(ofSize: 30)))
            .attributedString

        issue103Label.onLinkTouchUpInside = { _, value in
            print(value)
        }

        pinkLabel.attributedText = "Lorem ipsum dolor sit amet".styleBase(Attrs).attributedString
    }

    @IBOutlet private var attributedLabel: AttributedLabel!
    @IBOutlet private var issue103Label: AttributedLabel!
    @IBOutlet private var pinkLabel: AttributedLabel!
}

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
            let systemFont = UIFont.systemFont(ofSize: 16)
            let metrics = UIFontMetrics(forTextStyle: .body)
            font = metrics.scaledFont(for: systemFont)
        } else {
            font = UIFont.systemFont(ofSize: 16)
        }

        let button = Style("button")
            .underlineStyle(.styleSingle)
            .font(font)
            .foregroundColor(.black, .normal)
            .foregroundColor(.red, .highlighted)
        
        attributedLabel.attributedText = "<button>Need to register?</button>".style(tags: button)
    }
    
    @IBOutlet private var attributedLabel: AttributedLabel!
}

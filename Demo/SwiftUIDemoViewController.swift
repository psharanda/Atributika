//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct ContentView: View {
    var body: some View {
        List {
            ForEach(tweets, id: \.self) {
                AttrLabel(attributedString: $0.styleAsTweet().attributedString).padding(5)
            }
        }
    }
}

@available(iOS 13.0, *)
class SwiftUIDemoViewController: UIHostingController<ContentView> {}

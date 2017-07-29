//
//  Manipulation.swift
//  Atributika
//
//  Created by Booth, Robert on 7/28/17.
//  Copyright © 2017 Atributika. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public struct Mutation: AtributikaManipulationProtocol {
    
    public let name: String
    
    public let attributes: [String: Any]
    
    public let string: String
    
    public let type: ManipulationType
    
    public init(_ name: String = "", _ attributes: [String: Any] = [:]) {
        self.init(name, attributes, "", .append)
    }
    
    private init(_ name: String = "", _ attributes: [String: Any] = [:], _ string: String = "", _ type: ManipulationType = .append) {
        self.name = name
        self.attributes = attributes
        self.string = string
        self.type = type
    }
    
    public func prepend(_ value: String) -> Mutation {
        return Mutation(self.name, self.attributes, value, .prepend)
    }
    
    public func append(_ value: String) -> Mutation {
        return Mutation(self.name, self.attributes, value, .append)
    }
    
    public func replace(_ value: String) -> Mutation {
        return Mutation(self.name, self.attributes, value, .replace)
    }
}

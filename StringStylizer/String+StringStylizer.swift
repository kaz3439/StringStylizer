//
//  String+StringStylizer.swift
//  aaa
//
//  Created by Kazuhiro Hayashi on 4/4/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

extension String {
    /**
     Instantiate StringStylizer<Styling> from caller string.
    
     - returns: StringStylizer<Styling> "StringStylizer" object which is "Styling" state
     */
    func stylize() -> StringStylizer<Styling> {
        let attributer = StringStylizer<Styling>(string: self)
        return attributer
    }
    
    /**
     Instantiate StringStylizer<Styling> with range value from caller string.
     
     - parameter range:Range<UInt> range to apply attributes
     - returns: StringStylizer<Styling> "StringStylizer" object which is "Styling" state
     */
    func stylize(range range: Range<UInt>) -> StringStylizer<RangeSelect> {
        let attributer = StringStylizer<Styling>(string: self)
        return attributer.range(range)
    }
}

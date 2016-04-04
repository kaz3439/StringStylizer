//
//  String+StringStylizer.swift
//  aaa
//
//  Created by Kazuhiro Hayashi on 4/4/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

extension String {
    func stylize() -> StringStylizer<Styling> {
        let attributer = StringStylizer<Styling>(string: self)
        return attributer
    }
    
    func stylize(range range: Range<UInt>) -> StringStylizer<RangeSelect> {
        let attributer = StringStylizer<Styling>(string: self)
        return attributer.range(range)
    }
}
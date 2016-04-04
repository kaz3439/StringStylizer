//
//  Operator.swift
//  aaa
//
//  Created by Kazuhiro Hayashi on 4/4/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let concat = NSMutableAttributedString()
    concat.appendAttributedString(left)
    concat.appendAttributedString(right)
    return concat
}